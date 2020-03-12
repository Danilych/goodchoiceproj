//import 'dart:html';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import "api.dart" as api;
import 'dart:convert';


class Main extends StatefulWidget {
    Main({Key key, this.authData}) : super(key: key);

    final Map authData;

    _MainState createState() => _MainState();
}


class _MainState extends State<Main> {
    @override
    Widget build(BuildContext context) {
        Widget home;
        Object changer = () {setState(() {});};
        home = (widget.authData.length > 0) ? Homepage(
            changer: changer
        ) : AuthScreen(
            auth: widget.authData, changer: changer
        );
        return MaterialApp(
            title: "QTask",
            theme: ThemeData(
                accentColor: Colors.indigo,
                primaryColor: Colors.indigo,
                backgroundColor: Colors.white,
                canvasColor: Colors.grey,
                textTheme: TextTheme(
                    body1: TextStyle(color: Colors.blue),
                    button: TextStyle(color: Colors.white),
                )
            ),
            home: home,
        );
    }
}


class AuthScreen extends StatefulWidget {
    AuthScreen({Key key, this.auth, this.changer}) : super(key: key);

    final Map auth;
    final Function changer;

    _AuthState createState() => _AuthState();
}


class _AuthState extends State<AuthScreen> {
    bool waiting = false;
    bool codeSent = false;
    String code;
    BuildContext scaffoldContext;
    List<TextEditingController> controllers = [
        TextEditingController(),
        TextEditingController(),
    ];

    @override
    Widget build(BuildContext context) {
        return Container(
            decoration: BoxDecoration(
                gradient: appgrad(),
            ),
            child: (waiting) ? Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                    child: CircularProgressIndicator(
                    ),
                ),
            ) : Scaffold(
                backgroundColor: Colors.transparent,
                body: new Builder(builder: (BuildContext context) {
                    scaffoldContext = context;
                    return body(scaffoldContext);
                }),
            )
        );
    }
    Widget body(BuildContext context) {
        return Center (
            child: Padding (
                padding: EdgeInsets.all(25),
                child: Column (
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget> [
                        Icon(
                            Icons.all_inclusive,
                            size: 120,
                            color: Colors.white,
                        ),
                        Field.field(
                            placeholder: (codeSent) ? "Код из СМС" : "Номер телефона",
                            controller: controllers[codeSent ? 1 : 0]
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: (!codeSent) ? <Widget>[
                                FlatButton(
                                    child: Text("Войти", style: TextStyle(color: Colors.blue)),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(18.0),
                                    ),
                                    onPressed: () {
                                        api.sendCode(controllers[0].text).then((dynamic value) {
                                            setState(() {
                                                print(value.body);
                                                code = value.body;
                                                codeSent = true;
                                                widget.changer();
                                            });
                                        });
                                    },
                                    color: Colors.white,
                                )
                            ] : <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(right: 20),
                                    child: FlatButton(
                                        child: Text("Назад", style: TextStyle(color: Colors.blue)),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: new BorderRadius.circular(18.0),
                                        ),
                                        onPressed: () {
                                            setState(() {
                                                codeSent = false;
                                                widget.changer();
                                            });
                                        },
                                        color: Colors.white,
                                    ),
                                ),
                                FlatButton(
                                    child: Text("Подтвердить $code", style: TextStyle(color: Colors.blue)),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(18.0),
                                    ),
                                    onPressed: () {
                                        setState(() {
                                            if (controllers[1].text == code) {
                                                widget.auth.putIfAbsent("phone", () => controllers[0].text);
                                            }
                                            widget.changer();
                                        });
                                    },
                                    color: Colors.white,
                                )
                            ],
                        )
                    ],
                ),
            ),
        );
    }
}


class Homepage extends StatefulWidget {
    Homepage({Key key, this.changer}) : super(key: key);

    final Function changer;

    @override
    _HomeState createState() => _HomeState();
}


