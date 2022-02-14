// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:passmanager/constants/colors.dart';
import 'package:passmanager/constants/storage.dart';
import 'package:passmanager/models/additem.dart';
import 'package:passmanager/models/dataitem.dart';
import 'package:passmanager/screens/sharedpref.dart';
import 'package:url_launcher/url_launcher.dart';

import 'adddata.dart';
import 'datascreen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  static const routeName = '/MyHomePage';

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<DataItem> list = [];
  bool isChanging = false;
  // final LocalStorage storage = LocalStorage(Storage.storageName);

  loadSharedPreferences() async {
    String? data = await SharedPref.read('data');
    print("SHARED DATA $data");
    if (data == null) {
      return;
    } else {
      list = DataItem.decode(data);
      print("Decoded lst $list");
      Add.dataList = list;
    }
    FlutterNativeSplash.remove();
  }

  @override
  void initState() {
    super.initState();
    // loadSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.primary,
        title: const Text(
          'Document Keeper',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text(
                'Keep Document',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              decoration: BoxDecoration(
                color: MyColors.primary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('Helpful Resources:'),
            ),
            ListTile(
              title: Text('Aadhar Details'),
              onTap: () {
                launch('https://uidai.gov.in/');
              },
            ),
            ListTile(
              title: Text('Passport Details'),
              onTap: () {
                launch('https://www.passportindia.gov.in/');
              },
            ),
            ListTile(
              title: Text('Voter ID Details'),
              onTap: () {
                launch('https://www.nvsp.in/');
              },
            ),
            ListTile(
              title: Text('Driving License'),
              onTap: () {
                launch(
                    'https://parivahan.gov.in/parivahan/en/content/driving-licence-0');
              },
            ),
            ListTile(
              title: Text('Samagra ID Details'),
              onTap: () {
                launch('http://samagra.gov.in/');
              },
            ),
            ListTile(
              title: Text('PAN Details'),
              onTap: () {
                launch(
                    'https://www.onlineservices.nsdl.com/paam/endUserRegisterContact.html');
              },
            ),
            ListTile(
              title: Text('Ration Card Details'),
              onTap: () {
                launch(
                    'https://nfsa.gov.in/portal/ration_card_state_portals_aa');
              },
            ),
          ],
        ),
      ),
    );
  }
}
