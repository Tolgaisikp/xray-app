import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:tflite/tflite.dart';

class Xray extends StatefulWidget {
  @override
  _XrayState createState() => _XrayState();
}

class _XrayState extends State<Xray> {
  bool _isloading;
  File _image;
  List _output;

  @override
  void initState() {
    super.initState();
    _isloading = true;
    loadModel().then((value) {
      setState(() {
        _isloading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isloading
          ? Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.lightBlueAccent, Colors.blueAccent])),
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.lightBlueAccent, Colors.blueAccent])),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _image == null
                      ? Container()
                      : Container(
                          margin: EdgeInsets.only(left: 25, right: 25),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Card(
                            elevation: 15,
                            child: Image.file(_image),
                          ),
                        ),
                  SizedBox(
                    height: 16,
                  ),
                  _output == null
                      ? Text("")
                      : Column(
                          children: [
                            Text(
                              "Tahmin : ${_output[0]["label"]}",
                              style: GoogleFonts.merriweather(
                                textStyle: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              "Yüzdesi: %${_output[0]['confidence'] * 100}",
                              style: GoogleFonts.merriweather(
                                textStyle: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        )
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          chooseImage();
        },
        child: Icon(Icons.image),
      ),
    );
  }

  chooseImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _isloading = true;
      _image = image;
    });
    runModelOnImage(image);
  }

  runModelOnImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        imageMean: 0.0,
        imageStd: 255.0,
        numResults: 2,
        threshold: 0.5,
        asynch: true);
    setState(() {
      _isloading = false;
      _output = output;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
    );
  }
}
