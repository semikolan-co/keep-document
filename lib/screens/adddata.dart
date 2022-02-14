
import 'dart:ffi';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:image_picker/image_picker.dart';
import 'package:passmanager/constants/storage.dart';
import 'package:passmanager/models/additem.dart';
import 'package:passmanager/models/dataitem.dart';
import 'package:passmanager/screens/homepage.dart';
import 'package:passmanager/screens/sharedpref.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/colors.dart';
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
  final TextEditingController titleController =
      TextEditingController(text: Add.title);
  final TextEditingController descriptionController =
      TextEditingController(text: Add.description);
  final TextEditingController idController =
      TextEditingController(text: Add.id);
      final _formKey = GlobalKey<FormState>();
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

    addItem(String title, String desc, String id, String date) async {
      setState(() {
        final item = DataItem(
            title: title,
            description: desc,
            id: id,
            date: date,
            imgUrl: imgPath);
        list.add(item);
        // print("LISIST: $list");
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
              title: const Text(
                "Choose option",
                style: TextStyle(color: Colors.blue),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    const Divider(
                      height: 1,
                      color: Colors.blue,
                    ),
                    ListTile(
                      onTap: () {
                        _saveImages(ImageSource.gallery);
                        Navigator.of(context).pop();
                      },
                      title: const Text("Gallery"),
                      leading: const Icon(
                        Icons.account_box,
                        color: Colors.blue,
                      ),
                    ),
                    const Divider(
                      height: 1,
                      color: Colors.blue,
                    ),
                    ListTile(
                      onTap: () {
                        _toCamera();
                      },
                      title: const Text("Camera"),
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
    var mediaquery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Document Keeper',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: MyColors.primary,
        actions: [
          IconButton(
              onPressed: () => _showChoiceDialog(context),
              icon: const Icon(
                Icons.add_a_photo,
                color: Colors.white,
              )),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GlassmorphicContainer(
                      width: mediaquery.width * 0.8,
                      height: 80,
                      borderRadius: 10,
                      blur: 10,
                      border: 2,
                      linearGradient: linearGradiend(),
                      borderGradient: borderGradient1(),
                      child: Padding(
                        padding: padding(10),
                        child: TextFormField(
                          validator: (value) {
                            if (value != null) {
                              if (value.isEmpty) {
                                return 'Please enter a title';
                              } else {
                                bool isExist = false;
                                for (var element in list) {
                                  element.title == value ? isExist = true : null;
                                }
                                if (isExist) {
                                  return 'Title Already Exist';
                                }
                              }
                            } else {
                              return 'Please enter a title';
                            }
                            return null;
                          },
                          controller: titleController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Document Name',
                            labelStyle:  TextStyle(color: Colors.black),

                            // prefixIcon: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GlassmorphicContainer(
                      //  width: 350,
                      width: mediaquery.width * 0.8,
                      height: 100,
                      borderRadius: 10,
                      blur: 10,
                      // alignment: Alignment.,
                      border: 2,
                      linearGradient: linearGradiend(),
                      borderGradient: borderGradient1(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: TextFormField(
                          maxLines: 2,
                          controller: idController,
                          decoration: const InputDecoration(
                            labelText: 'Document ID',
                            labelStyle: TextStyle(color: Colors.black),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GlassmorphicContainer(
                    width: mediaquery.width * 0.8,
                    height: mediaquery.height * 0.2,
                    borderRadius: 10,
                    blur: 10,
                    // alignment: Alignment.,
                    border: 2,
                    linearGradient: linearGradiend(),
                    borderGradient: borderGradient1(),
                    child: Padding(
                      padding: padding(10),
                      child: TextFormField(
                        maxLines: 4,
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          // hintMaxLines: 5,
                          hintStyle: TextStyle(color: Colors.black),
                          hintText: 'Additional Note',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: mediaquery.height * 0.05),
                  ElevatedButton(
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(10),
                          backgroundColor:
                              MaterialStateProperty.all(MyColors.primary)),
                      onPressed: () {
                        // if(date=='') return;
                        if (_formKey.currentState!.validate()) {
                          Add.description = '';
                          Add.title = '';
                          Add.imgUrl = [];
                          Add.date = '';
                          Add.id = '';
                          addItem(
                              titleController.text,
                              descriptionController.text,
                              idController.text,
                              date);
                          Navigator.pushNamedAndRemoveUntil(
                              context, MyHomePage.routeName, (route) => false);
                          FacebookInterstitialAd.loadInterstitialAd(
                            placementId: "328150579086879_328163679085569",
                            listener: (result, value) {
                              if (result == InterstitialAdResult.LOADED) {
                                FacebookInterstitialAd.showInterstitialAd();
                              }
                            },
                          );
                        }
                      },
                      child: const Text('Save')),
                   SizedBox(
                    //  height: 500,
                    height: mediaquery.height * 0.3,
                     child: Expanded(
                       child: ImageGrid(
                         directory: _photoDir,
                         date: date,
                         imgPath: imgPath,
                                       ),
                     ),
                   ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: FacebookBannerAd(
        placementId: '328150579086879_328154279086509',
        bannerSize: BannerSize.STANDARD,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  LinearGradient borderGradient1() {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        const Color.fromRGBO(22, 68, 62, 1).withOpacity(1),
        const Color.fromRGBO(22, 68, 62, 1).withOpacity(0.2),
      ],
    );
  }

  EdgeInsets padding(double x) => EdgeInsets.symmetric(horizontal: x);
}

LinearGradient borderGradient() {
  return LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      const Color(0xFFffffff).withOpacity(0.5),
      const Color((0xFFFFFFFF)).withOpacity(0.5),
    ],
  );
}

LinearGradient linearGradiend() {
  return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        const Color(0xFFffffff).withOpacity(0.1),
        const Color(0xFFFFFFFF).withOpacity(0.05),
      ],
      stops: const [
        0.1,
        1,
      ]);
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
