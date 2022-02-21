import 'dart:io';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:passmanager/models/additem.dart';
import 'package:passmanager/models/dataitem.dart';
import 'package:passmanager/screens/homepage.dart';
import 'package:passmanager/widgets/deleteconfirmation.dart';
import 'package:path/path.dart';
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
    print(list.pdfPath.toString());
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          list.title,
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: MyColors.primary,
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
            Row(
              children: [
                const Spacer(
                  flex: 2,
                ),
                Text("ID : ${list.id}", style: const TextStyle(fontSize: 17)),
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
            // Row(
            //   children: [
            //     const Spacer(
            //       flex: 2,
            //     ),
            if (list.description != '')
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 23.0, vertical: 5),
                child: Text('Additional Note:', style: TextStyle(fontSize: 17)),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23),
              child: Text(list.description),
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
      bottomNavigationBar: FacebookBannerAd(
        placementId: '328150579086879_328154279086509',
        bannerSize: BannerSize.STANDARD,
      ), // This trailing comma makes auto-formatting nicer for build methods.
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: (){
                    deleteConfirmationDialog(context, deleteItem,(){});
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  )),
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
              ? GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list.imgUrl.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, childAspectRatio: 3.0 / 4.6),
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
                )
              : Container(),
          if (list.pdfPath != null)
            list.pdfPath == [] || list.pdfPath == [] || list.pdfPath!.isEmpty
                ? Container()
                : Row(children: [
                    Spacer(),
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
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onLongPress: () =>
                          Share.shareFiles([list.pdfPath?[index]]),
                      onTap: () => OpenFile.open(list.pdfPath?[index]),
                      child: Card(
                        child: ListTile(
                          title: Text(list.pdfPath?[index]
                                  .toString()
                                  .split('/')
                                  .last
                                  .toString() ??
                              ''),
                        ),
                      ),
                    );
                  },
                  itemCount: list.pdfPath?.length,
                )
              : Container(),
        ]),
      ),
    );
  }
}
