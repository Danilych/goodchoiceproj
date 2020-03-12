//import 'package:camera/new/camera.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Camero demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<CameraDescription> _cameras;
  CameraDescription _activeCamera;
  int _counter = 0;
  CameraController _controller;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  @override
  void initState(){
    super.initState();
    _getCameras();
  }
  Future<void> _getCameras() async{
    final cameras = await availableCameras();
    setState(() {
      _cameras = cameras;
      _activeCamera = cameras[1];
    });
  }

  void _setCameraController(CameraDescription cameraDescription) async {
    _controller = CameraController(cameraDescription, ResolutionPreset.high);

    await _controller.initialize();

    if (mounted){
      setState(() {});
    }
  }

Widget _cameraView(){
    _setCameraController(_activeCamera);
  return new Container(
    child: new Row(
      children:[
        new Expanded(child: new Column(
          children:<Widget>[
            new AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: new CameraPreview(_controller),
            )
          ]
        ))
      ]
    )
  );
}

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(child:_cameraView()),
    );
  }
}
