// ignore_for_file: non_constant_identifier_names, camel_case_types, file_names

import 'package:flutter/material.dart';
import 'package:storage_box/Setting.dart';
import 'package:storage_box/module/toast.dart';

class Setting_List extends StatefulWidget {
  const Setting_List({super.key});

  @override
  State<Setting_List> createState() => _Setting_ListState();
}

class _Setting_ListState extends State<Setting_List> {
  late String _Box_Select_value; //盒子排序当前选择
  late String _Item_Select_value; //零件排序当前选择

  @override
  void initState() {
    super.initState();
    _Box_Select_value = Get_Box_Sort_Type();
    _Item_Select_value = Get_Item_Sort_Type();
  }

  @override
  Widget build(BuildContext context) {
    //FTP用户名称输入
    TextEditingController FTP_User_Name_Controller = TextEditingController();
    //FTP密码输入
    TextEditingController FTP_Password_Controller = TextEditingController();
    //FTP保存文件地址输入
    TextEditingController FTP_Path_Controller = TextEditingController();

    return ListView(
      children: [
        //顶部提示
        Container(
            width: double.infinity,
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.redAccent.withValues(alpha: 0.15),
                  Colors.redAccent.withValues(alpha: 0.05)
                ], begin: Alignment.centerLeft, end: Alignment.centerRight),
                borderRadius: BorderRadius.circular(8),
                border: Border(
                    left: BorderSide(color: Colors.redAccent, width: 4))),
            child: Text("*以下设置均需重启应用后生效",
                style: TextStyle(
                    color: Colors.redAccent, fontWeight: FontWeight.w500))),
        //箱子排序设置
        ListTile(
          title: Text("箱子排序设置"),
          leading: Icon(Icons.sort),
          trailing: DropdownButton<String>(
            value: _Box_Select_value,
            items: [
              for (String item in Get_Box_Settings_Box_sorting_type())
                DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                )
            ],
            onChanged: (value) {
              Set_Box_Sort_Type(value.toString());
              setState(() {
                _Box_Select_value = value.toString();
              });
            },
          ),
        ),
        //零件排序设置
        ListTile(
          title: Text("零件排序设置"),
          leading: Icon(Icons.sort),
          trailing: DropdownButton<String>(
            value: _Item_Select_value,
            items: [
              for (String item in Get_Item_Settings_Item_sorting_type())
                DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                )
            ],
            onChanged: (value) {
              Set_Item_Sort_Type(value.toString());
              setState(() {
                _Item_Select_value = value.toString();
              });
            },
          ),
        ),
        //横线
        Divider(),
        //设置FTP账号密码
        Column(
          children: [
            //FTP服务器账号输入框
            TextField(
              controller: FTP_User_Name_Controller,
              decoration: InputDecoration(
                  hintText: "FTP服务器账号",
                  labelText: "FTP账号",
                  prefixIcon: Icon(Icons.person)),
            ),
            TextField(
              controller: FTP_Password_Controller,
              decoration: InputDecoration(
                  hintText: "FTP服务器密码",
                  labelText: "FTP密码",
                  prefixIcon: Icon(Icons.lock)),
            ),

            TextField(
              //宽度调小

              controller: FTP_Path_Controller,
              decoration: InputDecoration(
                  hintText: "FTP服务器文件保存路径，根目录直接输入./",
                  labelText: "FTP保存路径",
                  prefixIcon: Icon(Icons.folder)),
            ),
            //测试按钮
            ElevatedButton(
                onPressed: () async {
                  showToast('该功能还在开发中...');
                  // var result = await FTP_Test();
                  // if (result) {
                  //   showDialog(
                  //       context: context,
                  //       builder: (context) {
                  //         return AlertDialog(
                  //           title: Text("测试成功"),
                  //           content: Text("测试成功"),
                  //         );
                  //       });
                  // } else {}
                },
                child: Text("测试"))
          ],
        )
      ],
    );
  }
}

//获取箱子排序
String Get_Box_Sort_Type() {
  String Item_Name = setting_Manager.Read_Setting_List()["箱子排序设置"];
  String val =
      setting_Manager.Read_Setting_Item(Item_Name, "Box_sorting", true);
  return val;
}

//获取现在箱子排序列表
List<dynamic> Get_Box_Settings_Box_sorting_type() {
  String Item_Name = setting_Manager.Read_Setting_List()["箱子排序设置"];
  dynamic list =
      setting_Manager.Read_Setting_Item(Item_Name, "Box_sorting_type", true);

  return list;
}

//设置箱子排序列表
void Set_Box_Sort_Type(String value) {
  String Item_Name = setting_Manager.Read_Setting_List()["箱子排序设置"];
  setting_Manager.Write_Setting_Item(Item_Name, "Box_sorting", value);
}

//获取零件排序列表
String Get_Item_Sort_Type() {
  String Item_Name = setting_Manager.Read_Setting_List()["零件排序设置"];
  String val =
      setting_Manager.Read_Setting_Item(Item_Name, "Item_sorting", true);
  return val;
}

//获取现在箱子排序列表
List<dynamic> Get_Item_Settings_Item_sorting_type() {
  String Item_Name = setting_Manager.Read_Setting_List()["零件排序设置"];
  dynamic list =
      setting_Manager.Read_Setting_Item(Item_Name, "Item_sorting_type", true);

  return list;
}

//设置零件排序方式
void Set_Item_Sort_Type(String value) {
  String Item_Name = setting_Manager.Read_Setting_List()["零件排序设置"];
  setting_Manager.Write_Setting_Item(Item_Name, "Item_sorting", value);
}
