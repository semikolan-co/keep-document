import 'dart:io';

import 'package:camera/camera.dart';
// import 'package:applovin_max/applovin_max.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:passmanager/utils/ads.dart';
import 'package:passmanager/models/additem.dart';
import 'package:passmanager/models/dataitem.dart';
import 'package:passmanager/screens/homepage.dart';
import 'package:passmanager/models/sharedpref.dart';
import 'package:passmanager/widgets/primary_button.dart';
import 'package:passmanager/widgets/snack_bar.dart';
import 'package:path_provider/path_provider.dart';

import '../utils/colors.dart';
import 'takepicture.dart';

class AddData extends StatefulWidget {
  const AddData({super.key});
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
  late final List<String> pdfPath = Add.pdfUrl;

  @override
  Widget build(BuildContext context) {
    // final List<DataItem> list =
    //     ModalRoute.of(context)!.settings.arguments as List<DataItem>;
    final List<DataItem> list = Add.dataList;

    void toCamera() async {
      Add.description = descriptionController.text;
      Add.title = titleController.text;
      Add.id = idController.text;
      Add.imgUrl = imgPath;
      Add.pdfUrl = pdfPath;
      Add.dataList = list;
      await availableCameras().then((value) {
        final firstCamera = value.first;
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TakePictureScreen(
                  camera: firstCamera,
                  index: 0,
                )));
      });
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
            imgUrl: imgPath,
            pdfPath: pdfPath);
        list.insert(0, item);
        // print("LISIST: $list");
        _saveToStorage();
      });
    }

    pickFile() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowCompression: true,
          allowedExtensions: ['pdf']);

      if (result != null) {
        try {
          File file = File(result.files.single.path.toString());
          date = DateTime.now().toUtc().toIso8601String();
          final directory = await getExternalStorageDirectory();
          pdfPath.add('${directory!.path}/${result.files.single.name}');
          setState(() {});
          return File(file.path)
              .copy('${directory.path}/${result.files.single.name.toString()}');
          //       print(directory!.path);
          // setState(() {});
          //       final filePath = join(directory.path, '${date}.pdf');
          // String? outputFile = await FilePicker.platform
          //     .saveFile(fileName: '${date}.pdf', allowedExtensions: ['pdf']);
        } catch (e) {
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //   content: Text('Error: $e'),
          // ));
          showSnackBar(context, Colors.red, 'Error: $e');
        }
      } else {
        // User canceled the picker
        return null;
      }
    }

    _saveImages(ImageSource source) async {
      try {
        final pickedImage = await ImagePicker().pickImage(source: source);
        if (pickedImage == null) return null;
        date = DateTime.now().toUtc().toIso8601String();
        final directory = await getExternalStorageDirectory();
        // print(directory!.path);
        setState(() {});
        imgPath.add('${directory!.path}/$date.png');
        return File(pickedImage.path).copy('${directory.path}/$date.png');
      } catch (e) {
        showSnackBar(context, Colors.red, 'Error: $e');
      }
    }

    Future<void> _showChoiceDialog(BuildContext context) {
      return showModalBottomSheet(
          context: context,
          // circular shape
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          builder: (context) {
            return SafeArea(
              child: SizedBox(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Choose Image Source',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          // leading: const Icon(Icons.photo_camera),
                          // title: const Text('Camera'),
                          onTap: () async {
                            toCamera();
                          },
                          child: const Column(
                            children: [
                              Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.camera,
                                    color: MyColors.primary,
                                    size: 50,
                                  )),
                              Text(
                                'Camera',
                                style: TextStyle(),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          // leading: const Icon(Icons.photo_camera),
                          // title: const Text('Camera'),
                          onTap: () async {
                            _saveImages(ImageSource.gallery);
                            Navigator.of(context).pop();
                          },
                          child: const Column(
                            children: [
                              Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Icon(
                                    Icons.image,
                                    color: MyColors.primary,
                                    size: 50,
                                  )),
                              Text(
                                'Gallery',
                                style: TextStyle(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
    }

    final mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Add Document',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: MyColors.primary,
        actions: [
          IconButton(
              onPressed: () => _showChoiceDialog(context),
              icon: const Icon(
                Icons.add_a_photo,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () => pickFile(),
              icon: const Icon(
                Icons.file_present,
                color: Colors.white,
              )),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: mq.width * 0.9,
                            // height: 80,
                            // borderRadius: 10,
                            // blur: 10,
                            // border: 2,
                            // linearGradient: linearGradiend(),
                            // borderGradient: borderGradient1(),
                            child: Padding(
                              padding: padding(10),
                              child: TextFormField(
                                validator: (value) {
                                  if (value != null) {
                                    if (value.isEmpty) {
                                      return 'Please enter Document Name';
                                    } else {
                                      bool isExist = false;
                                      for (var element in list) {
                                        element.title == value
                                            ? isExist = true
                                            : null;
                                      }
                                      if (isExist) {
                                        return 'A Document which this name already Exists!';
                                      }
                                    }
                                  } else {
                                    return 'Please enter a title';
                                  }
                                  return null;
                                },
                                controller: titleController,
                                style: const TextStyle(fontSize: 18),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Document Name',
                                  labelStyle: TextStyle(
                                      color: MyColors.textColor, fontSize: 18),

                                  // prefixIcon: const Icon(Icons.arrow_forward_ios),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            //  width: 350,
                            width: mq.width * 0.9,
                            // height: 100,
                            // borderRadius: 10,
                            // blur: 10,
                            // // alignment: Alignment.,
                            // border: 2,
                            // linearGradient: linearGradiend(),
                            // borderGradient: borderGradient1(),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextFormField(
                                style: const TextStyle(fontSize: 17),
                                // maxLines: 2,
                                controller: idController,
                                decoration: const InputDecoration(
                                  labelText: 'Document ID',
                                  labelStyle: TextStyle(
                                      color: MyColors.textColor, fontSize: 17),
                                  border: InputBorder.none,
                                  focusColor: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: mq.width * 0.9,
                          // height: mq.height * 0.15,
                          // borderRadius: 10,
                          // blur: 10,
                          // // alignment: Alignment.,
                          // border: 2,
                          // linearGradient: linearGradiend(),
                          // borderGradient: borderGradient1(),
                          child: Padding(
                            padding: padding(10),
                            child: TextFormField(
                              style: const TextStyle(fontSize: 16),
                              minLines: 1,
                              maxLines: 100,
                              controller: descriptionController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                // hintMaxLines: 5,
                                hintStyle: TextStyle(
                                    color: MyColors.textColor, fontSize: 16),
                                hintText: 'Additional Note',
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(height: mq.height * 0.05),
                        // ElevatedButton(
                        //     style: ButtonStyle(
                        //         elevation: MaterialStateProperty.all(10),
                        //         backgroundColor:
                        //             MaterialStateProperty.all(MyColors.primary)),
                        //     onPressed: () {
                        //     },
                        //     child: const Text('Save',
                        //         style: TextStyle(
                        //           fontSize: 20,
                        //         ))),
                        // const SizedBox(height: 30),
                        imgPath.isEmpty
                            ? Container()
                            : ImageGrid(
                                directory: _photoDir,
                                date: date,
                                imgPath: imgPath,
                              ),
                        const SizedBox(height: 20),
                        pdfPath.isEmpty
                            ? Container()
                            : FileList(
                                directory: _photoDir,
                                date: date,
                                pdfPath: pdfPath,
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: PrimaryButton(
                  onPressed: () {
                    // if(date=='') return;
                    if (_formKey.currentState!.validate()) {
                      Add.description = '';
                      Add.title = '';
                      Add.imgUrl = [];
                      Add.date = '';
                      Add.id = '';
                      addItem(titleController.text, descriptionController.text,
                          idController.text, date);
                      Navigator.pushNamedAndRemoveUntil(
                          context, MyHomePage.routeName, (route) => false);
                      // FacebookInterstitialAd.loadInterstitialAd(
                      //   placementId: "328150579086879_328163679085569",
                      //   listener: (result, value) {
                      //     if (result == InterstitialAdResult.LOADED) {
                      //       FacebookInterstitialAd.showInterstitialAd();
                      //     }
                      //   },
                      // );
                      loadInterstitial();
                    }
                  },
                  buttonText: "Save"),
            ),
          ),
        ],
      ),
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
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: imgPath.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 3.0 / 3.5),
      itemBuilder: (context, index) {
        return Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: InkWell(
              child: SizedBox(
                height: 50,
                width: 50,
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

class FileList extends StatelessWidget {
  final Directory directory;
  final String date;
  final List<String> pdfPath;

  const FileList(
      {required this.directory, required this.date, required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: pdfPath.length,
      itemBuilder: (context, index) => Card(
        child: Container(
            height: 50,
            child: ListTile(
                leading: const Icon(
                  Icons.picture_as_pdf,
                  color: Colors.red,
                ),
                title: Text(
                  pdfPath[index].split('/').last,
                  overflow: TextOverflow.ellipsis,
                ))),
        // subtitle:  tex,
      ),
      // physics: const NeverScrollableScrollPhysics(),
      // shrinkWrap: true,
      // itemCount: pdfPath.length,
      // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //   crossAxisCount: 2,
      //   // childAspectRatio: 3 / 2,
      //   crossAxisSpacing: 10,
      //   mainAxisSpacing: 10,
      // ),
      // itemBuilder: (context, index) => Card(
      //       elevation: 5,
      //       child: Column(
      //         children: [
      //           const Icon(
      //             Icons.picture_as_pdf_rounded,
      //             size: 100,
      //             color: Colors.red,
      //           ),
      //           const Expanded(
      //             child: SizedBox(),
      //           ),
      //           Padding(
      //             padding: const EdgeInsets.all(8.0),
      //             child: Text(
      //               pdfPath[index].toString().split('/').last,
      //               overflow: TextOverflow.ellipsis,
      //               style: const TextStyle(),
      //             ),
      //           ),
      //  SizedBox(height: mediaquery.height * 0.),
      // ListTile(
      //   title: Text(),
      //   // subtitle:  tex,
      // ),
      // ],
    );
  }
}
