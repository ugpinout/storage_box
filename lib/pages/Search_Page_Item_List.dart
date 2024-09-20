// ignore_for_file: library_private_types_in_public_api, file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Box.dart';
import 'package:flutter_application_1/module/FileManager.dart';
import 'package:flutter_application_1/module/app.dart';
import 'package:flutter_application_1/module/toast.dart';
import 'package:provider/provider.dart';

File_Manager fileManager = File_Manager();

class CustomListItem extends StatefulWidget {
  final IconData icon;
  final String Item_name;
  final String Box_Name;
  final String Box_ID;
  const CustomListItem(
      {super.key,
      required this.icon,
      required this.Item_name,
      required this.Box_Name,
      required this.Box_ID});
  @override
  _CustomListItem createState() {
    return _CustomListItem();
  }
}

class _CustomListItem extends State<CustomListItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(widget.icon),
      title: Text(widget.Item_name),
      trailing: Text("ID:${widget.Box_ID}"),
      subtitle: Text(widget.Box_Name),
      onTap: () {
        if (widget.Box_ID == "00000") {
          showToast('先搜索吧', notifyTypes: 'warning');
        } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Box_Item(names: widget.Box_ID)));
        }
      },
    );
  }
}

void Search_Item(context, String txts, app) {
  final List<FileSystemEntity> file_Paths =
      fileManager.Get_All_file_Name(context);
  final List<List> Search_result = [];
  for (FileSystemEntity file in file_Paths) {
    //只获取文件名
    //检测哪种平台上运行，有些平台的/是反着的
    String id = '0000';
    if (app.whyDevices == 'W') {
      id = file.toString().substring(file.toString().lastIndexOf('\\') + 1,
          file.toString().lastIndexOf('.'));
    } else {
      id = file.toString().substring(file.toString().lastIndexOf('/') + 1,
          file.toString().lastIndexOf('.'));
    }

    var txt = boxManager.Get_One_Box_Data(id);

    for (String i in txt['Item_Data'].keys) {
      if (txt['Item_Data'][i]['Item_Name'].toString().contains(txts)) {
        List<String> Temp = [
          txt['Item_Data'][i]['Item_Name'],
          txt['Box_Name'],
          id
        ];
        Search_result.add(Temp);
      } else {
        print('无');
      }
    }
  }
  if (Search_result.isEmpty) {
    showToast('没有找到相关零件', notifyTypes: 'warning');
  }

  Provider.of<App>(context, listen: false).Search_data = Search_result;
  app.notifyListeners();
}
