import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xray_app/patient_entry.dart';
import 'package:xray_app/patient_tracking.dart';
import 'package:xray_app/patient_x_ray.dart';

import 'signin_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blueAccent, Colors.lightBlueAccent])),
        ),
        actions: [
          //! Builder eklemezsek Scaffold.of() hata verecektir!
          Builder(
            builder: (context) => IconButton(
              color: Colors.white,
              icon: Icon(Icons.backspace),
              onPressed: () async {
                await _auth.signOut();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInPage(),
                  ),
                );
              },
            ),
          )
        ],
      ),
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.lightBlueAccent, Colors.blueAccent])),
          child: Center(
            child: Column(
              children: [
                fittedBoxPadding(
                    context,
                    "Hasta Kayıt Sistemi",
                    "https://cdn3.iconfinder.com/data/icons/hospital-117/64/patient-medical_mask-man-sick-hospital-512.png",
                    "entry"),
                fittedBoxPadding(
                    context,
                    "Hasta Takip Sistemi",
                    "https://cdn.icon-icons.com/icons2/2240/PNG/512/doctor_icon_134842.png",
                    "tracing"),
                fittedBoxPadding(
                    context,
                    "X-ray Tahmin Sistemi",
                    "https://cdn0.iconfinder.com/data/icons/robotic-surgery-2/50/9-512.png",
                    "x-ray"),
              ],
            ),
          )),
    );
  }

  Widget fittedBoxPadding(
          BuildContext context, String name, String image, String navigation) =>
      Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap: () {
              if (navigation == "entry") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PatientEntry()),
                );
              } else if (navigation == 'tracing') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PatientTracking()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Xray()),
                );
              }
            },
            child: Container(
              child: new FittedBox(
                child: Material(
                    color: Colors.white,
                    elevation: 14.0,
                    borderRadius: BorderRadius.circular(24.0),
                    shadowColor: Colors.blueGrey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                      child: Text(
                                    "${name}",
                                    style: GoogleFonts.merriweather(
                                      textStyle: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 250,
                          height: 180,
                          child: ClipRRect(
                            borderRadius: new BorderRadius.circular(24.0),
                            child: Image(
                              fit: BoxFit.contain,
                              alignment: Alignment.topRight,
                              image: NetworkImage("${image}"),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          ));
}
