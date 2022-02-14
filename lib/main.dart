import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:passmanager/screens/image_full_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:passmanager/screens/datascreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/adddata.dart';
import 'screens/homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance();
  FacebookAudienceNetwork.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Data Manager'),
      routes: {
        DataScreen.routeName: (ctx) => const DataScreen(),
        AddData.routeName: (ctx) => const AddData(),
        MyHomePage.routeName: (ctx) => const MyHomePage(title: 'Data Manager'),
      },
    );
  }
}
