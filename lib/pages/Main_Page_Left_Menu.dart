// ignore_for_file: file_names,unused_import, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:storage_box/Socket.dart';
import 'package:storage_box/ThanksPage.dart';
import 'package:storage_box/module/ExcelManager.dart';
import 'package:storage_box/module/SocketManager.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:shirne_dialog/shirne_dialog.dart';

import '../module/toast.dart';
import '../module/Update.dart';
import '../module/FileManager.dart';
import '../module/BoxManager.dart';
import '../Setting.dart';

Update update = Update();
File_Manager fileManager = File_Manager();
// Box_Manager boxManager = Box_Manager();
Excelmanager excelmanager = Excelmanager();

class left_menu extends StatelessWidget {
  final dynamic sliderKey;
  const left_menu({super.key, required this.sliderKey});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        const Padding(
          padding: EdgeInsets.zero,
          child: UserAccountsDrawerHeader(
            accountName: Center(child: Text('收纳盒')),
            accountEmail: null,
            currentAccountPicture: Center(
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/icons/icon.png'),
                radius: 35.0,
              ),
            ),
          ),
        ),
        Expanded(
            child: ListView(
          children: [
            ListTile(
              tileColor: Colors.white,
              dense: true,
              leading: const Icon(Icons.add_box),
              title: const Text('添加新的盒子'),
              subtitle:
                  const Text('这里可以添加新的盒子', style: TextStyle(fontSize: 10.0)),
              trailing: const Icon(Icons.arrow_right),
              // 添加新的盒子按钮按下的时候触发的事件
              onTap: () => {
                MyDialog.prompt(
                    title: '请输入箱子名',
                    buttonText: "确认",
                    cancelText: "取消",
                    onConfirm: (v) {
                      String trimmedValue = v.trim(); // 修剪掉空格
                      if (trimmedValue.isEmpty) {
                        showToast("输入点什么吧");
                        return false;
                      } else if (update.is_breaking_Json_Format(trimmedValue)) {
                        showToast("内容包含破坏数据格式的符号，请修改", notifyTypes: 'warning');
                        return false;
                      } else {
                        if (boxManager.Create_New_Box(trimmedValue)) {
                          showToast('成功', notifyTypes: "success");
                          update.Update_Box_Data(context);
                          sliderKey.currentState!.toggle();
                        } else {
                          showToast('[错误10002]失败', notifyTypes: "failureer");
                        }
                        return true;
                      }
                    })
              },
            ),
            ListTile(
              tileColor: Colors.white,
              dense: true,
              leading: const Icon(Icons.settings_applications_outlined),
              title: const Text('设置'),
              subtitle:
                  const Text('可以修改一些通用设置', style: TextStyle(fontSize: 10.0)),
              trailing: const Icon(Icons.arrow_right),
              // 配置FTP服务器按钮按下的时候触发的事件
              onTap: () => {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Setting_Page())),
                sliderKey.currentState!.toggle(),
              },
            ),
            ListTile(
              tileColor: Colors.white,
              dense: true,
              leading: const Icon(Icons.cloud_done),
              title: const Text('备份/恢复数据'),
              subtitle:
                  const Text('备份或恢复服务器上的数据', style: TextStyle(fontSize: 10.0)),
              trailing: const Icon(Icons.arrow_right),
              onTap: () => {
                // 备份/恢复数据按钮按下的时候触发的事件
                showToast('本版本没开发此功能', notifyTypes: "warning"),
                sliderKey.currentState!.toggle(),
              },
            ),
            ListTile(
              tileColor: Colors.white,
              dense: true,
              leading: const Icon(Icons.lan),
              title: const Text('局域网跨设备传数据'),
              subtitle: const Text('一台设备的数据复制到别的设备',
                  style: TextStyle(fontSize: 10.0)),
              trailing: const Icon(Icons.arrow_right),
              onTap: () => {
                // 备份/恢复数据按钮按下的时候触发的事件
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Socket_Page())),
                sliderKey.currentState!.toggle(),
              },
            ),
            ListTile(
              tileColor: Colors.white,
              dense: true,
              leading: const Icon(Icons.import_export),
              title: const Text('导入/导出数据'),
              subtitle:
                  const Text('在本地导入或导出数据', style: TextStyle(fontSize: 10.0)),
              trailing: const Icon(Icons.arrow_right),
              // 导入/导出数据按钮按下的时候触发的事件
              onTap: () => {
                _import_export_box(context),
                sliderKey.currentState!.toggle(),
              },
            ),
            ListTile(
              tileColor: Colors.white,
              dense: true,
              leading: const Icon(Icons.book_online_outlined),
              title: const Text('使用手册'),
              subtitle:
                  const Text('或许能帮你熟悉本应用', style: TextStyle(fontSize: 10.0)),
              trailing: const Icon(Icons.arrow_right),
              //
              // 用户协议按钮按下的时候触发的事件
              onTap: () => {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          "用户协议",
                          style: TextStyle(fontSize: 20),
                        ),
                        content: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 500,
                            maxHeight: 500,
                          ),
                          child: Column(
                            children: [
                              SingleChildScrollView(
                                child: ExpansionTile(
                                  initiallyExpanded: false, // 初始展开状态
                                  onExpansionChanged: (bool expanded) {},
                                  title: const Text('如何修改箱子信息？'),
                                  children: const <Widget>[
                                    Text('答：长按对应箱子的图标'),
                                  ],
                                ),
                              ),
                              SingleChildScrollView(
                                child: ExpansionTile(
                                  initiallyExpanded: false, // 初始展开状态
                                  onExpansionChanged: (bool expanded) {},
                                  title: const Text('箱子数据文件在哪？'),
                                  children: const <Widget>[
                                    Text(
                                        '答：根目录/android/data/com.Flutter.Material.Box/files/boxs/\n这个目录下载每一个json文件代表一个箱子\n尽量不要碰那些文件，除非你很懂json数据'),
                                  ],
                                ),
                              ),
                              SingleChildScrollView(
                                child: ExpansionTile(
                                  initiallyExpanded: false, // 初始展开状态
                                  onExpansionChanged: (bool expanded) {},
                                  title: const Text('怎么找到指定文件？'),
                                  children: const <Widget>[
                                    Text(
                                        '答：长按对应箱子列表下面有箱子id,那个id就是箱子文件名，再次提示如果不懂Json数据格式，尽量不要修改那些文件'),
                                  ],
                                ),
                              ),
                              SingleChildScrollView(
                                child: ExpansionTile(
                                  initiallyExpanded: false, // 初始展开状态
                                  onExpansionChanged: (bool expanded) {},
                                  title: const Text('遇到Bug怎么办？'),
                                  children: const <Widget>[
                                    Text(
                                        '答：添加作者QQ或者邮箱留言，也可以直接关注公众号留言，这样也能获得文件最新版本，联系方式[关于App]里面有'),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    })
              },
            ),
            ListTile(
              tileColor: Colors.white,
              dense: true,
              leading: const Icon(Icons.my_library_books_outlined),
              title: const Text('用户协议'),
              subtitle: const Text('用于推卸责任', style: TextStyle(fontSize: 10.0)),
              trailing: const Icon(Icons.arrow_right),
              //用户协议按钮按下的时候触发的事件
              onTap: () => {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          "用户协议",
                          style: TextStyle(fontSize: 20),
                        ),
                        content: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 500,
                              maxHeight: 300,
                            ),
                            child: const SingleChildScrollView(
                              child: Column(children: [
                                Text(
                                    '用户协议\n1. 许可协议\n本应用使用[MIT协议]授权，您可以在[https://mit-license.org/]中查看完整的许可证条款。您有权修改本应用的源代码，但必须遵守以下条件。\n2. 使用限制\n本应用仅供个人非商业使用。禁止将本应用用于商业目的。\n允许修改本应用的源代码，但不得将修改后的版本用于销售或商业分发。\n禁止以任何形式出售、转售或将本应用的副本用于商业目的。\n3. 免责条款\n本应用按“现状”提供，不提供任何明示或暗示的保证。使用本应用的风险由用户自担。我们不对因使用本应用而产生的任何直接或间接损失承担责任。\n4. 隐私政\n我们可能会收集一些用户数据，用于改进应用性能。我们保证官网渠道下载的版本不会主动上传用户的任何信息在网上。\n5. 法律适用\n本协议适用[开发者所在地法律]。因本协议引发的争议应提交至[开发者户籍所在地]解决。\n6. 联系方式\n如有任何疑问或需要进一步的信息，请通过以下方式与我们联系：\nQQ：2280711844\n Email:2280711844@qq.com\n代码开源地址:\nhttps://github.com/ugpinout/storage_box\nhttps://gitee.com/infinite0078/storage_box'),
                              ]),
                            )),
                      );
                    })
              },
            ),
            ListTile(
              tileColor: Colors.white,
              dense: true,
              leading: const Icon(Icons.album),
              title: const Text('关于App'),
              subtitle:
                  const Text('一些没必要知道的事情', style: TextStyle(fontSize: 10.0)),
              trailing: const Icon(Icons.arrow_right),
              //关于App按钮按下的时候触发的事件
              onTap: () => {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          "关于App",
                          style: TextStyle(fontSize: 20),
                        ),
                        content: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 500,
                              maxHeight: 300,
                            ),
                            child: const SingleChildScrollView(
                              child: Column(children: [
                                Text('介绍：\n收纳盒App是整理和管理物品的好帮手。'
                                    '无论是家庭用品、办公文具、个人物品还是电子零件，'
                                    '这款App帮助您高效地记录和追踪每一个物品的数量。'
                                    '用户可以轻松创建多个收纳盒，添加物品，并通过直观的界面查看详细信息。'
                                    '\n功能亮点：\n简易管理：快速添加和编辑物品，实时更新数量。\n分类整理：按类别和标签组织物品，轻松找到所需。\n分享功能：与家人或团队共享箱子信息。\n结语：\n无论您是想要保持家庭井井有条，还是希望在办公环境中提高效率，收纳盒App都能满足您的需求！\n联系方式：\nQQ：2280711844\n Email:2280711844@qq.com\n[感谢认真看完作者吹牛的短文]'),
                              ]),
                            )),
                      );
                    })
              },
            ),
            //鸣谢
            ListTile(
              tileColor: Colors.white,
              dense: true,
              trailing: const Icon(Icons.arrow_right),
              leading: const Icon(Icons.favorite),
              subtitle:
                  const Text('开发软件所用的插件', style: TextStyle(fontSize: 10.0)),
              title: const Text('鸣谢'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ThanksPage(),
              )),
            ),
          ],
        )),
      ],
    ));
  }
}

