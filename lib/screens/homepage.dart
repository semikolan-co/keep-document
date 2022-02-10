import 'dart:io';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:passmanager/constants/storage.dart';
import 'package:passmanager/models/additem.dart';
import 'package:passmanager/models/dataitem.dart';
import 'package:passmanager/screens/sharedpref.dart';

import 'adddata.dart';
import 'datascreen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  static const routeName = '/home';

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<DataItem> list = [];
  // final LocalStorage storage = LocalStorage(Storage.storageName);

  loadSharedPreferences() async {
    String? data = await SharedPref.read('data');
    print("SHARED DATA $data");
    if(data==null){
      return;
    }
    else {
      list = DataItem.decode(data);
      print("Decoded lst $list");
      Add.dataList = list;
    }
  }

  @override
  void initState() {
    super.initState();
    loadSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: loadSharedPreferences(),
        builder: (context, snapshot) => ListView.builder(
          itemBuilder: (ctx, index) => ListTile(
            title: Text(list[index].title.toString()),
            subtitle: Text(list[index].description.toString()),
            leading: list[index].imgUrl.isNotEmpty? CircleAvatar(
              backgroundImage: Image.file(
                File(list[index].imgUrl[0]),
                fit: BoxFit.fill,
              ).image,
            ):null,
            onTap:(){
              Add.imgUrl.clear();
              for (var img in list[index].imgUrl) {
                Add.imgUrl.add(img.toString());
              }
              Navigator.pushNamed(context, DataScreen.routeName,
                arguments: list[index]);},
          ),
          itemCount: list.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Add.imgUrl.clear();
            Navigator.pushNamed(context, AddData.routeName, arguments: list);},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: FacebookBannerAd(
        placementId: '328150579086879_328154279086509',
        bannerSize: BannerSize.STANDARD,
      ),
    );
  }
}
