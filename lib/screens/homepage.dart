// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:lottie/lottie.dart';
import 'package:passmanager/utils/colors.dart';
import 'package:passmanager/utils/storage.dart';
import 'package:passmanager/models/additem.dart';
import 'package:passmanager/models/dataitem.dart';
import 'package:passmanager/models/sharedpref.dart';
import 'package:passmanager/widgets/custom_alert.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/deleteconfirmation.dart';
import '../widgets/drawer.dart';
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
  bool _speechEnabled = false;
  final TextEditingController _searchController = TextEditingController();
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
    // FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.primary,
        title: const Text(
          'Keep Document',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      drawer: DrawerWidget(),
      body: FutureBuilder(
        future: isChanging ? null : loadSharedPreferences(),
        builder: (context, snapshot) => SingleChildScrollView(
          child: SizedBox(
            // height: mediaquery.height*0.95,
            child: Stack(
              children: [
                Container(
                  height: mediaquery.height * 0.4,
                  width: mediaquery.width,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
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
                          height: mediaquery.height * 0.06,
                          borderRadius: 10,
                          blur: 10,
                          border: 0,
                          linearGradient: linearGradiend(),
                          borderGradient: borderGradient(),
                          child: TextFormField(
                            controller: _searchController,
                            onChanged: (value) async {
                              print(_searchController.text.toString());
                              isChanging = true;
                              var data = await SharedPref.read('data');
                              try {
                                list = DataItem.decode(data);
                              } catch (e) {
                                list = [];
                              }
                              print(value);
                              setState(() {
                                list = list
                                    .where((element) =>
                                        element.title
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase()) ||
                                        element.description
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase()) ||
                                        element.id
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase()))
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
                      child: list.isEmpty
                          ? _searchController.text.toString().isEmpty
                              ? Lottie.asset('assets/emptyall.json')
                              : Lottie.asset('assets/emptysearch.json')
                          : ListView.builder(
                              itemBuilder: (ctx, index) => Dismissible(
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) {
                                  deleteConfirmationDialog(
                                      context,
                                      () => deleteItem(index),
                                      () => setState(() {}));
                                },
                                key: UniqueKey(),
                                background: Container(
                                  color: Colors.blueGrey,
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                child: ListTile(
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
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20)),
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
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => AddData(
                                                    dataItem: list[index],
                                                  ),
                                                ),
                                              );
                                              },
                                              ),
                                              ListTile(
                                                title: Text("Delete"),
                                                trailing: Icon(
                                                  Icons.delete_forever_sharp,
                                                  color: Colors.red,
                                                ),
                                                onTap: () async {
                                                  deleteConfirmationDialog(
                                                      context,
                                                      (){Navigator.of(context).pop();deleteItem(index);},
                                                      () => Navigator.of(context).pop());
                                                  // await deleteItem(index);
                                                },
                                              ),
                                              Spacer(),
                                              FacebookBannerAd(
                                                placementId: Storage
                                                    .facebookBannerPlacement,
                                                bannerSize: BannerSize.STANDARD,
                                              ),
                                              FacebookBannerAd(
                                                placementId: Storage
                                                    .facebookBannerPlacement,
                                                bannerSize: BannerSize.STANDARD,
                                              )
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
                                    Add.pdfUrl.clear();
                                    if (list[index].pdfPath != null) {
                                      for (var pdf
                                          in list[index].pdfPath ?? []) {
                                        Add.pdfUrl.add(pdf.toString());
                                      }
                                    }
                                    Navigator.pushNamed(
                                        context, DataScreen.routeName,
                                        arguments: list[index]);
                                  },
                                ),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        elevation: 10,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(15),
        //   side: BorderSide(color: Color.fromARGB(179, 238, 37, 37), width: 5),
        // ),
        child: Icon(
          Icons.add,
          color: MyColors.primary,
        ),
        onPressed: () {
          Add.imgUrl.clear();
          Add.pdfUrl.clear();
          Navigator.pushNamed(context, AddData.routeName, arguments: list);
        },
      ),
      bottomNavigationBar: FacebookBannerAd(
        placementId: Storage.facebookBannerPlacement,
        bannerSize: BannerSize.STANDARD,
      ),
    );
  }

  Future<void> deleteItem(int index) async {
    String data = await SharedPref.read('data');
    List<DataItem> newlist = DataItem.decode(data);
    setState(() {
      newlist = newlist
          .where((element) => element.title != list[index].title)
          .toList();
      SharedPref.save('data', DataItem.encode(newlist));
    });
    await loadSharedPreferences();
  }
}
