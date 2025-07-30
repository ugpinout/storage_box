// ignore_for_file: non_constant_identifier_names, camel_case_types, strict_top_level_inference, file_names

import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:storage_box/module/FileManager.dart';

import 'package:storage_box/module/toast.dart';

File_Manager fileManager = File_Manager();

class Setting_Manager {
  String path = app.prj_path;

  //配置文件是否存在
  Future<bool> Is_Config_File_Exist() async {
    if (!await File('$path/config.conf').exists()) {
      try {
        showToast('[警告10002]配置文件不存在,正在尝试初始化配置文件', notifyTypes: 'warning');

        String txt = await rootBundle.loadString('assets/config/config.conf');

        File('$path/config.conf').writeAsStringSync(txt);
        return true;
      } catch (e) {
        showToast('[错误10013]写入失败', notifyTypes: "failure");
        return false;
      }
    } else {
      return true;
    }
  }

  //读入配置文件
  dynamic Read_Setting_File() {
    String Text = File('$path/config.conf').readAsStringSync();
    //读入的数据转换成json对象
    var json_text = jsonDecode(Text);
    return json_text;
  }

//写入配置文件
  void Write_Setting_File(dynamic json_text) {
    try {
      File('$path/config.conf').writeAsStringSync(jsonEncode(json_text));
    } catch (e) {
      showToast('[错误10013]写入失败', notifyTypes: "failure");
    }
  }

  //获取配置列表
  dynamic Read_Setting_List() {
    dynamic text = Read_Setting_File();
    return text["Setting_List"];
  }

//获取配置项
  dynamic Read_Setting_Item(Item_name, child_Item_name, Use_Child_item) {
    if (Use_Child_item == true) {
      dynamic text = Read_Setting_File();
      return text[Item_name][child_Item_name];
    } else {
      dynamic text = Read_Setting_File();
      return text[Item_name];
    }
  }

//写入配置项
  void Write_Setting_Item(Item_name, child_Item_name, value) {
    dynamic text = Read_Setting_File();
    text[Item_name][child_Item_name] = value;
    Write_Setting_File(text);
  }
}
