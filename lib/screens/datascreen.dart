import 'dart:io';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:passmanager/models/additem.dart';
import 'package:passmanager/models/dataitem.dart';
import 'package:passmanager/screens/homepage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'image_full_screen.dart';
import 'sharedpref.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text(list.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
    final DataItem list =
        ModalRoute.of(context)!.settings.arguments as DataItem;
    List imageList = list.imgUrl;
    // var imageList = directory
    //     .listSync()
    //     .map((item) => item.path)
    //     .where((item) => item.endsWith(".png"))
    //     .toList(growable: false);
    return Column(children: [
      Text(list.title),
      Text(list.description),
      Text(list.date),
      Row(
        children: [
          Text(list.id),
          IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: list.id.toString()));
                Fluttertoast.showToast(msg: 'Copied ${list.id.toString()}');
              },
              icon: const Icon(Icons.copy))
        ],
      ),
      IconButton(
          onPressed: () async {
            String? data = await SharedPref.read('data');
            print("SHARED DATA $data");
            if (data == null) {
              return;
            } else {
              List<DataItem> lst = DataItem.decode(data);
              print("Decoded lst $lst");
              // lst.remove(list);
              lst.removeWhere((item) => item.date == list.date);
              print("Decoded lst afer remove $lst");
               await SharedPref.save('data', DataItem.encode(lst));
               Navigator.pushNamedAndRemoveUntil(context, MyHomePage.routeName, (route) => false);
            }
          },
          icon: const Icon(Icons.delete)),
          Add.imgUrl.isNotEmpty?IconButton(onPressed: () async{
            await Share.shareFiles(Add.imgUrl,
                      text: '${list.title}\n${list.description}\n${list.id}\nShared via Data Manager',
                      subject: list.title);
          }, icon: const Icon(Icons.share)):Container(),
            Expanded(
        child: GridView.builder(
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
                            child: Image.file(File(imageList[index])
                            ));
                      },
                    ),
                  ),
                  child: SizedBox(
                    height: 50,
                    child: Image.file(
                      File(imageList[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      )
    ]);
  }
}
