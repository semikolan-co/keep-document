import 'dart:io';
// import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:passmanager/models/additem.dart';
import 'package:passmanager/models/dataitem.dart';
import 'package:passmanager/screens/homepage.dart';
import 'package:passmanager/utils/storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../utils/colors.dart';
import 'image_full_screen.dart';
import '../models/sharedpref.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({Key? key}) : super(key: key);
  static const routeName = '/datascreen';

  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  late final Directory _photoDir = Directory(
      '/storage/emulated/0/Android/data/com.semikolan.datamanager.passmanager/files/');
  final TextEditingController inputController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final DataItem list =
        ModalRoute.of(context)!.settings.arguments as DataItem;
    // print(list.pdfPath.toString());
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          title: Text(
            list.title,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
          backgroundColor: MyColors.primary,
          iconTheme: IconThemeData(color: Colors.white)
          // actions: [
          //   IconButton(
          //       onPressed: () {

          //       },
          //       icon: const Icon(
          //         Icons.edit,
          //         color: Colors.white,
          //       )),
          // ],
          ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: Storage.paddingSize),
              child: Row(
                children: [
                  Text("ID : ${list.id}", style: const TextStyle(fontSize: 20)),
                  const Spacer(
                    flex: 17,
                  ),
                  IconButton(
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: list.id.toString()));
                        Fluttertoast.showToast(
                            msg: 'Copied ${list.id.toString()}');
                      },
                      icon: const Icon(Icons.copy)),
                  const Spacer(
                    flex: 1,
                  ),
                ],
              ),
            ),
            // Row(
            //   children: [
            //     const Spacer(
            //       flex: 2,
            //     ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: Storage.paddingSize),
              child: Text(list.description, style: TextStyle(fontSize: 16)),
            ),
            //     const Spacer(
            //       flex: 1,
            //     ),
            //   ],
            // ),
            Expanded(child: ImageGrid(directory: _photoDir)),
          ],
        ),
      ),
      // bottomNavigationBar: MaxAdView(
      //   adUnitId: Storage.banner,
      //   adFormat: AdFormat.banner,
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ImageGrid extends StatelessWidget {
  final Directory directory;

  const ImageGrid({required this.directory});

  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context).size;
    final DataItem list =
        ModalRoute.of(context)!.settings.arguments as DataItem;

    void deleteItem() async {
      String? data = await SharedPref.read('data');
      print("SHARED DATA $data");
      if (data == null) {
        return;
      } else {
        List<DataItem> lst = DataItem.decode(data);
        // print("Decoded lst $lst");
        // lst.remove(list);
        lst.removeWhere((item) => item.title == list.title);
        // print("Decoded lst afer remove $lst");
        await SharedPref.save('data', DataItem.encode(lst));
        Navigator.pushNamedAndRemoveUntil(
            context, MyHomePage.routeName, (route) => false);
      }
    }

    List imageList = list.imgUrl;
    // var imageList = directory
    //     .listSync()
    //     .map((item) => item.path)
    //     .where((item) => item.endsWith(".png"))
    //     .toList(growable: false);
    return SingleChildScrollView(
      // child: Padding(
      // padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Add.imgUrl.isNotEmpty
                ? const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Storage.paddingSize),
                    child: Text(
                      "Images: ",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  )
                : Container(),
            const Spacer(),
            // IconButton(
            //     onPressed: () {
            //       deleteConfirmationDialog(context, deleteItem, () {});
            //     },
            //     icon: const Icon(
            //       Icons.delete,
            //       color: Colors.red,
            //     r)),
            Add.imgUrl.isNotEmpty
                ? IconButton(
                    onPressed: () async {
                      await Share.shareFiles(Add.imgUrl,
                          text:
                              '${list.title}\n${list.description}\n${list.id}\nShared via Keep Document\nhttps://play.google.com/store/apps/details?id=com.semikolan.datamanager.passmanager',
                          subject: list.title);
                    },
                    icon: const Icon(
                      Icons.share,
                    ))
                : Container(),
          ],
        ),
        list.imgUrl.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Storage.paddingSize / 2),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list.imgUrl.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 3.0 / 3.5),
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: InkWell(
                          onTap: () => Navigator.push(
                            context,
                            PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (BuildContext context, _, __) {
                                return FullScreenPage(
                                    dark: true,
                                    path: imageList[index],
                                    child: Image.file(File(imageList[index])));
                              },
                            ),
                          ),
                          child: Center(
                            child: SizedBox(
                              // height: 50,
                              width: mediaquery.width * 0.8,
                              height: mediaquery.height * 0.5,
                              child: Image.file(
                                File(imageList[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            : Container(),
        if (list.pdfPath != null)
          list.pdfPath == [] || list.pdfPath == [] || list.pdfPath!.isEmpty
              ? Container()
              : Row(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Storage.paddingSize),
                    child: Text(
                      list.pdfPath!.length > 1 ? 'Documents:' : 'Document:',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () async {
                      print(Add.pdfUrl);
                      await Share.shareFiles(Add.pdfUrl,
                          text:
                              '${list.title}\n${list.description}\n${list.id}\nShared via Keep Document\nhttps://play.google.com/store/apps/details?id=com.semikolan.datamanager.passmanager',
                          subject: list.title);
                    },
                    icon: const Icon(Icons.share),
                  ),
                ]),
        list.pdfPath != null
            ? ListView.builder(
                padding: const EdgeInsets.symmetric(
                    horizontal: Storage.paddingSize / 2),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: list.pdfPath?.length,
                itemBuilder: (context, index) => InkWell(
                      onLongPress: () =>
                          Share.shareFiles([list.pdfPath?[index]]),
                      onTap: () => OpenFile.open(list.pdfPath?[index]),
                      child: Card(
                        child: Container(
                            height: 50,
                            child: ListTile(
                                leading: Icon(
                                  Icons.picture_as_pdf,
                                  color: Colors.red,
                                ),
                                title: Text(
                                  list.pdfPath?[index].split('/').last,
                                  overflow: TextOverflow.ellipsis,
                                ))),
                        // subtitle:  tex,
                      ),
                    ))
            // ? GridView.builder(
            //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //       crossAxisCount: 2,
            //       // childAspectRatio: 3 / 2,
            //       crossAxisSpacing: 10,
            //       mainAxisSpacing: 10,
            //     ),
            //     physics: const NeverScrollableScrollPhysics(),
            //     shrinkWrap: true,
            //     itemBuilder: (context, index) {
            //       return InkWell(
            //         onLongPress: () =>
            //             Share.shareFiles([list.pdfPath?[index]]),
            //         onTap: () => OpenFile.open(list.pdfPath?[index]),
            //         child: 1 == 1
            //             ? Card(
            //                 elevation: 5,
            //                 child: Column(
            //                   children: [
            //                     const Icon(
            //                       Icons.picture_as_pdf_rounded,
            //                       size: 100,
            //                       color: Colors.red,
            //                     ),
            //                     // const Expanded(
            //                     //   child: SizedBox(),
            //                     // ),
            //                     Padding(
            //                       padding: const EdgeInsets.all(8.0),
            //                       child: Text(
            //                         list.pdfPath?[index]
            //                                 .toString()
            //                                 .split('/')
            //                                 .last
            //                                 .toString() ??
            //                             '',
            //                         overflow: TextOverflow.ellipsis,
            //                         style: const TextStyle(),
            //                       ),
            //                     ),
            //                     //  SizedBox(height: mediaquery.height * 0.),
            //                     // ListTile(
            //                     //   title: Text(),
            //                     //   // subtitle:  tex,
            //                     // ),
            //                   ],
            //                 ),
            //               )
            : Container(),
      ]),
    );
    // );
  }
}
