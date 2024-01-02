import 'dart:io';
import 'package:in_app_update/in_app_update.dart';
// import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:lottie/lottie.dart';
import 'package:passmanager/models/additem.dart';
import 'package:passmanager/models/dataitem.dart';
import 'package:passmanager/models/sharedpref.dart';
import 'package:passmanager/screens/edit_data.dart';
import 'package:passmanager/utils/colors.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:applovin_max/applovin_max.dart';
import '../widgets/deleteconfirmation.dart';
import '../widgets/drawer.dart';
import 'adddata.dart' as addDataWidget;
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
  final TextEditingController _searchController = TextEditingController();
  AppUpdateInfo? _updateInfo;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  // bool _flexibleUpdateAvailable = false;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });
    }).catchError((e) {
      showSnack(e.toString());
    });
  }

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }

  loadSharedPreferences() async {
    String? data = await SharedPref.read('data');
    if (data == null) {
      return;
    } else {
      list = DataItem.decode(data);
      // print("Decoded lst $list");
      Add.dataList = list;
    }
    // FlutterNativeSplash.remove();
  }

  @override
  initState() {
    _updateInfo?.updateAvailability == UpdateAvailability.updateAvailable
        ? () {
            InAppUpdate.startFlexibleUpdate();
          }
        : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.primary,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Keep Document',
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      drawer: const DrawerWidget(),
      body: FutureBuilder(
        future: isChanging ? null : loadSharedPreferences(),
        builder: (context, snapshot) => SingleChildScrollView(
          child: SizedBox(
            child: Stack(
              children: [
                Container(
                  height: mq.height * 0.4,
                  decoration: const BoxDecoration(color: MyColors.primary),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      headingText(),
                      SizedBox(height: mq.height * 0.02),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GlassmorphicContainer(
                          width: mq.width * 0.9,
                          height: mq.height * 0.06,
                          borderRadius: 10,
                          blur: 10,
                          border: 0,
                          linearGradient: linearGradiend(),
                          borderGradient: borderGradient(),
                          child: TextFormField(
                            controller: _searchController,
                            onChanged: (value) async {
                              // print(_searchController.text.toString());
                              isChanging = true;
                              var data = await SharedPref.read('data');
                              try {
                                list = DataItem.decode(data);
                              } catch (e) {
                                list = [];
                              }
                              // print(value);
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
                                // print(list);
                              });
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: searchFieldInputDecoration(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    SizedBox(height: mq.height * 0.18),
                    Container(
                      // alignment: Alignment.bottomCenter,

                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        color: Colors.white,
                      ),
                      height: mq.height * 0.73,
                      // color: Colors.red,
                      child: list.isEmpty
                          ? _searchController.text.toString().isEmpty
                              ? Lottie.asset('assets/emptyall.json')
                              : Lottie.asset('assets/emptysearch.json')
                          : ListView.builder(
                              padding: const EdgeInsets.only(bottom: 50),
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
                                    children: const [
                                      Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(
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
                                      SizedBox(
                                          height: 40,
                                          width: 40,
                                          child: Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              image: DecorationImage(
                                                  image: Image.file(
                                                File(list[index].imgUrl[0]),
                                                fit: BoxFit.fill,
                                              ).image),
                                              border: Border.all(
                                                  color: MyColors.borderColor,
                                                  style: BorderStyle.solid),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(10),
                                              ), //BorderRadius.all
                                            ),
                                            // child: DecorationImage(
                                            //     image: Image.file(
                                            //   File(list[index].imgUrl[0]),
                                            //   fit: BoxFit.fitWidth,
                                            // )),
                                          ),
                                        )
                                      :

                                      // CircleAvatar(
                                      //     backgroundImage: Image.file(
                                      //       File(list[index].imgUrl[0]),
                                      //       fit: BoxFit.fill,
                                      //     ).image,
                                      //   )
                                      // :
                                      // CircleAvatar(
                                      //     backgroundColor: MyColors.primary,
                                      //     child: Text("${index + 1}"),
                                      //   ),
                                      // :
                                      SizedBox(
                                          height: 40,
                                          width: 40,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: MyColors.primary,
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: Center(
                                              child: Text(
                                                "${index + 1}",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          // child: Text("${index + 1}"),
                                          // decoration: BoxDecoration(
                                          //     color: MyColors.primary,
                                          //     borderRadius:
                                          //         BorderRadius.circular(50)),
                                        ),
                                  // )
                                  trailing: IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        // isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20)),
                                        ),
                                        context: context,
                                        builder: (context) => Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            children: [
                                              const Text(
                                                "Choose an action",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              const SizedBox(height: 10),
                                              ListTile(
                                                title: const Text("Share"),
                                                trailing: const Icon(
                                                  Icons.share,
                                                  color: Colors.blue,
                                                ),
                                                onTap: () {
                                                  final List<String> strs =
                                                      list[index]
                                                          .imgUrl
                                                          .map((e) =>
                                                              e.toString())
                                                          .toList();
                                                  if (list[index].pdfPath !=
                                                      null) {
                                                    strs.addAll(list[index]
                                                        .pdfPath!
                                                        .map(
                                                            (e) => e.toString())
                                                        .toList());
                                                  }
                                                  strs.isNotEmpty
                                                      ? Share.shareFiles(strs,
                                                          text:
                                                              '${list[index].id} ${list[index].title} \n ${list[index].description}',
                                                          subject:
                                                              list[index].title)
                                                      : Share.share(
                                                          '${list[index].title} \n ${list[index].description}');
                                                },
                                              ),
                                              ListTile(
                                                title: const Text("Delete"),
                                                trailing: const Icon(
                                                  Icons.delete_forever_sharp,
                                                  color: Colors.red,
                                                ),
                                                onTap: () async {
                                                  deleteConfirmationDialog(
                                                      context, () {
                                                    Navigator.of(context).pop();
                                                    deleteItem(index);
                                                  },
                                                      () =>
                                                          Navigator.of(context)
                                                              .pop());
                                                  // await deleteItem(index);
                                                },
                                              ),
                                              ListTile(
                                                title: const Text("Edit"),
                                                trailing: const Icon(
                                                  Icons.edit,
                                                  color: Colors.green,
                                                ),
                                                onTap: () async {
                                                  // await deleteItem(index);
                                                  Add.id = list[index].id;
                                                  Add.title = list[index].title;
                                                  Add.description =
                                                      list[index].description;
                                                  Add.date = list[index].date;
                                                  Add.imgUrl.clear();
                                                  for (var img
                                                      in list[index].imgUrl) {
                                                    Add.imgUrl.add(img);
                                                  }
                                                  Add.pdfUrl.clear();
                                                  if (list[index].pdfPath !=
                                                      null) {
                                                    for (var pdf in list[index]
                                                            .pdfPath ??
                                                        []) {
                                                      Add.pdfUrl.add(pdf);
                                                    }
                                                  }
                                                  Navigator.pushNamed(context,
                                                      EditData.routeName,
                                                      arguments: list[index]);
                                                },
                                              ),
                                              const Spacer(),
                                              // FacebookBannerAd(
                                              //   placementId: Storage
                                              //       .facebookBannerPlacement,
                                              //   bannerSize: BannerSize.STANDARD,
                                              // ),
                                              // FacebookBannerAd(
                                              //   placementId: Storage
                                              //       .facebookBannerPlacement,
                                              //   bannerSize: BannerSize.STANDARD,
                                              // )
                                              // MaxAdView(
                                              //   adUnitId: Storage.banner,
                                              //   adFormat: AdFormat.banner,
                                              // ),
                                              // MaxAdView(
                                              //   adUnitId: Storage.banner,
                                              //   adFormat: AdFormat.banner,
                                              // ),
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
                    // const SizedBox(height: 50),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),

      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      // floatingActionButton:
      //     SpeedDial(child: const Icon(Icons.add), speedDialChildren: [
      //   SpeedDialChild(
      //     child: const Icon(Icons.add),
      //     foregroundColor: Colors.black,
      //     backgroundColor: Colors.yellow,
      //     label: 'Add files and images from device',
      //     onPressed: () {
      //       Add.imgUrl.clear();
      //       Add.pdfUrl.clear();
      //       Navigator.pushNamed(context, AddData.routeName, arguments: list);
      //     },
      // ),
      // SpeedDialChild(
      //   child: const Icon(Icons.document_scanner_outlined),
      //   foregroundColor: Colors.white,
      //   backgroundColor: MyColors.primary,
      //   label: 'Scan Images',
      //   onPressed: () {
      //     // Add.imgUrl.clear();
      //     // Add.pdfUrl.clear();
      //     // Navigator.pushNamed(context, AddData.routeName, arguments: list);
      //   },
      // ),
      // SpeedDialChild(
      //   child: const Icon(Icons.picture_as_pdf),
      //   foregroundColor: Colors.white,
      //   backgroundColor: Colors.teal,
      //   label: 'PDF Compressor',
      //   onPressed: () {
      //     // Add.imgUrl.clear();
      //     // Add.pdfUrl.clear();
      //     // Navigator.pushNamed(context, AddData.routeName, arguments: list);
      //   },
      // ),
      // ]),
      floatingActionButton: FloatingActionButton(
        highlightElevation: 40,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        // elevation: 20,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(15),
        //   side: BorderSide(color: Color.fromARGB(179, 238, 37, 37), width: 5),
        // ),
        child: Icon(
          Icons.add,
          color: MyColors.primary,
          size: mq.width * 0.08,
        ),
        onPressed: () {
          Add.imgUrl.clear();
          Add.pdfUrl.clear();
          Add.description = '';
          Add.title = '';
          Add.date = '';
          Add.id = '';
          Navigator.pushNamed(context, addDataWidget.AddData.routeName,
              arguments: list);
        },
      ),

      // bottomNavigationBar: FacebookBannerAd(
      //   placementId: Storage.facebookBannerPlacement,
      //   bannerSize: BannerSize.STANDARD,
      // ),
      // bottomNavigationBar: MaxAdView(
      //   adUnitId: Storage.banner,
      //   adFormat: AdFormat.banner,
      // ),
    );
  }

  Text headingText() {
    return const Text(
      'Manage Your document easy and safely at One Place',
      textAlign: TextAlign.center,
      overflow: TextOverflow.visible,
      style: TextStyle(color: Colors.white, fontSize: 15),
    );
  }

  InputDecoration searchFieldInputDecoration() {
    return const InputDecoration(
      border: InputBorder.none,
      prefixIcon: Icon(
        Icons.search,
        color: Colors.white,
      ),
      hintText: 'Search',
      hintStyle: TextStyle(color: Colors.white),
      // hintText: 'Search Docs',
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
