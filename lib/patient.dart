import 'package:cloud_firestore/cloud_firestore.dart';

class Patient {
  String id;
  Timestamp date;
  String name;
  String patient;
  String sex;
  String xray;

  Patient({this.id, this.date, this.name, this.patient, this.sex, this.xray});

  factory Patient.fromSnapshot(DocumentSnapshot snapshot) {
    return Patient(
        id: snapshot.id,
        date: snapshot['date'],
        name: snapshot['name'],
        patient: snapshot['patient'],
        sex: snapshot['sex'],
        xray: snapshot['xray']);
  }
}
