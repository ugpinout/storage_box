// ignore_for_file: file_names, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../module/app.dart';
import '../module/BoxManager.dart';
import '../module/FileManager.dart';

Box_Manager boxManager = Box_Manager();
File_Manager fileManager = File_Manager();

class Update {
  // 更新箱子数据
  void Update_Box_Data(BuildContext context) {
    int num = fileManager.Get_File_Count(context);
    final app = Provider.of<App>(context, listen: false);
    app.Box_Counts = num;
    app.notifyListeners(); // 确保通知监听者更新 UI
    app.File_Path = fileManager.Get_All_file_Name(context);
    app.Box_Name = boxManager.Get_All_Box_Name(context, app.File_Path);

    app.notifyListeners(); // 确保通知监听者更新 UI
    app.Box_data = boxManager.Create_Box_Data_Map(app.File_Path, app.Box_Name);
    app.notifyListeners(); // 确保通知监听者更新 UI
  }

// 更新零件数据
  void Update_Item_data(BuildContext context, ids) {
    Map<String, dynamic> Json_text =
        boxManager.Get_One_Box_Data(ids)["Item_Data"];

    app.notifyListeners();
    final List<List<dynamic>> result = Json_text.entries.map((entry) {
      final id = entry.key;
      final item = entry.value;
      app.notifyListeners();
      return [int.parse(id), item['Item_Name'], int.parse(item['Item_Count'])];
    }).toList();
    app.notifyListeners();
    Provider.of<App>(context, listen: false).Item_data = result;
    app.notifyListeners();
  }

  get_Now_Time() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  bool is_breaking_Json_Format(json_string) {
    final RegExp validJsonRegExp = RegExp(r'^[\w\s.,_@()\[\]\u4e00-\u9fa5]+$');
    return !validJsonRegExp.hasMatch(json_string);
  }
}
