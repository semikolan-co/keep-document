import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:passmanager/constants/storage.dart';
import 'package:passmanager/models/additem.dart';
import 'package:passmanager/models/dataitem.dart';
import 'package:passmanager/screens/homepage.dart';
import 'package:passmanager/screens/sharedpref.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'takepicture.dart';

class AddData extends StatefulWidget {
  const AddData({Key? key}) : super(key: key);
  static const routeName = '/adddata';

  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<AddData> {
  late final Directory _photoDir = Directory(
      '/storage/emulated/0/Android/data/com.semikolan.datamanager.passmanager/files/');
  final TextEditingController titleController = TextEditingController(text: Add.title);
  final TextEditingController descriptionController = TextEditingController(text: Add.description);
  final TextEditingController idController = TextEditingController(text: Add.id);
  // final LocalStorage storage = LocalStorage(Storage.storageName);
  String date = '';
  late final List<String> imgPath = Add.imgUrl;

  @override
  Widget build(BuildContext context) {
    // final List<DataItem> list =
    //     ModalRoute.of(context)!.settings.arguments as List<DataItem>;
    final List<DataItem> list = Add.dataList;

    void _toCamera() async {
      Add.description = descriptionController.text;
      Add.title = titleController.text;
      Add.id = idController.text;
      Add.imgUrl = imgPath;
      Add.dataList = list;
      final cameras = await availableCameras();
      final firstCamera = cameras.first;
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TakePictureScreen(
                camera: firstCamera,
              )));
    }

    _saveToStorage() async {
      // storage.setItem(Storage.keyName, list.toJSONEncodable());
      await SharedPref.save('data', DataItem.encode(list));
    }

    addItem(String title, String desc, String id, String date) {
      setState(() {
        final item = DataItem(
            title: title,
            description: desc,
            id: id,
            date: date,
            imgUrl: imgPath);
        list.add(item);
        print("LISIST: $list");
        _saveToStorage();
      });
    }

    _saveImages(ImageSource source) async {
      try {
        final pickedImage = await ImagePicker().pickImage(source: source);
        if (pickedImage == null) return null;
        date = DateTime.now().toUtc().toIso8601String();
        final directory = await getExternalStorageDirectory();
        print(directory!.path);
        setState(() {});
        imgPath.add(directory.path + '/$date.png');
        return File(pickedImage.path).copy('${directory.path}/$date.png');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
          ),
        );
      }
    }

    Future<void> _showChoiceDialog(BuildContext context) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Choose option",
                style: TextStyle(color: Colors.blue),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Divider(
                      height: 1,
                      color: Colors.blue,
                    ),
                    ListTile(
                      onTap: () {
                        _saveImages(ImageSource.gallery);
                        Navigator.of(context).pop();
                      },
                      title: Text("Gallery"),
                      leading: Icon(
                        Icons.account_box,
                        color: Colors.blue,
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.blue,
                    ),
                    ListTile(
                      onTap: () {
                        _toCamera();
                      },
                      title: Text("Camera"),
                      leading: const Icon(
                        Icons.camera,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    }

    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
              TextFormField(
                controller: idController,
                decoration: const InputDecoration(
                  labelText: 'ID',
                ),
              ),
              IconButton(
                  onPressed: () => _showChoiceDialog(context),
                  icon: const Icon(Icons.add_a_photo)),
              TextButton(
                  onPressed: () {
                    // if(date=='') return;
                    Add.description = '';
                    Add.title = '';
                    Add.imgUrl = [];
                    Add.date = '';
                    Add.id = '';
                    addItem(titleController.text, descriptionController.text,
                        idController.text, date);
                    Navigator.pushNamedAndRemoveUntil(
                        context, MyHomePage.routeName, (route) => false);
                  },
                  child: const Text('Submit')),
              Expanded(
                  child: ImageGrid(
                directory: _photoDir,
                date: date,
                imgPath: imgPath,
              )),
            ],
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

class ImageGrid extends StatelessWidget {
  final Directory directory;
  final String date;
  final List<String> imgPath;

  const ImageGrid(
      {required this.directory, required this.date, required this.imgPath});

  @override
  Widget build(BuildContext context) {
    // var imageList = directory
    //     .listSync()
    //     .map((item) => item.path)
    //     .where((item) => item.endsWith(".png"))
    //     .toList(growable: false);
    return GridView.builder(
      itemCount: imgPath.length,
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
              child: SizedBox(
                height: 50,
                child: Image.file(
                  File(imgPath[index]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
