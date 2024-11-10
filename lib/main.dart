//模块路径
// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names, use_build_context_synchronously, use_function_type_syntax_for_parameters, invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:shirne_dialog/shirne_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:demo/module/Update.dart';
import 'module/app.dart';
import 'pages/main_page_Top_Bar.dart';
import 'module/FileManager.dart';

File_Manager fileManager = File_Manager();
App app = App();
Update update = Update();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => App())],
      child: const MainPage()));
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Main_Inint(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        builder: FlutterSmartDialog.init(),
        navigatorKey: MyDialog.navigatorKey,
        debugShowCheckedModeBanner: false,
        home: const Top_Bar(),
        theme: ThemeData(primarySwatch: Colors.yellow));
  }
}

Future<void> Main_Inint(BuildContext context) async {
  bool type = await fileManager.Is_A_Dir('boxs', context);

  if (!type) {
    MyDialog.alert('致命错误\n[错误10001]目录创建失败，请退出软件', buttonText: '好咧',
        onConfirm: () {
      SystemNavigator.pop();
      return false;
    }, barrierColor: const Color.fromARGB(200, 255, 235, 59));
  } else {
    update.Update_Box_Data(context);
  }
}
