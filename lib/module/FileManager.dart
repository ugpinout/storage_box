// ignore_for_file: file_names, prefer_interpolation_to_compose_strings, non_constant_identifier_names, camel_case_types

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../module/app.dart';

import 'toast.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

App app = App();

class File_Manager {
  Future<bool> Is_A_Dir(dirs, context) async {
    String path;

    if (Platform.isAndroid) {
      Provider.of<App>(context, listen: false).whyDevices = 'A';
      final dir = await getExternalStorageDirectory();
      if (dir == null) {
        showToast('[错误10000]无法获取Android外部存储目录', notifyTypes: "failure");
        return false;
      }
      path = '${dir.path}/' + dirs;
    } else if (Platform.isWindows) {
      Provider.of<App>(context, listen: false).whyDevices = 'W';
      Uri uri = Platform.script;
      String scriptDir = uri.resolve('.').toFilePath();
      path = '${Directory(scriptDir).path}/' + dirs;
    } else {
      throw UnsupportedError('Platform not supported');
    }
    app.prj_path = path;
    if (await Directory(path).exists()) {
      return true;
    } else {
      showToast('[警告10001]目录不存在，尝试创建目录', notifyTypes: 'warning');
      try {
        await Directory(path).create(recursive: true);
        // showToast('创建目录成功', backgroundColors: Colors.green);
        return true;
      } catch (e) {
        showToast('[错误10001]创建失败: $e', notifyTypes: "failure");
        return false;
      }
    }
  }

//获取指定目录下的所有文件名
  Get_All_file_Name(BuildContext context) {
    final directory = Directory(app.prj_path);
    //只获取json文件
    final List<FileSystemEntity> entities = directory
        .listSync()
        .where((entity) => entity.path.endsWith('.json'))
        .toList();
    // final List<FileSystemEntity> entities = directory.listSync();
    return entities;
  }

//获取指定目录下的箱子文件数量
  Get_File_Count(BuildContext context) {
    int num = 0;
    final directory = Directory(app.prj_path);
    final List<FileSystemEntity> entities = directory.listSync();
    for (int i = 0; i < entities.length; i++) {
      if (entities[i].toString().endsWith('json\'') == true) num++;
    }
    return num;
  }

// 清除控制字符（ASCII 0到31的字符）
  String cleanJsonText(String jsonText) {
    return jsonText.replaceAll(RegExp(r'[\x00-\x1F\x7F]'), '');
  }

// 创建一个新文件
  Create_New_File(File_Path, File_Name, txt) {
    try {
      File('$File_Path/$File_Name.json').writeAsStringSync(txt);
      return true;
    } catch (e) {
      return false;
    }
  }

// 获取一个文件的内容
  Get_One_File_Text(file_path, id) {
    try {
      String Json_text = File('$file_path/$id.json').readAsStringSync();
      return Json_text;
    } catch (e) {
      showToast('[错误10003]打开失败', notifyTypes: "failure");
      return null;
    }
  }

// 写入一个文件的内容
  Set_One_File_Text(file_path, id, txt) {
    try {
      File('$file_path/$id.json').writeAsStringSync(txt);
      return true;
    } catch (e) {
      showToast('[错误10004]写入失败', notifyTypes: "failure");
    }
  }

// 删除一个文件
  Del_One_File(file_path, id) {
    try {
      File('$file_path/$id.json').deleteSync();
      return true;
    } catch (e) {
      showToast('[错误10005]删除失败', notifyTypes: "failure");
      return false;
    }
  }

// 复制文件到指定目录
  void Copy_File_To_Dir(id) async {
    try {
      String? path = await FilePicker.platform.getDirectoryPath();
      if (path != null) {
        File('${app.prj_path}/$id.json').copySync('$path/$id.json');
        showToast('导出成功', notifyTypes: "success");
      }
    } catch (e) {
      showToast('[错误10006]复制失败', notifyTypes: "failure");
    }
  }
}