class _HomeState extends State<Homepage> {
    bool isChanged = false;
    int value = 1;
    int page = 1;
    bool drivin = false;
    String title = "Gotta go fast";

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: Colors.grey[50],
            body: body(),
            appBar: appBar(widget, this),
            floatingActionButton: Container(
                width: 60,
                height: 60,
                child: new RawMaterialButton(
                    shape: new CircleBorder(),
                    elevation: 0.0,
                    fillColor: Colors.indigo,
                    child: Icon(
                        Icons.create,
                        size: 35,
                        color: Colors.white,
                    ),
                    onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CreateScreen()),
                        );
                    },
                ),
            ),
            bottomNavigationBar: BottomAppBar(
                shape: CircularNotchedRectangle(),
                child: Row(
                    children: <Widget>[
                        IconButton(icon: Icon(Icons.palette), onPressed: () {},),
                        IconButton(icon: Icon(Icons.settings), onPressed: () {},),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                ),
                notchMargin: 6.0,
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        );
    }
    Widget body() {
        return Center(
            child: Padding(
                padding: EdgeInsets.all(0),
                child: ListView(
                    children: requests(),
                ),
            ),
        );
    }
    List<Card> requests() {
        List<Card> req = [];
        Color color = [Colors.indigo, Colors.red][drivin? 1 : 0];
        for (int i = 0; i < 10; i++) {
            req.add(
                Card(
                    child: InkWell(
                        splashColor: color.withAlpha(30),
                        highlightColor: color.withAlpha(10),
                        onTap: () {
                            setState(() {
                                drivin = !drivin;
                                widget.changer();
                            });
                        },
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 2, 0),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                    ListTile(
                                        leading: Icon(
                                            drivin ? Icons.accessible_forward : Icons.accessible,
                                            color: color,
                                            size: 50
                                        ),
                                        title: Text(drivin ? 'ПОГНАЛИ НА ГОНКУ' : 'НУ ЧЕ НАРОД'),
                                        subtitle: Text('Текст обращения. Текст текст'),
                                    ),
                                ],
                            ),
                        )
                    ),
                ),
            );
        }
        return req;
    }
}


AppBar appBar(widget, t) {
    return AppBar(
        title: Text(
            t.title,
            style: TextStyle(
                color: Colors.white,
            ),
        ),
        backgroundColor: Colors.indigo[400],
        bottom: PreferredSize(
            child: Container(
                height: 2,
                color: Colors.indigo[500],
            )
        ),
        actions: <Widget>[],
    );
}


class Field {
    static Widget field({Function onChanged, String placeholder , String defaultText = "", TextEditingController controller, Color color = Colors.white}) {
        if (controller == null) {
            controller = TextEditingController(
                text: defaultText
            );
        }
        return Padding(
            padding: EdgeInsets.all(5),
            child: TextField(
                controller: controller,
                cursorColor: color,
                style: TextStyle(color: color),
                maxLines: null,
                decoration: new InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    focusColor: color,
                    hintText: placeholder,
                    hintStyle: TextStyle(color: color.withAlpha(200)),
                    border: InputBorder.none,
                    focusedBorder: UnderlineInputBorder(
                        borderSide: new BorderSide(
                            color: color,
                        )
                    )
                ),
                onChanged: onChanged,
            )
        );
    }
}


LinearGradient appgrad() {
    return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.2, 0.8],
        colors: [
            Colors.blue[400],
            Colors.indigo[400],
        ],
    );
}


class CreateScreen extends StatefulWidget {
    CreateScreen({Key key}) : super(key: key);
    _CSState createState() => _CSState();
}


class _CSState extends State<CreateScreen> {
    bool isChanged = false;
    int value = 1;
    int page = 1;
    bool drivin = false;
    String title = "Gotta go fast";
    File _image1;
    File _image2;
    File _image3;
    File _image4;
    File _image5;

    Future getImageGal1() async {
        var image = await ImagePicker.pickImage(source: ImageSource.gallery);

        setState(() {
            _image1 = image;
        });
    }

    Future getImageCam1() async {
        var image = await ImagePicker.pickImage(source: ImageSource.camera);

        setState(() {
            _image1 = image;
        });
    }

    Future getImageGal2() async {
        var image = await ImagePicker.pickImage(source: ImageSource.gallery);

        setState(() {
            _image2 = image;
        });
    }

    Future getImageCam2() async {
        var image = await ImagePicker.pickImage(source: ImageSource.camera);

        setState(() {
            _image2 = image;
        });
    }

    Future getImageGal3() async {
        var image = await ImagePicker.pickImage(source: ImageSource.gallery);

        setState(() {
            _image3 = image;
        });
    }

    Future getImageCam3() async {
        var image = await ImagePicker.pickImage(source: ImageSource.camera);

        setState(() {
            _image3 = image;
        });
    }

    Future getImageGal4() async {
        var image = await ImagePicker.pickImage(source: ImageSource.gallery);

        setState(() {
            _image4 = image;
        });
    }

    Future getImageCam4() async {
        var image = await ImagePicker.pickImage(source: ImageSource.camera);

        setState(() {
            _image4 = image;
        });
    }

    Future getImageGal5() async {
        var image = await ImagePicker.pickImage(source: ImageSource.gallery);

        setState(() {
            _image5 = image;
        });
    }

