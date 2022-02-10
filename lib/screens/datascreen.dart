import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:passmanager/models/dataitem.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'imageFullScreen.dart';

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

  _saveImages() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.camera);
    if (pickedImage == null) return null;

    try {
      final directory = await getExternalStorageDirectory();
      print(directory!.path);
      setState(() {});
      if (directory != null) {
        return File(pickedImage.path).copy(
            '${directory.path}/${DateTime.now().toUtc().toIso8601String()}.png');
      }
      ;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child: ImageGrid(directory: _photoDir)),
          ],
        ),
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
    var imageList = list.imgUrl;
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
              icon: const Icon(Icons.copy)),
        ],
      ),
      Expanded(
        child: GridView.builder(
          itemCount: list.imgUrl.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                            child: Image.file(File(imageList[index])));
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
