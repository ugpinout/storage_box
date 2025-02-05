// ignore_for_file: file_names, non_constant_identifier_names, camel_case_types

import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:storage_box/Box.dart';
import 'package:storage_box/module/toast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import 'FileManager.dart';

File_Manager fileManager = File_Manager();

class Box_Manager {
  //创建一个箱子
  Create_New_Box(Box_Name) {
    if (fileManager.Create_New_File(
        app.prj_path,
        DateTime.now().millisecondsSinceEpoch.toString(),
        '{"Box_Name":"$Box_Name","Item_Data":{}}')) {
      return true;
    } else {
      return false;
    }
  }

//获取指定目录下的所有箱子文件里的箱子名字
  Get_All_Box_Name(BuildContext context, File_Path) {
    List<String> Box_Name = [];
    for (int i = 0; i < File_Path.length; i++) {
      if (File_Path[i].toString().endsWith('json\'') == true) {
        String Json_text = File_Path[i].readAsStringSync();
        Map<String, dynamic> jsonData =
            jsonDecode(fileManager.cleanJsonText(Json_text));
        Box_Name.add(jsonData['Box_Name']);
      }
    }
    return Box_Name;
  }

//文件名字和箱子名字加在一起
  Create_Box_Data_Map(file_Path, Box_Name) {
    Map<String, String> Box_Data = {};
    for (int i = 0; i < Box_Name.length; i++) {
      String file_name =
          file_Path[i].uri.pathSegments.last.toString().split('.')[0];
      Box_Data[Box_Name[i]] = file_name;
    }
    return Box_Data;
  }

  //获取一个箱子的名称[用于子页面AppBar上面显示]
  Get_One_Box_Name(id) {
    String Json_text = fileManager.Get_One_File_Text(app.prj_path, id);
    Map<String, dynamic> jsonData =
        jsonDecode(fileManager.cleanJsonText(Json_text));
    return jsonData['Box_Name'];
  }

//获取一个箱子里面的零件数据
  Get_One_Box_Data(id) {
    String Json_text = fileManager.Get_One_File_Text(app.prj_path, id);
    Map<String, dynamic> jsonData =
        jsonDecode(fileManager.cleanJsonText(Json_text));
    return jsonData;
  }

//添加一个零件
  Set_One_Box_Data(id, Item_Name, count, item_id) {
    Map<String, dynamic> jsonData = Get_One_Box_Data(id);
    jsonData['Item_Data'][item_id] = {
      'Item_Name': Item_Name,
      'Item_Count': count,
    };
    fileManager.Set_One_File_Text(app.prj_path, id, jsonEncode(jsonData));
  }

  // 修改箱子名称
  Set_Box_Name(id, name) {
    Map<String, dynamic> jsonData = Get_One_Box_Data(id);
    jsonData['Box_Name'] = name;
    fileManager.Set_One_File_Text(app.prj_path, id, jsonEncode(jsonData));
  }

// 分享一个箱子
  share_One_Box(String id) {
    Share.shareXFiles([XFile('${app.prj_path}/$id.json')], text: "分享箱子id:$id");
  }

// 删除一个箱子
  Del_one_Box(id) {
    fileManager.Del_One_File(app.prj_path, id);
  }

  Future<void> Compress_All_Box() async {
    try {
      // 使用 FilePicker 获取用户选择的目录吧
      String? path = await FilePicker.platform.getDirectoryPath();
      if (path != null) {
        // 检查是否已经授予存储权限
        if (await Permission.storage.isGranted == false) {
          // 请求 MANAGE_EXTERNAL_STORAGE 权限
          var status = await Permission.manageExternalStorage.request();
          if (status.isGranted) {
            // 如果权限被授予，执行压缩
            await zipJsonFiles(
                app.prj_path, "$path/${update.get_Now_Time()}.zip");
          } else {
            showToast('权限已拒绝，请在设置中启用权限');
            openAppSettings(); // 引导用户打开设置
          }
        } else {
          // 如果权限已授予，直接进行压缩
          await zipJsonFiles(
              app.prj_path, "$path/${update.get_Now_Time()}.zip");
        }
      }
    } catch (e) {
      showToast('[错误10012_3]压缩失败', notifyTypes: "failure");
    }
  }

  Future<void> zipJsonFiles(String directoryPath, String zipFilePath) async {
    // 获取目标目录
    Directory dir = Directory(directoryPath);
    if (!dir.existsSync()) {
      showToast('[错误10012_1]源目录不存在', notifyTypes: "failure");
      return;
    }

    // 创建一个新的归档对象
    Archive archive = Archive();

    // 遍历目录及其子目录
    await for (var entity in dir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.json')) {
        // 读取文件内容
        File file = entity;
        List<int> bytes = await file.readAsBytes();

        // 创建归档条目，去掉路径中的根目录部分
        String fileName = file.path.replaceFirst(directoryPath, '');
        archive.addFile(ArchiveFile(fileName, bytes.length, bytes));
      }
    }
    try {
      // 使用 ZipEncoder 来压缩归档
      List<int>? zipData = ZipEncoder().encode(archive);
      if (zipData != null) {
        // 将压缩数据写入文件
        await File(zipFilePath)
            .writeAsBytes(zipData, mode: FileMode.writeOnlyAppend, flush: true);
        showToast('导出成功');
      } else {
        showToast('[错误10012_2]压缩失败，无法生成zip数据', notifyTypes: "failure");
      }
    } catch (e) {
      showToast('[错误10012_2]压缩失败', notifyTypes: "failure");
    }
  }

  // Future<void> Compress_All_Box() async {
  //   try {
  //     String? path = await FilePicker.platform.getDirectoryPath();
  //     if (path != null) {
  //       var encoder = ZipFileEncoder();

  //       // 请求外部存储管理权限
  //       final status = await Permission.manageExternalStorage.request();
  //       if (status.isGranted) {
  //         print("权限已授予");

  //         // 压缩文件逻辑
  //         // 注意替换为实际路径
  //         await encoder.zipDirectoryAsync(Directory(path),
  //             filename: "$path/${update.get_Now_Time()}.zip");
  //         showToast('导出成功');
  //       } else {
  //         print("权限未授予");
  //         // 引导用户去设置界面开启权限
  //         openAppSettings();
  //       }
  //     }
  //   } catch (e) {
  //     print("压缩失败: $e");
  //     showToast('[错误10012]压缩失败', notifyTypes: "failure");
  //   }
  // }
}
