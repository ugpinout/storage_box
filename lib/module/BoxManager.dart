// ignore_for_file: file_names, non_constant_identifier_names, camel_case_types, strict_top_level_inference
import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:storage_box/Box.dart';
import 'package:storage_box/module/toast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:storage_box/pages/Setting_Page_Item_List.dart';
import 'package:storage_box/main.dart' hide app, update;
import 'FileManager.dart';

class Box_Manager {
  //创建一个箱子
  bool Create_New_Box(Box_Name) {
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
  List<String> Get_All_Box_Name(BuildContext context, File_Path) {
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

  Map<String, String> Create_Box_Data_Map(file_Path, List<String> Box_Name) {
    // 1. 构建原始 Map（key: Box_Name，value: 文件名）
    Map<String, String> Box_Data = {};
    for (int i = 0; i < Box_Name.length; i++) {
      String file_name =
          file_Path[i].uri.pathSegments.last.toString().split('.')[0];
      Box_Data[Box_Name[i]] = file_name;
    }

    String sort_type = Get_Box_Sort_Type();

    switch (sort_type) {
      case "系统默认排序":
        print("箱子系统默认排序");
        return Box_Data;

      case "数字开头降序":
        return Map.fromEntries(Box_Data.entries.toList()
          ..sort((a, b) {
            bool aIsDigit =
                a.key.isNotEmpty && a.key[0].contains(RegExp(r'[0-9]'));
            bool bIsDigit =
                b.key.isNotEmpty && b.key[0].contains(RegExp(r'[0-9]'));
            bool aIsLetter = a.key.isNotEmpty &&
                a.key[0].toLowerCase().contains(RegExp(r'[a-z]'));
            bool bIsLetter = b.key.isNotEmpty &&
                b.key[0].toLowerCase().contains(RegExp(r'[a-z]'));

            // 数字优先（降序）
            if (aIsDigit && !bIsDigit) return -1;
            if (!aIsDigit && bIsDigit) return 1;
            if (aIsDigit && bIsDigit) {
              int aNum =
                  int.tryParse(a.key.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
              int bNum =
                  int.tryParse(b.key.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
              return bNum.compareTo(aNum); // 改为降序
            }

            // 然后是字母（降序）
            if (aIsLetter && !bIsLetter) return -1;
            if (!aIsLetter && bIsLetter) return 1;
            if (aIsLetter && bIsLetter) {
              return b.key.toLowerCase().compareTo(a.key.toLowerCase());
            }

            // 最后是中文（降序）
            return b.key.compareTo(a.key);
          }));

      case "首字母降序":
        return Map.fromEntries(Box_Data.entries.toList()
          ..sort((a, b) {
            bool aIsDigit =
                a.key.isNotEmpty && a.key[0].contains(RegExp(r'[0-9]'));
            bool bIsDigit =
                b.key.isNotEmpty && b.key[0].contains(RegExp(r'[0-9]'));
            bool aIsLetter = a.key.isNotEmpty &&
                a.key[0].toLowerCase().contains(RegExp(r'[a-z]'));
            bool bIsLetter = b.key.isNotEmpty &&
                b.key[0].toLowerCase().contains(RegExp(r'[a-z]'));

            // 数字最后
            if (aIsDigit && !bIsDigit) return 1;
            if (!aIsDigit && bIsDigit) return -1;
            if (aIsDigit && bIsDigit) {
              return b.key.compareTo(a.key);
            }

            // 字母优先（降序）
            if (aIsLetter && !bIsLetter) return -1;
            if (!aIsLetter && bIsLetter) return 1;
            if (aIsLetter && bIsLetter) {
              return b.key.toLowerCase().compareTo(a.key.toLowerCase());
            }

            // 然后是中文（降序）
            return b.key.compareTo(a.key);
          }));

      case "首字母升序":
        return Map.fromEntries(Box_Data.entries.toList()
          ..sort((a, b) {
            bool aIsDigit =
                a.key.isNotEmpty && a.key[0].contains(RegExp(r'[0-9]'));
            bool bIsDigit =
                b.key.isNotEmpty && b.key[0].contains(RegExp(r'[0-9]'));
            bool aIsLetter = a.key.isNotEmpty &&
                a.key[0].toLowerCase().contains(RegExp(r'[a-z]'));
            bool bIsLetter = b.key.isNotEmpty &&
                b.key[0].toLowerCase().contains(RegExp(r'[a-z]'));

            // 数字最后
            if (aIsDigit && !bIsDigit) return 1;
            if (!aIsDigit && bIsDigit) return -1;
            if (aIsDigit && bIsDigit) {
              return a.key.compareTo(b.key);
            }

            // 字母优先（升序）
            if (aIsLetter && !bIsLetter) return -1;
            if (!aIsLetter && bIsLetter) return 1;
            if (aIsLetter && bIsLetter) {
              return a.key.toLowerCase().compareTo(b.key.toLowerCase());
            }

            // 然后是中文（升序）
            return a.key.compareTo(b.key);
          }));

      case "数字开头升序":
        return Map.fromEntries(Box_Data.entries.toList()
          ..sort((a, b) {
            bool aIsDigit =
                a.key.isNotEmpty && a.key[0].contains(RegExp(r'[0-9]'));
            bool bIsDigit =
                b.key.isNotEmpty && b.key[0].contains(RegExp(r'[0-9]'));
            bool aIsLetter = a.key.isNotEmpty &&
                a.key[0].toLowerCase().contains(RegExp(r'[a-z]'));
            bool bIsLetter = b.key.isNotEmpty &&
                b.key[0].toLowerCase().contains(RegExp(r'[a-z]'));

            // 数字优先（升序）
            if (aIsDigit && !bIsDigit) return -1;
            if (!aIsDigit && bIsDigit) return 1;
            if (aIsDigit && bIsDigit) {
              int aNum =
                  int.tryParse(a.key.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
              int bNum =
                  int.tryParse(b.key.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
              return aNum.compareTo(bNum);
            }

            // 然后是字母（升序）
            if (aIsLetter && !bIsLetter) return -1;
            if (!aIsLetter && bIsLetter) return 1;
            if (aIsLetter && bIsLetter) {
              return a.key.toLowerCase().compareTo(b.key.toLowerCase());
            }

            // 最后是中文（升序）
            return a.key.compareTo(b.key);
          }));

      default:
        print("箱子未知排序类型");
        return Box_Data;
    }
  }

  //获取一个箱子的名称[用于子页面AppBar上面显示]
  dynamic Get_One_Box_Name(id) {
    String Json_text = fileManager.Get_One_File_Text(app.prj_path, id);
    Map<String, dynamic> jsonData =
        jsonDecode(fileManager.cleanJsonText(Json_text));
    return jsonData['Box_Name'];
  }

  Map<String, dynamic> Get_One_Box_Data(id) {
    String Json_text = fileManager.Get_One_File_Text(app.prj_path, id);
    Map<String, dynamic> jsonData =
        jsonDecode(fileManager.cleanJsonText(Json_text));

    // 获取Item_Data并转换为可排序的MapEntry列表
    Map<String, dynamic> itemData = jsonData['Item_Data'];
    List<MapEntry<String, dynamic>> entries = itemData.entries.toList();

    // 根据当前排序类型进行排序
    switch (Get_Item_Sort_Type()) {
      case "系统默认排序":
        print("零件系统默认排序");
        return jsonData; // 保持原始顺序

      case "首字母升序":
        print("零件首字母升序");
        entries.sort((a, b) {
          String aName = a.value['Item_Name'] ?? '';
          String bName = b.value['Item_Name'] ?? '';
          bool aIsDigit =
              aName.isNotEmpty && aName[0].contains(RegExp(r'[0-9]'));
          bool bIsDigit =
              bName.isNotEmpty && bName[0].contains(RegExp(r'[0-9]'));
          bool aIsLetter = aName.isNotEmpty &&
              aName[0].toLowerCase().contains(RegExp(r'[a-z]'));
          bool bIsLetter = bName.isNotEmpty &&
              bName[0].toLowerCase().contains(RegExp(r'[a-z]'));

          // 数字最后
          if (aIsDigit && !bIsDigit) return 1;
          if (!aIsDigit && bIsDigit) return -1;
          if (aIsDigit && bIsDigit) return aName.compareTo(bName);

          // 字母优先（升序）
          if (aIsLetter && !bIsLetter) return -1;
          if (!aIsLetter && bIsLetter) return 1;
          if (aIsLetter && bIsLetter)
            return aName.toLowerCase().compareTo(bName.toLowerCase());

          // 然后是中文（升序）
          return aName.compareTo(bName);
        });
        break;

      case "首字母降序":
        print("零件首字母降序");
        entries.sort((a, b) {
          String aName = a.value['Item_Name'] ?? '';
          String bName = b.value['Item_Name'] ?? '';
          bool aIsDigit =
              aName.isNotEmpty && aName[0].contains(RegExp(r'[0-9]'));
          bool bIsDigit =
              bName.isNotEmpty && bName[0].contains(RegExp(r'[0-9]'));
          bool aIsLetter = aName.isNotEmpty &&
              aName[0].toLowerCase().contains(RegExp(r'[a-z]'));
          bool bIsLetter = bName.isNotEmpty &&
              bName[0].toLowerCase().contains(RegExp(r'[a-z]'));

          // 数字最后
          if (aIsDigit && !bIsDigit) return 1;
          if (!aIsDigit && bIsDigit) return -1;
          if (aIsDigit && bIsDigit) return bName.compareTo(aName);

          // 字母优先（降序）
          if (aIsLetter && !bIsLetter) return -1;
          if (!aIsLetter && bIsLetter) return 1;
          if (aIsLetter && bIsLetter)
            return bName.toLowerCase().compareTo(aName.toLowerCase());

          // 然后是中文（降序）
          return bName.compareTo(aName);
        });
        break;

      case "数字开头升序":
        print("零件数字开头升序");
        entries.sort((a, b) {
          String aName = a.value['Item_Name'] ?? '';
          String bName = b.value['Item_Name'] ?? '';
          bool aIsDigit =
              aName.isNotEmpty && aName[0].contains(RegExp(r'[0-9]'));
          bool bIsDigit =
              bName.isNotEmpty && bName[0].contains(RegExp(r'[0-9]'));
          bool aIsLetter = aName.isNotEmpty &&
              aName[0].toLowerCase().contains(RegExp(r'[a-z]'));
          bool bIsLetter = bName.isNotEmpty &&
              bName[0].toLowerCase().contains(RegExp(r'[a-z]'));

          // 数字优先（升序）
          if (aIsDigit && !bIsDigit) return -1;
          if (!aIsDigit && bIsDigit) return 1;
          if (aIsDigit && bIsDigit) {
            int aNum =
                int.tryParse(aName.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
            int bNum =
                int.tryParse(bName.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
            return aNum.compareTo(bNum);
          }

          // 然后是字母（升序）
          if (aIsLetter && !bIsLetter) return -1;
          if (!aIsLetter && bIsLetter) return 1;
          if (aIsLetter && bIsLetter)
            return aName.toLowerCase().compareTo(bName.toLowerCase());

          // 最后是中文（升序）
          return aName.compareTo(bName);
        });
        break;

      case "数字开头降序":
        print("零件数字开头降序");
        entries.sort((a, b) {
          String aName = a.value['Item_Name'] ?? '';
          String bName = b.value['Item_Name'] ?? '';
          bool aIsDigit =
              aName.isNotEmpty && aName[0].contains(RegExp(r'[0-9]'));
          bool bIsDigit =
              bName.isNotEmpty && bName[0].contains(RegExp(r'[0-9]'));
          bool aIsLetter = aName.isNotEmpty &&
              aName[0].toLowerCase().contains(RegExp(r'[a-z]'));
          bool bIsLetter = bName.isNotEmpty &&
              bName[0].toLowerCase().contains(RegExp(r'[a-z]'));

          // 数字优先（降序）
          if (aIsDigit && !bIsDigit) return -1;
          if (!aIsDigit && bIsDigit) return 1;
          if (aIsDigit && bIsDigit) {
            int aNum =
                int.tryParse(aName.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
            int bNum =
                int.tryParse(bName.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
            return bNum.compareTo(aNum);
          }

          // 然后是字母（降序）
          if (aIsLetter && !bIsLetter) return -1;
          if (!aIsLetter && bIsLetter) return 1;
          if (aIsLetter && bIsLetter)
            return bName.toLowerCase().compareTo(aName.toLowerCase());

          // 最后是中文（降序）
          return bName.compareTo(aName);
        });
        break;

      case "数量升序排序":
        print("零件数量升序排序");
        entries.sort((a, b) {
          int aCount =
              int.tryParse(a.value['Item_Count']?.toString() ?? '0') ?? 0;
          int bCount =
              int.tryParse(b.value['Item_Count']?.toString() ?? '0') ?? 0;
          return aCount.compareTo(bCount);
        });
        break;

      case "数量降序排序":
        print("零件数量降序排序");
        entries.sort((a, b) {
          int aCount =
              int.tryParse(a.value['Item_Count']?.toString() ?? '0') ?? 0;
          int bCount =
              int.tryParse(b.value['Item_Count']?.toString() ?? '0') ?? 0;
          return bCount.compareTo(aCount);
        });
        break;

      default:
        return jsonData; // 默认保持原始顺序
    }

    // 重建排序后的Item_Data
    Map<String, dynamic> sortedItemData = {};
    for (var entry in entries) {
      sortedItemData[entry.key] = entry.value;
    }

    // 返回包含排序后数据的新jsonData
    return {
      ...jsonData,
      'Item_Data': sortedItemData,
    };
  }

// 辅助函数：提取字符串开头的数字部分
  int? extractLeadingNumber(String text) {
    final match = RegExp(r'^\d+').firstMatch(text);
    return match != null ? int.tryParse(match.group(0)!) : null;
  }

//添加一个零件
  void Set_One_Box_Data(id, Item_Name, count, item_id) {
    Map<String, dynamic> jsonData = Get_One_Box_Data(id);
    jsonData['Item_Data'][item_id] = {
      'Item_Name': Item_Name,
      'Item_Count': count,
    };
    fileManager.Set_One_File_Text(app.prj_path, id, jsonEncode(jsonData));
  }

  // 修改箱子名称
  void Set_Box_Name(id, name) {
    Map<String, dynamic> jsonData = Get_One_Box_Data(id);
    jsonData['Box_Name'] = name;
    fileManager.Set_One_File_Text(app.prj_path, id, jsonEncode(jsonData));
  }

// 分享一个箱子
  void share_One_Box(String id) {
    Share.shareXFiles([XFile('${app.prj_path}/$id.json')], text: "分享箱子id:$id");
  }

// 删除一个箱子
  void Del_one_Box(id) {
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
