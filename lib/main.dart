import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

List<CameraDescription> cameras;

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
  }
}

void main() => runApp(MaterialApp(home:CameraWidget()));

class CameraWidget extends StatefulWidget {
  @override
  CameraState createState() => CameraState();
}

class CameraState extends State<CameraWidget> {
  List<CameraDescription> cameras;
  CameraController controller;
  String _filePath;
  bool isReady = false;

  @override
  void initState() {
    super.initState();
    setupCameras();
  }

  Future<void> setupCameras() async {
    try {
      cameras = await availableCameras();
      controller = new CameraController(cameras[0], ResolutionPreset.ultraHigh);
      await controller.initialize();
    } on CameraException catch (_) {
      setState(() {
        isReady = false;
      });
    }
    setState(() {
      isReady = true;
    });
  }

  Future<void> takePhoto(BuildContext context) async {

    if (!controller.value.isInitialized) {
      return null;
    }
    final Directory extDir = await getExternalStorageDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_camera';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${DateTime.now()}.jpg';

    if (controller.value.isTakingPicture) {
      return null;
    }

    try {
      await controller.takePicture(filePath);
      setState(() {
        _filePath = filePath;
        _showBottomSheet(context);
      });
    } on CameraException catch (e) {
      print(e);
    }
  }

  void _showBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Center(
              child: LimitedBox(
                child:
                Image.file(File(_filePath)),
                maxHeight: 300,
              ));
        });
  }

    Widget build(BuildContext context) {
      SizeConfig().init(context);
      if (!isReady && !controller.value.isInitialized) {
        return Container();
      }
      try {
        return Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: CameraPreview(controller)),
              ),
              Container(
                  child: FloatingActionButton(
                      backgroundColor: Colors.red,
                      onPressed: (){takePhoto(context);}
                  ),
                  padding: EdgeInsets.fromLTRB(
                      0, SizeConfig.blockSizeVertical * 19, 0, 0),
                  color: Colors.black
              )
            ]
        );
      } catch (e) {
        return Column(
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Container(
                      color: Colors.black)
              ),
              Container(
                  padding: EdgeInsets.fromLTRB (0, SizeConfig.blockSizeVertical * 20, 0, 0),
                  color: Colors.black,
              )
            ]
        );
      }
    }
  }

