// ignore_for_file: library_private_types_in_public_api, file_names, invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, void_checks

import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/module/app.dart';
import 'package:flutter_application_1/module/toast.dart';
import 'package:flutter_application_1/pages/Socket_Page_Chat_List.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';

dynamic Apps;

class Socket_Page extends StatefulWidget {
  const Socket_Page({super.key});

  @override
  _Socket_Page createState() {
    return _Socket_Page();
  }
}

class _Socket_Page extends State<Socket_Page> {
  // 获取箱子名称和文件名称
  @override
  void initState() {
    super.initState();
    FlutterSmartDialog.init();
  }

  @override
  void dispose() {
    super.dispose();
    //
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<App>(builder: (context, app, child) {
      Apps = app;
      return PopScope(
          onPopInvokedWithResult: (canPop, result) {
            if (canPop) {
              socketmanager.Close_Socket_clinet();
              socketmanager.Close_Socket_server();
              app.reset_Socket_Var();
              update.Update_Box_Data(context);
            } else {
              showToast('[错误10008]初始化参数有问题，下次传输数据前务必重启应用',
                  notifyTypes: "failure");
            }
            if (Navigator.canPop(context)) {
              update.Update_Box_Data(context);
              Navigator.pop(context);
            }
          },
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () => send_file_dialog(context, app),
              backgroundColor: Colors.yellow,
              child: const Icon(
                Icons.send,
                color: Colors.lightBlue,
              ),
            ),
            appBar: AppBar(
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      update.Update_Box_Data(context);
                      socketmanager.Close_Socket_clinet();
                      socketmanager.Close_Socket_server();
                      app.reset_Socket_Var();
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    }),
                backgroundColor: Colors.yellow,
                title: const Center(child: Text("传输文件")),
                actions: [
                  IconButton(
                      icon: const Icon(Icons.connect_without_contact),
                      onPressed: () {
                        connect_Mode_select_Dialog(context, app);
                      })
                ]),
            body: Column(
              children: [
                ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                        leading: const Icon(Icons.lan),
                        title: Row(
                          children: [
                            const Text('模式：'),
                            //填充空白
                            Expanded(child: Container()),
                            Text(app.Socket_Var['Connect_Mode'],
                                style: TextStyle(
                                    color:
                                        app.Socket_Var['Connect_Mode_Color'])),
                          ],
                        )),
                    ListTile(
                        leading: const Icon(Icons.wifi),
                        title: Row(
                          children: [
                            const Text('状态'),
                            //填充空白
                            Expanded(child: Container()),
                            Text(app.Socket_Var['Connect_type'],
                                style: TextStyle(
                                    color:
                                        app.Socket_Var['Connect_type_Color'])),
                          ],
                        )),
                    ListTile(
                        leading: const Icon(Icons.place),
                        title: Row(
                          children: [
                            const Text('地址'),
                            //填充空白
                            Expanded(child: Container()),
                            Text(app.Socket_Var['Remote_IP'],
                                style: TextStyle(
                                    color:
                                        app.Socket_Var['Connect_addr_Color'])),
                          ],
                        )),
                  ],
                ),
                Container(
                    width: 100,
                    height: 2,
                    decoration: const BoxDecoration(
                      color: Colors.black38,
                    )),
                Expanded(
                  child: ListView.builder(
                    itemCount: app.sendOrAddSuccessFileList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.file_present),
                        title: Text(app.sendOrAddSuccessFileList[index]),
                        trailing: const Icon(
                          Icons.check_box,
                          color: Colors.green,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ));
    });
  }
}
