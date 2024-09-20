/*
警告
10001:文件第一次重新启动或者用户不小心删除的prj_path 目录
*/
/*
错误
10001：项目总目录创建失败，可能没有权限或其他错误，建议给权限或重装
10002：新建箱子文件失败，可能没有给权限，建议给权限或重装
10003：打开单个箱子文件失败，箱子文件不在或者没有权限
10004：写入单个箱子数据失败，可能没有给权限，建议给权限或重装
10005：删除箱子文件失败，箱子文件不在或者没有权限
10006：复制文件到根目录失败，可能没有给权限，建议给权限或重装

*/

import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter_application_1/module/toast.dart';

class App extends ChangeNotifier {
  // ignore: non_constant_identifier_names
  String prj_path = 'boxs'; //项目数据目录
  // ignore: non_constant_identifier_names
  final String prj_version = '1.0.0'; //项目版本
  // 判断是哪个设备
  String _whyDevices = 'W';

  String get whyDevices => _whyDevices;

  set whyDevices(String value) {
    _whyDevices = value;
    notifyListeners(); // 通知所有监听器
  }

  //图片列表的context，用于刷新列表，在图片列表中调用
  // ignore: non_constant_identifier_names
  int Box_Counts = 1; //盒子数量
  List<String> Box_Name = [
    //储存箱子名称
    "可能出错了",
    "这个是9",
    "这个是10",
    "这个是11",
    "这个是11",
  ];
  List<FileSystemEntity> File_Path = [
    //储存箱子文件路径
    File('C:\\boxs\\box1.json'),
    File('C:\\boxs\\box1.json'),
    File('C:\\boxs\\box1.json'),
    File('C:\\boxs\\box1.json'),
    File('C:\\boxs\\box1.json'),
  ];
  //储存箱子数据
  Map<String, String> Box_data = {};
//零件数据列表
  List<List> Item_data = [
    [114114, '可能出错啦', 0],
  ];

// 搜索数据列表
  List<List> Search_data = [
    ['没有零件', 'None', "00000"],
  ];
}
