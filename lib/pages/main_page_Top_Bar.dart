// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:storage_box/search.dart';
import 'Main_Page_Box_List.dart';
import 'Main_Page_Left_Menu.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

class Top_Bar extends StatefulWidget {
  const Top_Bar({super.key});

  @override
  State<Top_Bar> createState() => _Top_BarState();
}

class _Top_BarState extends State<Top_Bar> {
  final GlobalKey<SliderDrawerState> _sliderDrawerKey =
      GlobalKey<SliderDrawerState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SliderDrawer(
        key: _sliderDrawerKey,
        slider: left_menu(
          sliderKey: _sliderDrawerKey,
        ),
        appBar: SliderAppBar(
          trailing: InkWell(
            child: const Icon(
              Icons.search,
              size: 30.0,
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Search_Page()));
            },
          ),
          appBarColor: Colors.yellow,
          title: const Text(
            '收纳盒',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
        ),
        child: Container(
          color: Colors.white,
          child: const Image_Box(),
        ),
      ),
    );
  }
}
