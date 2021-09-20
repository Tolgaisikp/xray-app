import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PatientTracking extends StatefulWidget {
  @override
  _PatientTrackingState createState() => _PatientTrackingState();
}

class _PatientTrackingState extends State<PatientTracking> {
  bool _longCard = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('patient')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.lightBlueAccent, Colors.blueAccent])),
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                  ),
                ));
          } else if (snapshot.hasError) {
            return Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.lightBlueAccent, Colors.blueAccent])),
                child: Center(
                  child: Icon(
                    Icons.error,
                    size: 60,
                    color: Colors.white,
                  ),
                ));
          }
          //querySnapshot dönüşlü
          final QuerySnapshot querySnapshot = snapshot.data;
          return Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.lightBlueAccent, Colors.blueAccent])),
              child: ListView.builder(
                itemCount: querySnapshot.size,
                itemBuilder: (context, index) {
                  final map = querySnapshot.docs[index].data();
                  return GestureDetector(
                      onTap: () {
                        setState(() {
                          _longCard = !_longCard;
                        });
                      },
                      child: _longCard == false
                          ? patientCard(map, querySnapshot, index)
                          : patientDetailCard(map, querySnapshot, index));
                },
              ));
        },
      ),
    );
  }

  Widget patientCard(Map map, QuerySnapshot querySnapshot, int index) => Card(
      elevation: 10,
      margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 20.0),
      child: ListTile(
        leading: CircleAvatar(
          child: Container(
            child: map['sex'] == 'Erkek'
                ? Image.network(
                    "https://cdn2.iconfinder.com/data/icons/covid-19-flat/64/virus-26-512.png")
                : Image.network(
                    "https://cdn2.iconfinder.com/data/icons/covid-19-flat/64/virus-25-512.png"),
            margin: EdgeInsets.all(3),
          ),
          backgroundColor: Colors.lightBlueAccent,
          radius: 30,
        ),
        title: Text(
          map['name'],
          style: TextStyle(
              color: Colors.blue, fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          map['patient'],
          style: TextStyle(color: Colors.blue.shade800, fontSize: 15.0),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.restore_from_trash,
            color: Colors.blue,
          ),
          onPressed: () async {
            await querySnapshot.docs[index].reference.delete();
            FirebaseStorage.instance.refFromURL(map['xray']).delete();
            print("${map['name']}");
          },
        ),
      ));

  Widget patientDetailCard(Map map, QuerySnapshot querySnapshot, int index) =>
      Card(
          elevation: 10,
          margin:
              EdgeInsets.only(left: 5.0, right: 5.0, top: 20.0, bottom: 20.0),
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  child: Container(
                    child: map['sex'] == 'Erkek'
                        ? Image.network(
                            "https://cdn2.iconfinder.com/data/icons/covid-19-flat/64/virus-26-512.png")
                        : Image.network(
                            "https://cdn2.iconfinder.com/data/icons/covid-19-flat/64/virus-25-512.png"),
                    margin: EdgeInsets.all(3),
                  ),
                  backgroundColor: Colors.lightBlueAccent,
                  radius: 30,
                ),
                title: Text(
                  map['name'],
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  map['patient'],
                  style: TextStyle(color: Colors.blue.shade800, fontSize: 15.0),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.restore_from_trash,
                    color: Colors.blue,
                  ),
                  onPressed: () async {
                    await querySnapshot.docs[index].reference.delete();
                    FirebaseStorage.instance.refFromURL(map['xray']).delete();
                    print("${map['name']}");
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10, top: 10),
                child: Image.network(map['xray']),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 15, top: 15),
                child: Text(
                  map['patient'],
                  style: GoogleFonts.merriweather(
                    textStyle: TextStyle(
                        color: Colors.blue,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ));
}