// 导入导出箱子
void _import_export_box(BuildContext context) {
  SmartDialog.show(builder: (_) {
    return Container(
      width: 150,
      height: 100,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(children: [
        ElevatedButton(
          onPressed: () => import_box(context),
          child: const Text('导入箱子'),
        ),
        Expanded(
          child: Container(), // 用于填充空白空间
        ),
        ElevatedButton(
          onPressed: () => Export_Box(context),
          child: const Text('导出箱子'),
        )
      ]),
    );
  });
}

// 导出箱子
void Export_Box(context) {
  SmartDialog.dismiss();
  SmartDialog.show(builder: (_) {
    return Container(
      width: 150,
      height: 100,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              SmartDialog.dismiss();
              boxManager.Compress_All_Box();
            },
            child: const Text(
              '导出所有箱子[zip]',
              style: TextStyle(fontSize: 11),
            ),
          ),
          Expanded(
            child: Container(), // 用于填充空白空间
          ),
          ElevatedButton(
            onPressed: () => Export_BOX_Excel(context),
            child: const Text(
              '导出所有箱子[Excel]',
              style: TextStyle(fontSize: 11),
            ),
          ),
        ],
      ),
    );
  });
}

// 导出Excel
void Export_BOX_Excel(context) {
  excelmanager.Export_To_Excel(context);
}

