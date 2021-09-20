import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xray_app/patient.dart';
import 'package:xray_app/storage_service.dart';

class PatientService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  StorageService _storageService = StorageService();
  String url = "";

  Future<void> addPatient(Timestamp date, String name, String patient,
      String sex, PickedFile pickedFile) async {
    var ref = _firestore.collection("patient");

    if (pickedFile == null) {
      url =
          'https://cdn3.iconfinder.com/data/icons/hospital-117/64/patient-medical_mask-man-sick-hospital-512.png';
    } else {
      url = await _storageService.uploadMedia(File(pickedFile.path));
    }

    var doc = await ref.add({
      'date': date,
      'name': name,
      'patient': patient,
      'sex': sex,
      'xray': url
    });

    return Patient(
        id: doc.id,
        date: date,
        name: name,
        patient: patient,
        sex: sex,
        xray: url);
  }
}
