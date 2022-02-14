// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:passmanager/constants/colors.dart';
import 'package:passmanager/constants/storage.dart';
import 'package:passmanager/models/additem.dart';
import 'package:passmanager/models/dataitem.dart';
import 'package:passmanager/screens/sharedpref.dart';

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
  }

  @override
  void initState() {
    super.initState();
    loadSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.primary,
        title:const Text(
          'Document Keeper',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text(
                'Document Keeper',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              decoration: BoxDecoration(
                color: MyColors.primary,
              ),
            ),
            ListTile(
              title: Text('Add Data'),
              onTap: () {
                Navigator.pushNamed(context, AddData.routeName);
              },
            ),
            ListTile(
              title: Text('View Data'),
              onTap: () {
                Navigator.pushNamed(context, DataScreen.routeName);
              },
            ),
            ListTile(
              title: Text('Add Item'),
              onTap: () {
                // Navigator.pushNamed(context, AddItem.routeName);
              },
            ),
            ListTile(
              title: Text('View Item'),
              onTap: () {
                // Navigator.pushNamed(context, AddItem.routeName);
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                // SharedPref.delete('data');
                Navigator.pushNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      body: SizedBox(
        height: mediaquery.height,
        child: Stack(
          children: [
            Container(
              height: mediaquery.height * 0.5,
              width: mediaquery.width,
              child: Column(
                children: [
                   SizedBox(height: 10),
                  // Row(
                  //   children: [
                  //     Spacer(
                  //       flex: 1,
                  //     ),
                  //     const Icon(
                  //       Icons.eco,
                  //       size: 30,
                  //       color: Colors.white,
                  //     ),
                  //     Spacer(
                  //       flex: 1,
                  //     ),
                  //     Text(
                  //       'Document Keeper',
                  //       style: TextStyle(fontSize: 30, color: Colors.white),
                  //     ),
                  //     Spacer(
                  //       flex: 2,
                  //     ),
                  //   ],
                  // ),
                  Text(
                    'Manage Your document safely loremds fdkfjaskfnsdmfnkjsadnlsafnjanldlk',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.visible,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GlassmorphicContainer(
                      width: mediaquery.width * 0.9,
                      height: 50,
                      borderRadius: 10,
                      blur: 10,
                      // alignment: Alignment.,
                      border: 0,
                      linearGradient: linearGradiend(),
                      borderGradient: borderGradient(),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),

                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.white),
                          // hintText: 'Search Docs',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(color: MyColors.primary),
            ),
            Column(
              children: [
                SizedBox(height: mediaquery.height * 0.2),
                Container(
                  // alignment: Alignment.bottomCenter,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: Colors.white,
                  ),
                  height: mediaquery.height * 0.63,
                  // color: Colors.red,
                  child: FutureBuilder(
                    future: loadSharedPreferences(),
                    builder: (context, snapshot) => ListView.builder(
                      itemBuilder: (ctx, index) => ListTile(
                        title: Text(list[index].title.toString()),
                        subtitle: Text(list[index].id.toString()),
                        leading: list[index].imgUrl.isNotEmpty
                            ?
                            //  Container(
                            //     height: 100,
                            //     width: 100,
                            //     child: FileImage(
                            //       File(list[index].imgUrl[0]),
                            //       // fit: BoxFit.fill,
                            //     ).image,
                            //   )

                            CircleAvatar(
                                backgroundImage: Image.file(
                                  File(list[index].imgUrl[0]),
                                  fit: BoxFit.fill,
                                ).image,
                              )
                            : CircleAvatar(
                                backgroundColor:
                                    colors[index % colors.length],
                                child: Text("${index + 1}"),
                              ),
                        trailing: IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              // isScrollControlled: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              context: context,
                              builder: (context) => Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Text("Choose an action"),
                                    SizedBox(height: 10),
                                    ListTile(
                                      title: Text("Edit"),
                                      trailing: Icon(
                                        Icons.edit,
                                        color: Colors.green,
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) => AddData(
                                        //       dataItem: list[index],
                                        //     ),
                                        //   ),
                                        // );
                                      },
                                    ),
                                    ListTile(
                                      title: Text("Delete"),
                                      trailing: Icon(
                                        Icons.delete_forever_sharp,
                                        color: Colors.red,
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        setState(() {
                                          list.removeAt(index);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.more_vert_outlined,
                            size: 20,
                          ),
                        ),
                        onTap: () {
                          Add.imgUrl.clear();
                          for (var img in list[index].imgUrl) {
                            Add.imgUrl.add(img.toString());
                          }
                          Navigator.pushNamed(context, DataScreen.routeName,
                              arguments: list[index]);
                        },
                      ),
                      itemCount: list.length,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        elevation: 10,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(15),
        //   side: BorderSide(color: Color.fromARGB(179, 238, 37, 37), width: 5),
        // ),
        onPressed: () {
          Add.imgUrl.clear();
          Navigator.pushNamed(context, AddData.routeName, arguments: list);
        },
        tooltip: 'Increment',
        child: Icon(
          Icons.add,
          size: 40,
          color: MyColors.primary,
        ),
      ),
      bottomNavigationBar: FacebookBannerAd(
        placementId: '328150579086879_328154279086509',
        bannerSize: BannerSize.STANDARD,
      ),
    );
  }
}
