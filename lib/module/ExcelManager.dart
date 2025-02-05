// ignore_for_file: file_names, non_constant_identifier_names
//导出成Excel
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:storage_box/module/FileManager.dart';
import 'package:storage_box/module/Update.dart';
import 'package:storage_box/module/toast.dart';
import 'package:flutter_excel/excel.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

Update update = Update();
File_Manager fileManager = File_Manager();

class Excelmanager {
  //箱子导出到Excel
  Future<void> Export_To_Excel(context) async {
    try {
      String? path = await FilePicker.platform.getDirectoryPath();
      if (path != null) {
        var excel = Excel.createExcel();
        var sheet1 = excel['Sheet1'];
        sheet1.appendRow(['Item_Name', 'Item_Count', 'Box_Name', 'Box_ID']);
        var Item_Name = sheet1.cell(CellIndex.indexByString("A1"));
        var Item_Count = sheet1.cell(CellIndex.indexByString("B1"));
        var Box_Name = sheet1.cell(CellIndex.indexByString("C1"));
        var Box_ID = sheet1.cell(CellIndex.indexByString("D1"));
        Item_Name.cellStyle = CellStyle(
            verticalAlign: VerticalAlign.Center,
            horizontalAlign: HorizontalAlign.Center);
        Item_Count.cellStyle = CellStyle(
            verticalAlign: VerticalAlign.Center,
            horizontalAlign: HorizontalAlign.Center);
        Box_Name.cellStyle = CellStyle(
            verticalAlign: VerticalAlign.Center,
            horizontalAlign: HorizontalAlign.Center);
        Box_ID.cellStyle = CellStyle(
            verticalAlign: VerticalAlign.Center,
            horizontalAlign: HorizontalAlign.Center);

        List<FileSystemEntity> files = fileManager.Get_All_file_Name(context);
        for (FileSystemEntity file in files) {
          Map<String, dynamic> jsonData = jsonDecode(
              fileManager.cleanJsonText((file as File).readAsStringSync()));
          Map<String, dynamic> data = jsonData['Item_Data'];
          data.forEach((key, value) {
            sheet1.appendRow([
              value['Item_Name'],
              value['Item_Count'],
              jsonData['Box_Name'],
              key
            ]);
          });
        }
        var fileBytes = excel.save();
        File('$path/${update.get_Now_Time()}.xlsx')
            .writeAsBytesSync(fileBytes!);
        SmartDialog.dismiss();
        showToast('导出成功');
      }
    } catch (e) {
      SmartDialog.dismiss();
      showToast('[错误10010]Excel导出过程出问题', notifyTypes: "failure");
    }
  }

// Excel导入到箱子
  Import_Excel_To_File(context) async {
    // try {
    //   FilePickerResult? result = await FilePicker.platform.pickFiles();
    //   if (result!.files.single.path.toString().endsWith('xlsx')) {
    //     SmartDialog.dismiss();
    //     //数据结构：  [零件名称   ，   零件数量  ， 零件所属箱子ID  ]
    //     // List<List<dynamic>> Excel_data = [
    //     //   ['请读入零件', 0, '00000']
    //     // ];
    //     List<List<dynamic>> Excel_data = [];

    //     Map<String, String> Box_data =
    //         Provider.of<App>(context, listen: false).Box_data;
    //     List<String> keys = [];
    //     keys = Box_data.keys.toList();

    //     final TextEditingController Name = TextEditingController(text: 'A2');
    //     final TextEditingController Count = TextEditingController(text: 'B2');
    //     List<SingleSelectController> dropdowncontrol =
    //         List<SingleSelectController>.generate(
    //             Excel_data.length, (index) => SingleSelectController(null));
    //     final TextEditingController Sheetname =
    //         TextEditingController(text: 'Sheet1');

    //     // Provider.of<App>(context, listen: false).Box_data.values.toList();
    //     var bytes = File(result.files.single.path.toString()).readAsBytesSync();
    //     var excel = Excel.decodeBytes(bytes);

    //     SmartDialog.show(builder: (_) {
    //       return Dialog(
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(20),
    //           ),
    //           child: SizedBox(
    //             width: 300, // 设置对话框的宽度
    //             height: 500, // 设置对话框的高度
    //             child: StatefulBuilder(builder: (context, setState) {
    //               return SizedBox(
    //                 width: 100,
    //                 height: 50,
    //                 child: Column(
    //                   mainAxisSize: MainAxisSize.min,
    //                   children: [
    //                     Row(
    //                       children: [
    //                         const Padding(padding: EdgeInsets.only(right: 10)),
    //                         const Text('名称单元格：'),
    //                         const Padding(padding: EdgeInsets.only(right: 120)),
    //                         Expanded(
    //                             child: TextField(
    //                           textAlign: TextAlign.center,
    //                           controller: Name,
    //                         )),
    //                         const Padding(padding: EdgeInsets.only(right: 10)),
    //                       ],
    //                     ),
    //                     Row(
    //                       children: [
    //                         const Padding(padding: EdgeInsets.only(right: 10)),
    //                         const Text('数量单元格：'),
    //                         const Padding(padding: EdgeInsets.only(right: 120)),
    //                         Expanded(
    //                             child: TextField(
    //                           textAlign: TextAlign.center,
    //                           controller: Count,
    //                         )),
    //                         const Padding(padding: EdgeInsets.only(right: 10)),
    //                       ],
    //                     ),
    //                     Row(
    //                       children: [
    //                         const Padding(padding: EdgeInsets.only(right: 10)),
    //                         const Text('工作表：'),
    //                         const Padding(padding: EdgeInsets.only(right: 120)),
    //                         Expanded(
    //                             child: TextField(
    //                           textAlign: TextAlign.center,
    //                           controller: Sheetname,
    //                         )),
    //                         const Padding(padding: EdgeInsets.only(right: 10)),
    //                       ],
    //                     ),
    //                     const Padding(padding: EdgeInsets.only(bottom: 10)),
    //                     SizedBox(
    //                         width: 250,
    //                         height: 20,
    //                         child: Row(
    //                           children: [
    //                             ElevatedButton(
    //                                 //创建新的盒子按钮按下发生的事件
    //                                 onPressed: () {
    //                                   final TextEditingController Box_Nam =
    //                                       TextEditingController();

    //                                   SmartDialog.show(builder: (_) {
    //                                     return Dialog(
    //                                       shape: RoundedRectangleBorder(
    //                                         borderRadius:
    //                                             BorderRadius.circular(20),
    //                                       ),
    //                                       child: SizedBox(
    //                                         width: 300,
    //                                         height: 100,
    //                                         child: Column(
    //                                           children: [
    //                                             SizedBox(
    //                                                 width: 260,
    //                                                 child: TextField(
    //                                                   controller: Box_Nam,
    //                                                   decoration:
    //                                                       const InputDecoration(
    //                                                           labelText:
    //                                                               '箱子名称'),
    //                                                 )),
    //                                             Row(
    //                                               children: [
    //                                                 // 取消按钮
    //                                                 Container(
    //                                                   width: 110,
    //                                                   height: 35,
    //                                                   padding:
    //                                                       const EdgeInsets.only(
    //                                                           top: 10,
    //                                                           left: 10),
    //                                                   child: ElevatedButton(
    //                                                       onPressed: () =>
    //                                                           SmartDialog
    //                                                               .dismiss(),
    //                                                       child:
    //                                                           const Text('取消')),
    //                                                 ),
    //                                                 Expanded(
    //                                                     child: Container()),
    //                                                 // 确定按钮
    //                                                 Container(
    //                                                   width: 110,
    //                                                   height: 35,
    //                                                   padding:
    //                                                       const EdgeInsets.only(
    //                                                           top: 10,
    //                                                           right: 10),
    //                                                   child: ElevatedButton(
    //                                                       onPressed: () {
    //                                                         String
    //                                                             trimmedValue =
    //                                                             Box_Nam.text
    //                                                                 .trim();
    //                                                         if (trimmedValue
    //                                                             .isEmpty) {
    //                                                           showToast(
    //                                                               "输入点什么吧",
    //                                                               notifyTypes:
    //                                                                   'warning');
    //                                                         } else if (update
    //                                                             .is_breaking_Json_Format(
    //                                                                 trimmedValue)) {
    //                                                           showToast(
    //                                                               "内容包含破坏数据格式的符号，请修改",
    //                                                               notifyTypes:
    //                                                                   'warning');
    //                                                         } else {
    //                                                           if (boxManager
    //                                                               .Create_New_Box(
    //                                                                   trimmedValue)) {
    //                                                             SmartDialog
    //                                                                 .dismiss();
    //                                                             showToast('成功',
    //                                                                 notifyTypes:
    //                                                                     "success");
    //                                                             setState(
    //                                                               () {
    //                                                                 update.Update_Box_Data(
    //                                                                     context);

    //                                                                 Box_data = Provider.of<App>(
    //                                                                         context,
    //                                                                         listen:
    //                                                                             false)
    //                                                                     .Box_data;
    //                                                                 keys = Box_data
    //                                                                     .keys
    //                                                                     .toList();
    //                                                               },
    //                                                             );
    //                                                           } else {
    //                                                             showToast(
    //                                                                 '[错误10002]失败',
    //                                                                 notifyTypes:
    //                                                                     "failureer");
    //                                                           }
    //                                                         }
    //                                                       },
    //                                                       child:
    //                                                           const Text('确定')),
    //                                                 )
    //                                               ],
    //                                             )
    //                                           ],
    //                                         ),
    //                                       ),
    //                                     );
    //                                   });
    //                                 },
    //                                 child: const Text('新建箱子')),
    //                             Expanded(child: Container()),
    //                             ElevatedButton(
    //                                 //读入零件按下出发的事件
    //                                 onPressed: () {
    //                                   List Na = getValuesFromCell(
    //                                       excel.tables[Sheetname.text]!,
    //                                       Name.text);
    //                                   List Co = getValuesFromCell(
    //                                       excel.tables[Sheetname.text]!,
    //                                       Count.text);
    //                                   List IntCo;
    //                                   try {
    //                                     IntCo = Co.map((val) =>
    //                                         int.parse(val.toString())).toList();
    //                                   } catch (e) {
    //                                     SmartDialog.dismiss();
    //                                     showToast('零件数量列不是纯数字，是不是选错了？',
    //                                         notifyTypes: "warning");
    //                                     return;
    //                                   }
    //                                   if (Na.length != IntCo.length) {
    //                                     SmartDialog.dismiss();
    //                                     showToast('零件名和数量不一致，是不是选错了?',
    //                                         notifyTypes: "warning");
    //                                     return;
    //                                   } else {
    //                                     setState(() {
    //                                       Excel_data = List.generate(
    //                                           Na.length,
    //                                           (index) => [
    //                                                 Na[index],
    //                                                 IntCo[index],
    //                                                 '00000'
    //                                               ]);
    //                                     });
    //                                     dropdowncontrol = List<
    //                                             SingleSelectController>.generate(
    //                                         Excel_data.length,
    //                                         (index) =>
    //                                             SingleSelectController(null));
    //                                   }
    //                                 },
    //                                 child: const Text('读入零件'))
    //                           ],
    //                         )),
    //                     const Padding(padding: EdgeInsets.only(top: 10)),
    //                     Container(
    //                         width: 100,
    //                         height: 2,
    //                         decoration: const BoxDecoration(
    //                           color: Colors.black38,
    //                         )),
    //                     Expanded(
    //                         child: ListView.builder(
    //                             itemCount: Excel_data.length,
    //                             itemBuilder: (context, index) {
    //                               return Row(
    //                                 mainAxisAlignment:
    //                                     MainAxisAlignment.spaceBetween,
    //                                 children: [
    //                                   const Icon(Icons.category_outlined),
    //                                   const Padding(
    //                                       padding: EdgeInsets.only(bottom: 10)),
    //                                   SizedBox(
    //                                     width: 100,
    //                                     child: Text(
    //                                       Excel_data[index][0].toString(),
    //                                       overflow: TextOverflow
    //                                           .ellipsis, // 超出部分用省略号表示
    //                                       maxLines: 1,
    //                                     ),
    //                                   ),
    //                                   const SizedBox(width: 10),
    //                                   SizedBox(
    //                                       width: 130,
    //                                       height: 60,
    //                                       child: CustomDropdown(
    //                                         controller: dropdowncontrol[index],
    //                                         items: keys,
    //                                         onChanged: (value) {
    //                                           print('index:$index');
    //                                           print('value:$value');
    //                                           setState(() {
    //                                             dropdowncontrol[index].value =
    //                                                 value;
    //                                             Excel_data[index][2] =
    //                                                 Box_data[value];
    //                                           });
    //                                         },
    //                                       )),
    //                                 ],
    //                               );
    //                             })),
    //                     SizedBox(
    //                       //保存按钮按下发生的事件
    //                       child: IconButton(
    //                           onPressed: () {
    //                             print(Excel_data);
    //                             if (Excel_data.any((sublist) =>
    //                                     sublist[2].trim() == '00000') ||
    //                                 Excel_data[0][0].trim() == '请读入零件') {
    //                               showToast('未读入零件或个别零件没选箱子',
    //                                   notifyTypes: 'warning');
    //                             } else {
    //                               for (List Excel_data_item in Excel_data) {
    //                                 boxManager.Set_One_Box_Data(
    //                                     Excel_data_item[2].toString(),
    //                                     Excel_data_item[0].toString(),
    //                                     Excel_data_item[1].toString(),
    //                                     update.get_Now_Time());
    //                               }
    //                               SmartDialog.dismiss();
    //                               showToast('导入成功');
    //                             }
    //                           },
    //                           icon: const Icon(Icons.save)),
    //                     )
    //                   ],
    //                 ),
    //               );
    //             }),
    //           ));
    //     });
    //   } else {
    //     showToast('目前只支持xlsx格式', notifyTypes: "failure");
    //   }
    // } catch (e) {
    //   showToast('[错误10011]Excel导入过程出问题', notifyTypes: "failure");
    //   SmartDialog.dismiss();
    // }
  }

// 从Excel中获取数据
  List<dynamic> getValuesFromCell(sheet, String cellAddress) {
    if (sheet == null) {
      throw Exception('Sheet not found.');
    }
    // 解析单元格地址
    int row = int.parse(cellAddress.substring(1)) - 1; // 行索引
    int col = cellAddress.codeUnitAt(0) - 'A'.codeUnitAt(0); // 列索引
    // 从指定单元格开始获取值
    List<dynamic> values = [];
    for (var r in sheet.rows.skip(row)) {
      // 从指定行开始
      if (r.length > col) {
        // 确保列索引在范围内
        values.add(r[col]?.value); // 获取对应列的值
      } else {
        break; // 如果当前行没有更多的列，退出循环
      }
    }
    return values;
  }
}
