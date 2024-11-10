// ignore_for_file: file_names, invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
import 'package:flutter/material.dart';
import 'package:demo/module/toast.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';
import '../module/FileManager.dart';
import '../module/app.dart';
import '../Box.dart';

File_Manager fileManager = File_Manager();

class Image_Box extends StatefulWidget {
  const Image_Box({
    super.key,
  });

  @override
  State<Image_Box> createState() => _Image_BoxState();
}

class _Image_BoxState extends State<Image_Box> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(5),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 100,
        crossAxisSpacing: 5,
        childAspectRatio: 9 / 9,
        mainAxisSpacing: 10,
      ),
      itemCount: Provider.of<App>(context).Box_Counts,
      itemBuilder: (BuildContext context, int index) {
        // 这里添加你的构建逻辑
        return GestureDetector(
            onTap: () {
              //箱子单击事件
              String id = Provider.of<App>(context, listen: false).Box_data[
                  Provider.of<App>(context, listen: false).Box_Name[index]]!;
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Box_Item(
                        names: id,
                        item_names: 'None',
                      )));
            },
            onLongPress: () {
              //箱子长按事件
              String id = Provider.of<App>(context, listen: false).Box_data[
                  Provider.of<App>(context, listen: false).Box_Name[index]]!;
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Center(
                        child: Text(
                          Provider.of<App>(context, listen: false)
                              .Box_Name[index],
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      content: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 500,
                          maxHeight: 300,
                        ),
                        child: Column(children: [
                          ListTile(
                              dense: true,
                              leading: const Icon(Icons.edit),
                              title: const Text(
                                '修改箱子名称',
                                style: TextStyle(fontSize: 20),
                              ),
                              // 修改箱子名称按钮按下的时候触发的事件
                              onTap: () => {_Rename_box_dialog(context, id)}),
                          ListTile(
                            dense: true,
                            leading: const Icon(Icons.delete),
                            title: const Text(
                              '删除本箱子',
                              style: TextStyle(fontSize: 20),
                            ),
                            // 删除箱子按钮按下的时候触发的事件
                            onTap: () => {_delete_box_dialog(context, id)},
                          ),
                          ListTile(
                            dense: true,
                            leading: const Icon(Icons.share),
                            title: const Text(
                              '分享本箱子',
                              style: TextStyle(fontSize: 20),
                            ),
                            // 分享箱子按钮按下的时候触发的事件
                            onTap: () => {boxManager.share_One_Box(id)},
                          ),
                          ListTile(
                            dense: true,
                            leading: const Icon(Icons.open_in_browser),
                            title: const Text(
                              '导出本箱子',
                              style: TextStyle(fontSize: 20),
                            ),
                            // 分享箱子按钮按下的时候触发的事件
                            onTap: () => {
                              Navigator.of(context).pop(),
                              fileManager.Copy_File_To_Dir(id),
                            },
                          ),
                          ListTile(
                            dense: true,
                            leading: const Icon(Icons.delete_forever),
                            title: const Text(
                              '批量删除箱子',
                              style: TextStyle(fontSize: 20),
                            ),
                            // 批量删除箱子按钮按下的时候触发的事件
                            onTap: () => {
                              Navigator.of(context).pop(),
                              _delete_box_dialog_all(context),
                            },
                          ),
                          Expanded(
                            child: Container(), // 用于填充空白空间
                          ),
                          Text('箱子id:$id')
                        ]),
                      ),
                    );
                  });
            },
            child: Container(
              // color: Colors.yellow,
              padding: const EdgeInsets.all(4),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/box-close.png',
                    width: 40,
                    height: 40,
                  ),
                  Center(
                      child: Container(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Text(
                              Provider.of<App>(context).Box_Name[index],
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 10.0,
                              ),
                            ),
                          ))),
                ],
              ),
            ));
      },
    );
  }
}

//批量删除箱子对话框
void _delete_box_dialog_all(context) {
  Map<String, String> box_data = {};
  box_data = boxManager.Create_Box_Data_Map(
      fileManager.Get_All_file_Name(context),
      boxManager.Get_All_Box_Name(
          context, fileManager.Get_All_file_Name(context)));

  List<List<dynamic>> transformedData = box_data.entries.map((entry) {
    String key = entry.key;
    String value = entry.value;
    bool isSelected = false;
    return [key, int.parse(value), isSelected];
  }).toList();

  SmartDialog.show(
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SizedBox(
          width: 300, // 设置对话框的宽度
          height: 500, // 设置对话框的高度
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('箱子列表', style: TextStyle(fontSize: 20)),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: transformedData.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              child: Checkbox(
                                value: transformedData[index][2],
                                onChanged: (bool? value) {
                                  setState(() {
                                    transformedData[index][2] = value!;
                                  });
                                },
                              ),
                            ),
                            Text(transformedData[index][0]),
                          ],
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            // 全选
                            setState(() {
                              for (var item in transformedData) {
                                item[2] = true;
                              }
                            });
                          },
                          icon: const Icon(Icons.select_all),
                        ),
                        Expanded(child: Container()),
                        IconButton(
                            // 删除按钮
                            onPressed: () async => {
                                  for (var item in transformedData)
                                    {
                                      if (item[2])
                                        {
                                          boxManager.Del_one_Box(item[1]),
                                          update.Update_Box_Data(context),
                                          await Future.delayed(
                                              const Duration(milliseconds: 50)),
                                        }
                                    },
                                  //按钮禁止使用

                                  SmartDialog.dismiss(),
                                  showToast('删除成功'),
                                },
                            icon: const Icon(Icons.delete)),
                        Expanded(child: Container()),
                        IconButton(
                          onPressed: () {
                            // 取消全选
                            setState(() {
                              for (var item in transformedData) {
                                item[2] = false;
                              }
                            });
                          },
                          icon: const Icon(Icons.deselect),
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
  );
}

// 删除箱子对话框
void _delete_box_dialog(context, id) {
  SmartDialog.show(builder: (_) {
    return Container(
        width: 300,
        height: 100,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: Column(
          children: [
            const Text(
              "这个操作不可挽回，确定删除吗？",
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.cancel),
                    label: const Text("取消"),
                    onPressed: () {
                      SmartDialog.dismiss();
                    },
                  ),
                ),
                Expanded(
                  child: Container(), // 用于填充空白空间
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text("确定"),
                    onPressed: () {
                      boxManager.Del_one_Box(id);
                      update.Update_Box_Data(context);
                      SmartDialog.dismiss();
                      showToast("成功", notifyTypes: 'success');
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        ));
  });
}

// 修改箱子名称对话框
void _Rename_box_dialog(context, id) {
  final TextEditingController nameController = TextEditingController();
  SmartDialog.show(builder: (_) {
    return Container(
      width: 300,
      height: 150,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: '输入箱子名称'),
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.cancel),
                  label: const Text("取消"),
                  onPressed: () {
                    SmartDialog.dismiss();
                  },
                ),
              ),
              Expanded(
                child: Container(), // 用于填充空白空间
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text("添加"),
                  onPressed: () {
                    String partName = nameController.text;
                    bool A = update.is_breaking_Json_Format(partName);
                    if (nameController.text.isEmpty) {
                      showToast("好有趣的名字，再想想别的！", notifyTypes: 'warning');
                    } else if (A == true) {
                      showToast("名字包含破坏数据格式的符号，请修改！", notifyTypes: 'warning');
                    } else {
                      boxManager.Set_Box_Name(id, partName);
                      SmartDialog.dismiss();
                      update.Update_Box_Data(context);
                      showToast("成功", notifyTypes: 'success');
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  });
}
