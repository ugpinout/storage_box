// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Box.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/module/SocketManager.dart';
import 'package:flutter_application_1/module/toast.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:text_mask/text_mask.dart';

Socket_Manager socketmanager = Socket_Manager();
void connect_Mode_select_Dialog(context, app) {
  SmartDialog.show(builder: (context) {
    return Container(
      width: 300,
      height: 220,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Column(
        children: [
          const Text('选择模式', style: TextStyle(fontSize: 20)),
          Container(
            padding: const EdgeInsets.only(top: 30),
            width: 290,
            child: ElevatedButton(
              //创建服务器点击事件
              onPressed: () {
                socketmanager.Create_Socket(
                        socketmanager.generateRandomPort(1024, 65535))
                    .then((_) {
                  app.notifyListeners();
                  //模式设置
                  app.Socket_Var['Connect_Mode'] = '发送模式';
                  app.Socket_Var['Connect_Mode_Color'] = Colors.green;
                  app.notifyListeners();
                  //连接设备的数量
                  app.Socket_Var['Connect_type'] = '成功创建';
                  app.Socket_Var['Connect_type_Color'] = Colors.green;
                  app.notifyListeners();

                  //搭建的IP地址和端口
                  app.Socket_Var['Remote_IP'] =
                      '${socketmanager.localIP}:${socketmanager.localPort}';
                  app.Socket_Var['Connect_addr_Color'] = Colors.green;
                  app.notifyListeners();
                });
                SmartDialog.dismiss();
              },
              child: const Text('创建房间 - [发送数据]'),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10),
            width: 290,
            child: ElevatedButton(
              onPressed: () => connect_clinet(app),
              child: const Text('连接房间 - [接收数据]'),
            ),
          ),
          //Icon点击控件
          SizedBox(
            width: 280,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => help_Dialog(context),
                  icon: const Icon(
                    Icons.help_rounded,
                    color: Colors.blue,
                    size: 30,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  });
}

//连接服务器
void connect_clinet(app) {
  SmartDialog.dismiss();
  TextEditingController IPEditor = TextEditingController();
  TextEditingController PortEditor = TextEditingController();
  SmartDialog.show(builder: (_) {
    return Container(
        width: 300,
        height: 180,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: Column(children: [
          const Text('输入房间信息', style: TextStyle(fontSize: 20)),
          Row(
            children: [
              // IP输入框
              Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    width: 200,
                    child: TextField(
                        controller: IPEditor,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          // FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.allow(RegExp(r'[.0-9]')),
                          LengthLimitingTextInputFormatter(12),
                        ],
                        decoration:
                            const InputDecoration(label: Text('IP 地址'))),
                  )),
              Container(
                padding: const EdgeInsets.only(left: 10, top: 30),
                width: 0,
                child: const Text(
                  ':',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              // 端口号
              Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.only(left: 30, right: 10),
                    width: 40,
                    child: TextField(
                        controller: PortEditor,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(5),
                          TextMask(pallet: '#####'),
                        ],
                        decoration: const InputDecoration(label: Text('端口号'))),
                  ))
            ],
          ),
          Container(
            padding: const EdgeInsets.only(top: 10),
            width: 290,
            child: ElevatedButton(
              //端口连接按钮按下事件
              onPressed: () async {
                await socketmanager.getLocalIPAddress().then((local_ip) {
                  if (IPEditor.text.isEmpty || PortEditor.text.isEmpty) {
                    showToast('哈↑哈↓', notifyTypes: 'alert');
                  } else {
                    socketmanager.Connect_Socket(
                            IPEditor.text, int.parse(PortEditor.text))
                        .then((type) {
                      if (type == true) {
                        app.Socket_Var['Connect_Mode'] = '接收模式';
                        app.Socket_Var['Connect_Mode_Color'] = Colors.green;
                        app.Socket_Var['Connect_type'] =
                            '已连接 - [${IPEditor.text}:${PortEditor.text}]';
                        app.Socket_Var['Connect_type_Color'] = Colors.green;
                        app.Socket_Var['Remote_IP'] = '本地地址：$local_ip';
                        app.Socket_Var['Connect_addr_Color'] = Colors.green;
                        app.notifyListeners();
                      }
                    });
                  }
                });
                SmartDialog.dismiss();
              },
              child: const Text('连接房间'),
            ),
          ),
        ]));
  });
}

void help_Dialog(context) {
  SmartDialog.show(
      builder: (_) => Container(
          width: 300,
          height: 400,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: const Column(children: [
            Text('帮助', style: TextStyle(fontSize: 20)),
            SizedBox(
              width: 290,
              child: Column(
                children: [
                  Text(
                      "1. 传输原理：\n这个是在局域网内搭建Socket 服务器来实现两个设备一对多传输数据。数据不会流传到外网，用户不用担心数据和隐私安全问题。唯一缺点是两个谁被必须在同一个局域网内【必须连接同一个WIFI,或有线网段】"),
                  Text(
                      "-----\n2.创建房间:【仅用于发送数据】创建一个房间【局域网服务器】,等待其他用户连接。创建完房间后显示的内网【IP地址】和【端口】发给需要连接的局域网设备即可。"),
                  Text('-----\n3.连接房间:【仅用于接收数据】, 用户需要输入创建房间的【IP地址】和【端口】，即可连接。')
                ],
              ),
            )
          ])));
}

void send_file_dialog(BuildContext context, app) {
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
          height: 400, // 设置对话框的高度
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
                            onPressed: () => send_file(transformedData, app),
                            icon: const Icon(Icons.send)),
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

Future<void> send_file(data, app) async {
  if (app.Socket_Var['Connect_Mode'] == '未连接') {
    showToast('先点击右上角选择发送模式', notifyTypes: 'warning');
  } else if (app.Socket_Var['Connect_Mode'] == '接收模式') {
    showToast('接收模式下，不能发送文件', notifyTypes: 'failure');
  } else if (socketmanager.servernum == null) {
    showToast('没有客户端连接本服务器', notifyTypes: 'failure');
  } else if (data
      .every((subArray) => subArray.length > 2 && subArray[2] == false)) {
    showToast('啊？什么都没选？发送？', notifyTypes: 'failure');
  } else {
    for (List item in data) {
      if (item[2] == true) {
        await socketmanager.send_data(item[1].toString()).then((val) {});
        app.addFile(item[0]);
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }
  }
}
