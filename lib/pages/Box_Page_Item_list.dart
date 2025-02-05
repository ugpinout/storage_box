// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:storage_box/Box.dart';
import 'package:storage_box/main.dart';
import 'package:storage_box/module/BoxManager.dart';
import 'package:storage_box/module/Update.dart';
import 'package:storage_box/module/toast.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

Update update = Update();
Box_Manager boxManager = Box_Manager();

class CustomListItem extends StatefulWidget {
  final IconData icon;
  final String text;
  final int count;
  final int item_id;
  final String selects;
  const CustomListItem(
      {super.key,
      required this.icon,
      required this.text,
      required this.count,
      required this.item_id,
      required this.selects});
  @override
  _CustomListItem createState() {
    return _CustomListItem();
  }
}

class _CustomListItem extends State<CustomListItem> {
  int _count = 0;
  final TextEditingController quantityController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _count = widget.count;
    update.Update_Item_data(context, Global_ID);
  }

  @override
  Widget build(BuildContext context) {
    Color textColor =
        (widget.selects == widget.text) ? Colors.green : Colors.black;
    return ListTile(
      leading: Icon(widget.icon),
      title:
          Text(widget.text, style: TextStyle(fontSize: 16, color: textColor)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            //按下减号的时候触发的事件
            onPressed: () {
              setState(() {
                if (_count > 0) {
                  _count--;
                  itemManager.Set_Item_count(Global_ID, widget.item_id, _count);
                } else {
                  showToast('没有啦！！', notifyTypes: 'warning');
                }
              });
            },
          ),
          GestureDetector(
            child: Text('$_count'),
            // 点击数量文本框的时候触发的事件
            onTap: () {
              SmartDialog.show(
                  clickMaskDismiss: false,
                  onMask: () => SmartDialog.dismiss(),
                  builder: (_) {
                    return Container(
                      width: 300,
                      height: 170,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            child: TextField(
                              maxLength: 5,
                              textAlignVertical: TextAlignVertical.center,
                              controller: quantityController,
                              decoration: const InputDecoration(
                                  hintText: '输入零件数量[最多五位数]'),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 30),
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.cancel),
                                  label: const Text("取消"),
                                  onPressed: () => SmartDialog.dismiss(),
                                ),
                              ),
                              Expanded(
                                child: Container(), // 用于填充空白空间
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 30),
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.add),
                                  label: const Text("确定"),
                                  onPressed: () {
                                    itemManager.Set_Item_count(
                                        Global_ID,
                                        widget.item_id,
                                        quantityController.text);
                                    update.Update_Item_data(context, Global_ID);
                                    setState(() {
                                      _count =
                                          int.parse(quantityController.text);
                                    });
                                    SmartDialog.dismiss();
                                    showToast('成功', notifyTypes: 'success');
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  });
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            //按下加号的时候触发的事件
            onPressed: () {
              setState(() {
                _count++;
                itemManager.Set_Item_count(Global_ID, widget.item_id, _count);
              });
            },
          ),
        ],
      ),
      onLongPress: () => Item_On_Press(context, app, Global_ID, widget.item_id),
    );
  }
}

//零件长按时间
void Item_On_Press(context, app, Box_ID, Item_ID) {
  // final Item_Data = Provider.of<App>(context, listen: false);
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
              child: Text(
            "${itemManager.Get_Item_Name(Box_ID, Item_ID)}",
            style: const TextStyle(fontSize: 20),
          )),
          content: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
              maxHeight: 300,
            ),
            child: Column(
              children: [
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.edit),
                  title: const Text(
                    '修改零件名称',
                    style: TextStyle(fontSize: 20),
                  ),
                  // 按下修改按钮的时候触发的事件
                  onTap: () =>
                      Rename_Item_dialog(context, app, Global_ID, Item_ID),
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.delete),
                  title: const Text(
                    '删除零件',
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () =>
                      Remove_Item_Dialog(context, app, Global_ID, Item_ID),
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.numbers),
                  title: const Text(
                    '修改零件数量',
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    showToast("可以直接点击零件数量进行修改", notifyTypes: 'alert');
                    Navigator.of(context).pop();
                  },
                ),
                Expanded(
                  child: Container(), // 用于填充空白空间
                ),
                Text('零件ID:$Item_ID')
              ],
            ),
          ),
        );
      });
}

void Remove_Item_Dialog(context, app, Box_ID, Item_ID) {
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
                      itemManager.Del_One_Item(Box_ID, Item_ID);
                      update.Update_Box_Data(context);
                      update.Update_Item_data(context, Box_ID);
                      app.notifyListeners();
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

//修改零件名称
void Rename_Item_dialog(context, app, Box_ID, Item_ID) {
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
              decoration: const InputDecoration(hintText: '输入零件名字'),
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
                  label: const Text("确定"),
                  onPressed: () {
                    String partName = nameController.text;
                    bool A = update.is_breaking_Json_Format(partName);
                    if (nameController.text.isEmpty) {
                      showToast("好有趣的名字，再想想别的！", notifyTypes: 'warning');
                    } else if (A == true) {
                      showToast("名字包含破坏数据格式的符号，请修改！", notifyTypes: 'warning');
                    } else {
                      itemManager.Set_Item_Name(Global_ID, Item_ID, partName);
                      SmartDialog.dismiss();
                      update.Update_Box_Data(context);
                      app.notifyListeners();
                      update.Update_Item_data(context, Box_ID);
                      app.notifyListeners();
                      showToast("成功", notifyTypes: 'success');
                      app.notifyListeners();
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

//添加新零件
void Add_New_Item(BuildContext context, app) {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final Item_ID = update.get_Now_Time();
  SmartDialog.show(
      clickMaskDismiss: false,
      onMask: () => SmartDialog.dismiss(),
      builder: (_) {
        return Container(
          width: 300,
          height: 300,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: '输入零件名称'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                child: TextField(
                  controller: quantityController,
                  decoration: const InputDecoration(hintText: '输入零件数量'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 30),
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
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 30),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text("添加"),
                      onPressed: () {
                        String partName = nameController.text;
                        String partQuantity = quantityController.text;
                        if (update.is_breaking_Json_Format(partName)) {
                          showToast('内容包含破坏数据格式的符号，请修改！',
                              notifyTypes: 'warning');
                        } else if (partName.isEmpty || partQuantity.isEmpty) {
                          showToast('[警告]请输入完整的信息', notifyTypes: "warning");
                        } else {
                          boxManager.Set_One_Box_Data(
                              Global_ID, partName, partQuantity, Item_ID);
                          update.Update_Box_Data(context);
                          update.Update_Item_data(context, Global_ID);
                          app.notifyListeners();
                          SmartDialog.dismiss();
                          app.notifyListeners();
                          showToast('添加成功', notifyTypes: 'success');
                          app.notifyListeners();
                        }
                        app.notifyListeners();
                      },
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(),
              ),
              Text('零件id:$Item_ID'),
            ],
          ),
        );
      });
}
