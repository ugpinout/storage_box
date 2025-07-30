// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:storage_box/module/SettingManager.dart';
import 'package:storage_box/pages/Setting_Page_Item_List.dart';

Setting_Manager setting_Manager = Setting_Manager();

class Setting_Page extends StatefulWidget {
  const Setting_Page({super.key});

  @override
  _Setting_Page createState() {
    return _Setting_Page();
  }
}

class _Setting_Page extends State<Setting_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('设置')),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
          backgroundColor: Colors.yellow,
        ),
        body: InkWell(
          child: Setting_List(),
        ));
  }
}
