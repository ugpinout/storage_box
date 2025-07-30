import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class ThanksPage extends StatelessWidget {
  const ThanksPage({super.key});

  // 插件信息列表 - 包含插件名称、作者/组织、GitHub地址
  static const List<Map<String, String>> packages = [
    // 原有插件
    {
      'name': 'shirne_dialog',
      'author': 'shirne',
      'url': 'https://github.com/shirne/shirne_dialog'
    },
    {
      'name': 'fluttertoast',
      'author': 'ponnamkarthik',
      'url': 'https://github.com/ponnamkarthik/FlutterToast'
    },
    {
      'name': 'flutter_slider_drawer',
      'author': 'theindianappguy',
      'url': 'https://github.com/theindianappguy/flutter_slider_drawer'
    },
    {
      'name': 'provider',
      'author': 'rrousselGit',
      'url': 'https://github.com/rrousselGit/provider'
    },
    {
      'name': 'flutter_smart_dialog',
      'author': 'fluttercandies',
      'url': 'https://github.com/fluttercandies/flutter_smart_dialog'
    },
    {
      'name': 'share_plus',
      'author': 'fluttercommunity',
      'url':
          'https://github.com/fluttercommunity/plus_plugins/tree/main/packages/share_plus'
    },
    {
      'name': 'file_picker',
      'author': 'miguelpruivo',
      'url': 'https://github.com/miguelpruivo/flutter_file_picker'
    },
    {
      'name': 'archive',
      'author': 'dart-lang',
      'url': 'https://github.com/dart-lang/archive'
    },
    {
      'name': 'permission_handler',
      'author': 'baseflow',
      'url': 'https://github.com/baseflow/flutter-permission-handler'
    },
    {
      'name': 'path_provider',
      'author': 'flutter',
      'url':
          'https://github.com/flutter/packages/tree/main/packages/path_provider'
    },
    {
      'name': 'device_info_plus',
      'author': 'fluttercommunity',
      'url':
          'https://github.com/fluttercommunity/plus_plugins/tree/main/packages/device_info_plus'
    },
    {
      'name': 'animated_custom_dropdown',
      'author': 'gabuldev',
      'url': 'https://github.com/gabuldev/animated_custom_dropdown'
    },

    // 新增插件
    {
      'name': 'flutter_toastr',
      'author': 'aliyazdi75',
      'url': 'https://github.com/aliyazdi75/flutter_toastr'
    },
    {
      'name': 'text_mask',
      'author': 'igormidev',
      'url': 'https://github.com/igormidev/text_mask'
    },
    {
      'name': 'flutter_excel',
      'author': 'hnvn',
      'url': 'https://github.com/hnvn/flutter_excel'
    },
    {
      'name': 'permission_handler_windows',
      'author': 'baseflow',
      'url':
          'https://github.com/baseflow/flutter-permission-handler/tree/main/permission_handler_windows'
    },
    {
      'name': 'url_launcher',
      'author': 'flutter',
      'url':
          'https://github.com/flutter/packages/tree/main/packages/url_launcher'
    },
    {
      'name': 'icons_plus',
      'author': 'pub.dev',
      'url': 'https://github.com/fluttercommunity/icons_plus'
    },
    {
      'name': 'cupertino_icons',
      'author': 'flutter',
      'url': 'https://github.com/flutter/cupertino_icons'
    },
  ];
  // 打开GitHub链接
  Future<void> _launchUrl(String url, BuildContext context) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // 此时可以正常使用传递进来的context
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('无法打开链接: $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('鸣谢'),
        backgroundColor: Colors.yellow,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 头部说明
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            child: const Text(
              '本应用使用了以下开源插件，感谢所有开发者的贡献',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // 插件列表
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: packages.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final package = packages[index];
                return ListTile(
                  leading: const CircleAvatar(
                    // GitHub图标
                    // ignore: sort_child_properties_last
                    child: Icon(Bootstrap.github, color: Colors.black),
                    backgroundColor: Colors.white, // GitHub主色调
                  ),
                  title: Text(
                    package['name']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text('作者: ${package['author']}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _launchUrl(package['url']!, context),
                  // 添加点击反馈效果
                  tileColor: Colors.transparent,
                  hoverColor: Theme.of(context).highlightColor,
                  splashColor: Theme.of(context).splashColor,
                );
              },
            ),
          ),
          FlutterLogo(size: 50)
        ],
      ),
    );
  }
}
