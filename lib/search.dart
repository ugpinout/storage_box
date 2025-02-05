// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:storage_box/module/app.dart';
import 'package:storage_box/module/toast.dart';
import 'package:storage_box/pages/Search_Page_Item_List.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';

class Search_Page extends StatefulWidget {
  const Search_Page({super.key});

  @override
  _Search_Page createState() {
    return _Search_Page();
  }
}

class _Search_Page extends State<Search_Page> {
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(); // 初始化控制器
    FlutterSmartDialog.init();
  }

  @override
  void dispose() {
    nameController.dispose(); // 释放控制器
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<App>(builder: (context, app, child) {
      return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                }),
            backgroundColor: Colors.yellow,
            title: const Center(child: Text("搜索零件"))),
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Row(children: [
                Expanded(
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(hintText: '输入箱子名称'),
                    textAlign: TextAlign.center,
                  ),
                ),
                InkWell(
                  child: const Icon(
                    Icons.search,
                    size: 30,
                  ),
                  onTap: () {
                    if (nameController.text.isEmpty) {
                      showToast('哈↓哈↑', notifyTypes: 'warning');
                    } else {
                      Search_Item(context, nameController.text, app);
                    }
                  },
                )
              ]),
            ),
            Expanded(
              // 确保 ListView 能够正确占用剩余空间
              child: ListView.builder(
                padding: const EdgeInsets.all(5),
                itemCount: app.Search_data.length,
                itemBuilder: (BuildContext context, int index) {
                  return CustomListItem(
                    icon: Icons.category_outlined,
                    Item_name: app.Search_data[index][0],
                    Box_Name: app.Search_data[index][1],
                    Box_ID: app.Search_data[index][2],
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
