import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:camera/camera.dart';
// import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:passmanager/models/additem.dart';
import 'package:passmanager/screens/adddata.dart';
import 'package:passmanager/screens/edit_data.dart';
import 'package:passmanager/utils/colors.dart';
import 'package:path_provider/path_provider.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen(
      {super.key, required this.camera, required this.index});

  final CameraDescription camera;
  final int index;

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
        title: const Text(
          'Take a picture',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
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
                    toolbarColor: MyColors.primary,
                    // cropGridColor: MyColors.primary,
                    // cropFrameColor: MyColors.primary,
                    statusBarColor: MyColors.primary,
                    // dimmedLayerColor: MyColors.primary,
                    activeControlsWidgetColor: MyColors.primary,
                    toolbarWidgetColor: Colors.white,
                    initAspectRatio: CropAspectRatioPreset.original,
                    lockAspectRatio: false),
              ],
            );

            if (croppedFile != null) {
              final date = DateTime.now().toUtc().toIso8601String();

              final directory = await getExternalStorageDirectory();

              final File imageFile = File(croppedFile.path);
              imageFile.copy('${directory!.path}/$date.png');
              Add.imgUrl.add('${directory.path}/$date.png');

              widget.index == 0
                  ? Navigator.pushNamed(context, AddData.routeName)
                  : Navigator.pushNamed(context, EditData.routeName);
            }
          } catch (e) {
            // If an error occurs, log the error to the console.
          }
        },
        child: const Icon(
          Icons.camera_alt,
          color: Colors.white,
        ),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

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
                    Add.imgUrl.add('${directory!.path}/$date.png');
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
