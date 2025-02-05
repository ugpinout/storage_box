// ignore_for_file: file_names

import 'dart:convert';

import 'package:storage_box/module/BoxManager.dart';
import 'package:storage_box/module/FileManager.dart';

Box_Manager boxManager = Box_Manager();
File_Manager fileManager = File_Manager();

class Item_Manager {
  // 修改一个零件的个数
  Set_Item_count(id, item_id, count) {
    Map<String, dynamic> jsonData = boxManager.Get_One_Box_Data(id);
    jsonData['Item_Data'][item_id.toString()]['Item_Count'] = count.toString();
    fileManager.Set_One_File_Text(app.prj_path, id, jsonEncode(jsonData));
  }

// 修改一个零件的名称
  Set_Item_Name(id, item_id, name) {
    Map<String, dynamic> jsonData = boxManager.Get_One_Box_Data(id);
    jsonData['Item_Data'][item_id.toString()]['Item_Name'] = name;
    fileManager.Set_One_File_Text(app.prj_path, id, jsonEncode(jsonData));
  }

  // 获取一个零件的名称
  Get_Item_Name(id, item_id) {
    Map<String, dynamic> jsonData = boxManager.Get_One_Box_Data(id);
    return jsonData['Item_Data'][item_id.toString()]['Item_Name'];
  }

// 删除一个零件
  Del_One_Item(id, item_id) {
    Map<String, dynamic> jsonData = boxManager.Get_One_Box_Data(id);
    jsonData['Item_Data'].remove(item_id.toString());
    fileManager.Set_One_File_Text(app.prj_path, id, jsonEncode(jsonData));
  }
}