// 导入单个文件
void import_box(context) {
  SmartDialog.dismiss(force: true);
  SmartDialog.show(builder: (_) {
    return Container(
      width: 150,
      height: 150,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(children: [
        ElevatedButton(
          onPressed: () => Import_Box_Zip(context, app),
          child: const Text('多个箱子[zip]'),
        ),
        Expanded(
          child: Container(), // 用于填充空白空间
        ),
        ElevatedButton(
          onPressed: () => import_box_json(context, app),
          child: const Text('单个箱子[json]'),
        ),
        // Expanded(
        //   child: Container(), // 用于填充空白空间
        // ),
        // ElevatedButton(
        //   onPressed: () => Import_Box_Excel(context),
        //   child: const Text('导入Excel'),
        // )
      ]),
    );
  });
}

// 导入Excel
void Import_Box_Excel(context) {
  SmartDialog.dismiss();
  excelmanager.Import_Excel_To_File(context);
}

// 导入zip文件
void Import_Box_Zip(BuildContext context, app) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();
  if (result != null) {
    if (result.files.single.path.toString().endsWith('zip')) {
      final bytes = File(result.files.single.path as String).readAsBytesSync();
      final archive = ZipDecoder().decodeBytes(bytes);
      for (final file in archive) {
        if (file.isFile == true && file.toString().endsWith('.json')) {
          fileManager.Create_New_File(
              app.prj_path, update.get_Now_Time(), utf8.decode(file.content));
        }
        update.Update_Box_Data(context);
        app.notifyListeners();
        SmartDialog.dismiss(force: true);
        showToast('导入成功', notifyTypes: 'success');
      }
    } else {
      SmartDialog.dismiss(force: true);
      showToast('请选择zip文件', notifyTypes: "failure");
    }
  }
}

// 导入json文件
void import_box_json(BuildContext context, app) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();
  if (result != null) {
    if (result.files.single.path.toString().endsWith('json')) {
      final bytes = File(result.files.single.path as String).readAsBytesSync();
      fileManager.Create_New_File(
          app.prj_path, update.get_Now_Time(), utf8.decode(bytes));
      update.Update_Box_Data(context);
      app.notifyListeners();
      SmartDialog.dismiss(force: true);
      showToast('导入成功', notifyTypes: 'success');
    } else {
      SmartDialog.dismiss(force: true);
      showToast('请选择json文件', notifyTypes: "failure");
    }
  }
}
