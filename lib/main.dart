import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:passmanager/screens/datascreen.dart';
import 'package:passmanager/screens/imageFullScreen.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/adddata.dart';
import 'screens/homepage.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Data Manager'),
      routes: {
        DataScreen.routeName: (ctx)=>const DataScreen(),
        AddData.routeName: (ctx)=>const AddData(),
        MyHomePage.routeName: (ctx)=>const MyHomePage(title: 'Data Manager'),
      },
    );
  }
}