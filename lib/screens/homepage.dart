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
      body: FutureBuilder(
        future: isChanging ? null : loadSharedPreferences(),
        builder: (context, snapshot) => SingleChildScrollView(
          child: SizedBox(
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
                        'Manage Your document easy and safely at One Place',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      SizedBox(height: mediaquery.height * 0.02),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GlassmorphicContainer(
                          width: mediaquery.width * 0.9,
                          height: 50,
                          borderRadius: 10,
                          blur: 10,
                          border: 0,
                          linearGradient: linearGradiend(),
                          borderGradient: borderGradient(),
                          child: TextFormField(
                            onChanged: (value) async {
                              isChanging = true;
                              var data = await SharedPref.read('data');
                              list = DataItem.decode(data);
                              print(value);
                              setState(() {
                                list = list
                                    .where((element) =>
                                        element.title.contains(value) ||
                                        element.description.contains(value) ||
                                        element.id.contains(value))
                                    .toList();
                                print(list);
                              });
                            },
                            style: TextStyle(color: Colors.white),
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
                    SizedBox(height: mediaquery.height * 0.15),
                    Container(
                      // alignment: Alignment.bottomCenter,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        color: Colors.white,
                      ),
                      height: mediaquery.height * 0.73,
                      // color: Colors.red,
                      child: ListView.builder(
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
                                      // ListTile(
                                      //   title: Text("Edit"),
                                      //   trailing: Icon(
                                      //     Icons.edit,
                                      //     color: Colors.green,
                                      //   ),
                                      //   onTap: () {
                                      //     Navigator.of(context).pop();
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => AddData(
                                      //       dataItem: list[index],
                                      //     ),
                                      //   ),
                                      // );
                                      // },
                                      // ),
                                      ListTile(
                                        title: Text("Delete"),
                                        trailing: Icon(
                                          Icons.delete_forever_sharp,
                                          color: Colors.red,
                                        ),
                                        onTap: () async {
                                          String data =
                                              await SharedPref.read('data');
                                          List<DataItem> newlist =
                                              DataItem.decode(data);
                                          setState(() {
                                            newlist = newlist
                                                .where((element) =>
                                                    element.title !=
                                                    list[index].title)
                                                .toList();
                                            SharedPref.save('data',
                                                DataItem.encode(newlist));
                                          });
                                          await loadSharedPreferences();
                                          Navigator.of(context).pop();
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Draggable(
        // bool feedback = true,
        onDragEnd: (_) {
          // print("drag end");
          FacebookInterstitialAd.loadInterstitialAd(
            placementId: "328150579086879_328163679085569",
            listener: (result, value) {
              if (result == InterstitialAdResult.LOADED) {
                FacebookInterstitialAd.showInterstitialAd();
              }
            },
          );
        },
        feedback: FloatingActionButton(
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
        child: FloatingActionButton(
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
      ),
      bottomNavigationBar: FacebookBannerAd(
        placementId: '328150579086879_328154279086509',
        bannerSize: BannerSize.STANDARD,
      ),
    );
  }
}
