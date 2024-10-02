// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names, no_logic_in_create_state, no_leading_underscores_for_local_identifiers, prefer_interpolation_to_compose_strings, unrelated_type_equality_checks, file_names

import 'package:flutter/material.dart';
import 'package:flutter_application_1/module/BoxManager.dart';
import 'package:flutter_application_1/module/ItemManager.dart';
import 'package:flutter_application_1/module/Update.dart';
import 'package:flutter_application_1/module/app.dart';
import 'package:flutter_application_1/pages/Box_Page_Item_list.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';

String Global_ID = '';
Box_Manager boxManager = Box_Manager();
Update update = Update();
Item_Manager itemManager = Item_Manager();

class Box_Item extends StatefulWidget {
  final String names;
  final String item_names;
  const Box_Item({super.key, required this.names, required this.item_names});

  @override
  _Box_Item createState() {
    Global_ID = names;
    return _Box_Item();
  }
}

class _Box_Item extends State<Box_Item> {
  @override
  void initState() {
    super.initState();
    update.Update_Item_data(context, Global_ID);
  }

  @override
  Widget build(BuildContext context) {
    FlutterSmartDialog.init();
    return Consumer<App>(builder: (context, app, child) {
      return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                }),
            actions: [
              IconButton(
                padding: const EdgeInsets.only(right: 10),
                icon: const Icon(Icons.add_card),
                //添加按钮按下的时候触发的事件
                onPressed: () => Add_New_Item(context, app),
              ),
            ],
            backgroundColor: Colors.yellow,
            title: Center(
              child: Text(boxManager.Get_One_Box_Name(Global_ID)),
            )),
        body: ListView.builder(
            padding: const EdgeInsets.all(5),
            itemCount: app.Item_data.length,
            itemBuilder: (BuildContext context, int index) {
              return CustomListItem(
                icon: Icons.category_outlined,
                text: app.Item_data[index][1],
                count: app.Item_data[index][2],
                item_id: app.Item_data[index][0],
                selects: widget.item_names,
              );
            }),
      );
    });
  }
}
