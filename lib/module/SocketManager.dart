// ignore_for_file: file_names, invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:demo/Box.dart';
import 'package:demo/Socket.dart';
import 'package:demo/module/FileManager.dart';
import 'package:demo/module/toast.dart';

class Socket_Manager {
  String localIP = '0.0.0.0';
  int localPort = 0;

  ServerSocket? currentServer; // 存储当前的服务器实例
  Socket? currentclinet; //存储当前客户端
  Socket? servernum;

//创建socket服务器
  Future<void> Create_Socket(int Port) async {
    try {
      // 如果当前有服务器实例，先关闭它
      if (currentServer != null) {
        await currentServer!.close(); // 关闭服务器
        showToast('旧服务器和所有客户端已关闭');
      }

      // 创建一个新的服务器，监听指定的端口
      currentServer = await ServerSocket.bind(InternetAddress.anyIPv4, Port);
      localIP = await getLocalIPAddress();

      showToast('服务器已启动：$localIP,${currentServer!.port}');
      localPort = currentServer!.port;

      // 启动处理连接的任务
      handleConnections(currentServer!); // 传入server对象

      // 直接返回，允许 onPressed 中的 then() 执行
      return;
    } catch (e) {
      showToast('[错误10007]创建Socket时出错，重新试试看', notifyTypes: "failure");
    }
  }

// 用于处理连接的函数
  Future<void> handleConnections(ServerSocket server) async {
    await for (var socket in server) {
      servernum = socket;
      showToast('客户端已连接: ${socket.remoteAddress.address}:${socket.remotePort}');
      app.notifyListeners();
      // app.Socket_Var['Remote_IP'] = '本地地址：$local_ip';
      // app.Socket_Var['Connect_addr_Color'] = Colors.green;
      handleClient(socket);
    }
  }

// 处理客户端连接
  void handleClient(Socket socket) {
    socket.listen((data) {
      // 处理接收到的数据

      // 回复客户端
      socket.write('Message received');
    }, onDone: () {
      showToast('对方已断开: ${socket.remoteAddress.address}:${socket.remotePort}');
      socket.close();
    });
  }

// 关闭Socket服务器
  Future<void> Close_Socket_server() async {
    try {
      if (currentServer != null) {
        await currentServer!.close(); // 关闭服务器
        showToast('以断开连接');
      }
    } catch (e) {
      showToast('[错误10009]结束已建立的房间失败', notifyTypes: "failure");
    }

    return;
  }

// 关闭Socket客户端
  Future<void> Close_Socket_clinet() async {
    try {
      if (currentclinet != null) {
        await currentclinet!.close(); // 关闭服务器
        showToast('以断开连接');
      }
    } catch (e) {
      showToast('[错误10009]结束已建立的房间失败', notifyTypes: "failure");
    }

    return;
  }

// 获取本地IP地址
  Future<String> getLocalIPAddress() async {
    final interfaces = await NetworkInterface.list();
    for (var interface in interfaces) {
      for (var addr in interface.addresses) {
        if (addr.address.contains('.')) {
          // 过滤IPv4地址
          return addr.address;
        }
      }
    }
    return "None";
  }

//创建socket客户端，连接 Socket 服务器
  Future<bool> Connect_Socket(dynamic ip, int Port, context) async {
    try {
      // 连接到服务器
      currentclinet = await Socket.connect(ip, Port);
      showToast('已连接到服务器');
      connect_clinet_handle(currentclinet, context);
      // 监听服务器的响应

      return true;
    } catch (e) {
      showToast('连接失败: $e', notifyTypes: 'failure');
      return false;
    }
  }

// 送服务器来的数据接收
  void connect_clinet_handle(socket, context) {
    socket.listen(
      (data) {
        saveToFile(data);
        // showToast(file.path);
      },
    );
  }

//从服务器来的数据保存到本地
  Future<void> saveToFile(Uint8List data) async {
    // 生成唯一的文件名（例如：根据时间戳）
    final file = File('${app.prj_path}/${update.get_Now_Time()}.json');
    // 写入文件
    await file.writeAsBytes(data);
    // 将数据转换为字符串
    String jsonString = utf8.decode(data);
    // 解析 JSON 数据
    Map<String, dynamic> jsonData = json.decode(jsonString);
    // 提取 Box_Name
    String boxName = jsonData['Box_Name'];
    // 将 Box_Name 添加到成功文件列表或其他变量中
    Apps.addFile(boxName);

    // 通知 listeners
    // app.notifyListeners();
  }

//服务器给客户端发消息，
  Future<bool> send_data(String data) async {
    if (servernum != null) {
      File file = File('${app.prj_path}/$data.json'); // 要发送的文件
      List<int> bytes = await file.readAsBytes(); // 读

      servernum!.add(bytes);
      await servernum!.flush(); // 确保所有数据都被发送

      return true;
    } else {
      showToast('没有连接的客户端', notifyTypes: 'warning');
      return false;
    }
  }

// 生成随机端口
  int generateRandomPort(int min, int max) {
    Random random = new Random();
    return random.nextInt(max - min + 1) + min;
  }
}