    Future getImageCam5() async {
        var image = await ImagePicker.pickImage(source: ImageSource.camera);

        setState(() {
            _image5 = image;
        });
    }

    void _showBottomSheet(context, int i) {
        showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (BuildContext bc) {
                return Container(
                    height: 100,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(25),
                            topRight: const Radius.circular(25),
                        ),
                    ),
                    child:Column(
                    children: <Widget>[
                        FlatButton(
                            child: Text("Галлерея", style: TextStyle(color: Colors.blue)),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                            ),
                            onPressed: () {
                                if(i==1)getImageGal1();
                                    else if (i==2) getImageGal2();
                                        else if (i==3) getImageGal3();
                                             else if (i==4) getImageGal4();
                                                 else if (i==5) getImageGal5();
                            },
                            color: Colors.white,
                        ),
                        FlatButton(
                            child: Text("Камера", style: TextStyle(color: Colors.blue)),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                            ),
                            onPressed: () {
                                if(i==1)getImageCam1();
                                else if (i==2) getImageCam2();
                                else if (i==3) getImageCam3();
                                else if (i==4) getImageCam4();
                                else if (i==5) getImageCam5();
                            },
                            color: Colors.white,
                        )
                    ],
                ));
            });
    }

    @override
    Widget build(BuildContext context) {
        return Container(
            decoration: BoxDecoration(
                gradient: appgrad(),
            ),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                floatingActionButton: FloatingActionButton(
                    backgroundColor: Colors.indigo,
                    onPressed: () {},
                    child: Icon(Icons.accessible_forward)
                ),
                appBar: AppBar(
                    title: Text('Заполнить обращение'),
                    backgroundColor: Colors.black.withAlpha(60),
                ),
                body: Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                        ),
                      child: Column(
                          children: <Widget>[
                          Field.field(
                               placeholder: "Чево случилось",
                               color: Colors.indigo,
                            ),
                              Container(
                                  margin: EdgeInsets.symmetric(vertical: 20),
                                  height:300,
                                  child:ListView(
                                      scrollDirection: Axis.horizontal,
                                      children:<Widget>[
                                          GestureDetector(
                                              onTap: (){_showBottomSheet(context,1);},
                                              child: Container(
                                                  width: 300,
                                                  height:300,
                                                  color: _image1==null?Colors.red:Colors.red.withOpacity(0),
                                                  child: _image1==null?Icon(Icons.add_box):Image.file(_image1),
                                              ),
                                          ),
                                          GestureDetector(
                                              onTap: (){_showBottomSheet(context,2);},
                                              child: Container(
                                                  width: 300,
                                                  height:300,
                                                  color: _image2==null?Colors.green:Colors.green.withOpacity(0),
                                                  child: _image2==null?Icon(Icons.add_box):Image.file(_image2),
                                              ),
                                          ),
                                          GestureDetector(
                                              onTap: (){_showBottomSheet(context,3);},
                                              child: Container(
                                                  width: 300,
                                                  height:300,
                                                  color: _image3==null?Colors.blue:Colors.blue.withOpacity(0),
                                                  child: _image3==null?Icon(Icons.add_box):Image.file(_image3),
                                              ),
                                          ),
                                          GestureDetector(
                                              onTap: (){_showBottomSheet(context,4);},
                                              child: Container(
                                                  width: 300,
                                                  height:300,
                                                  color: _image4==null?Colors.black:Colors.black.withOpacity(0),
                                                  child: _image4==null?Icon(Icons.add_box):Image.file(_image4),
                                              ),
                                          ),
                                          GestureDetector(
                                              onTap: (){_showBottomSheet(context,5);},
                                              child: Container(
                                                  width: 300,
                                                  height:300,
                                                  color: _image5==null?Colors.yellow:Colors.yellow.withOpacity(0),
                                                  child: _image5==null?Icon(Icons.add_box):Image.file(_image5),
                                              ),
                                          ),
                                      ]
                                  )
                              )
                          ],
                      )
                      //  child: ListView(
                          //  children: <Widget> [
                              //  Field.field(
                               //     placeholder: "Чево случилось",
                               //     color: Colors.indigo,
                              //  ),
                               // Row(
                                //    children: <Widget>[
                                //        Icon(Icons.pool),
                                //        Icon(Icons.accessible),
                               //         Icon(Icons.accessible_forward),
                               //         Icon(Icons.accessibility_new),
                               //         Icon(Icons.accessible_forward),
                              //          Icon(Icons.accessible),
                              //      ]
                           //     )
                         //   ],
                     //   ),
                    ),
                ),
            )
        );
    }
}