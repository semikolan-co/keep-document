import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:camera/camera.dart';
// import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/material.dart';
import 'package:passmanager/models/additem.dart';
import 'package:passmanager/screens/adddata.dart';
import 'package:passmanager/utils/colors.dart';
import 'package:path_provider/path_provider.dart';

import '../utils/storage.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.veryHigh,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take a picture'),
        backgroundColor: MyColors.primary,
      ),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: CameraPreview(_controller));
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.primary,
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            final croppedFile = await ImageCropper().cropImage(
              sourcePath: image.path,
              compressFormat: ImageCompressFormat.jpg,
              compressQuality: 100,
              uiSettings: [
                AndroidUiSettings(
                    toolbarTitle: 'Cropper',
                    toolbarColor: Colors.deepOrange,
                    toolbarWidgetColor: Colors.white,
                    initAspectRatio: CropAspectRatioPreset.original,
                    lockAspectRatio: false),
                IOSUiSettings(
                  title: 'Cropper',
                ),
                WebUiSettings(
                  context: context,
                  presentStyle: CropperPresentStyle.dialog,
                  boundary: const CroppieBoundary(
                    width: 520,
                    height: 520,
                  ),
                  viewPort: const CroppieViewPort(
                      width: 480, height: 480, type: 'circle'),
                  enableExif: true,
                  enableZoom: true,
                  showZoomer: true,
                ),
              ],
            );

            if (croppedFile != null) {
              final date = DateTime.now().toUtc().toIso8601String();
              final directory = await getExternalStorageDirectory();
              print(directory!.path);
              Add.imgUrl.add(directory.path + '/$date.png');
              final File imageFile = File(croppedFile.path);
              imageFile.copy('${directory.path}/$date.png');
              Navigator.pushNamed(context, AddData.routeName);
            }
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Column(
        children: [
          Image.file(File(imagePath)),
          Row(
            children: [
              //material icon for right and wrong choice
              IconButton(
                  onPressed: () async {
                    final date = DateTime.now().toUtc().toIso8601String();
                    final directory = await getExternalStorageDirectory();
                    print(directory!.path);
                    Add.imgUrl.add(directory.path + '/$date.png');
                    File(imagePath).copy('${directory.path}/$date.png');
                    Navigator.pushNamed(context, AddData.routeName);
                  },
                  icon: const Icon(Icons.check)),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close)),
            ],
          )
        ],
      ),
      // bottomNavigationBar: MaxAdView(
      //   adUnitId: Storage.banner,
      //   adFormat: AdFormat.banner,
      // ),
    );
  }
}
