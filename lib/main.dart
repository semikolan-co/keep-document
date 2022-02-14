import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:passmanager/models/dataitem.dart';
import 'package:passmanager/screens/datascreen.dart';
import 'package:passmanager/screens/introscreen.dart';
import 'package:passmanager/screens/sharedpref.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/adddata.dart';
import 'screens/homepage.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await FacebookAudienceNetwork.init();
  final String? data = await SharedPref.read('data')??'';
  runApp(MyApp(data: data,));
}

class MyApp extends StatelessWidget {
  const MyApp({key,this.data}) : super(key: key);
  final String? data;
  @override
  Widget build(BuildContext context){
    List<DataItem> dataList = [];
    if(data!=null && data!=''){
      dataList = DataItem.decode(data.toString());
    }
    return MaterialApp(
      title: 'Keep Document',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: dataList.isEmpty? const IntroScreen(): const MyHomePage(title: 'Document Keeper'),
      routes: {
        DataScreen.routeName: (ctx) => const DataScreen(),
        AddData.routeName: (ctx) => const AddData(),
        MyHomePage.routeName: (ctx) => const MyHomePage(title: 'Data Manager'),
      },
    );
  }
}
