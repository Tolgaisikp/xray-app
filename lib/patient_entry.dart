import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xray_app/patient_service.dart';
import 'package:flutter/cupertino.dart';

class PatientEntry extends StatefulWidget {
  @override
  _PatientEntryState createState() => _PatientEntryState();
}

class _PatientEntryState extends State<PatientEntry> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  PatientService _patientService = PatientService();

  final ImagePicker _pickerImage = ImagePicker();

  String patientvalue = 'Normal';
  String sexvalue = 'Kadın';
  DateTime selectedDate;
  PickedFile xrayImage;

  var patient = ['Kovid', 'Normal', 'Zatürre'];
  var sex = ['Erkek', 'Kadın'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.lightBlueAccent, Colors.blueAccent])),
          child: Center(
            child: Form(
              key: _formKey,
              child: Card(
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text("Hasta Ekle",
                            style: GoogleFonts.merriweather(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.blue),
                            )),
                        CalendarDatePicker(
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2022),
                          initialDate: DateTime.now(),
                          onDateChanged: (date) {
                            setState(() {
                              selectedDate = date;
                            });
                          },
                        ),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: "İsim"),
                          validator: (String password) {
                            if (password.trim().isEmpty) {
                              return "Lütfen hasta ismi giriniz";
                            }
                            return null;
                          },
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 15),
                              alignment: Alignment.centerLeft,
                              child: DropdownButton(
                                iconSize: 40,
                                elevation: 16,
                                value: patientvalue,
                                icon: Icon(Icons.keyboard_arrow_down),
                                items: patient.map((String items) {
                                  return DropdownMenuItem(
                                      value: items, child: Text(items));
                                }).toList(),
                                onChanged: (String value) {
                                  setState(() {
                                    patientvalue = value;
                                  });
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 70, top: 15),
                              alignment: Alignment.centerLeft,
                              child: DropdownButton(
                                iconSize: 40,
                                elevation: 16,
                                value: sexvalue,
                                icon: Icon(Icons.keyboard_arrow_down),
                                items: sex.map((String items) {
                                  return DropdownMenuItem(
                                      value: items, child: Text(items));
                                }).toList(),
                                onChanged: (String value) {
                                  setState(() {
                                    sexvalue = value;
                                  });
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 65, top: 15),
                              child: InkWell(
                                  onTap: () => _onImageButtonPressed(
                                      ImageSource.gallery,
                                      context: context),
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 30,
                                    color: Colors.blue,
                                  )),
                            )
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8, bottom: 15, top: 15),
                            child: InkWell(
                              onTap: () async {
                                if (_formKey.currentState.validate()) {
                                  Timestamp myTimeStamp =
                                      Timestamp.fromDate(selectedDate);
                                  _patientService.addPatient(
                                      myTimeStamp,
                                      _nameController.text,
                                      patientvalue,
                                      sexvalue,
                                      xrayImage);
                                }
                              },
                              child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.blue, width: 2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Center(
                                        child: Text(
                                      "Ekle",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 12,
                                      ),
                                    )),
                                  )),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }

  _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _pickerImage.getImage(source: source);
      setState(() {
        xrayImage = pickedFile;
        print("dosyaya geldim: $xrayImage");
        if (xrayImage != null) {}
      });
    } catch (e) {
      setState(() {
        print("Image Error: " + e.toString());
      });
    }
  }
}
