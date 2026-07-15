import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class UploadController extends GetxController{
  File? _selectedFile;

  Future openFileExplorer(String reportId,String username,String? uId,BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
        _selectedFile = File(result.files.single.path.toString());
        await uploadDataToFirebaseStorage(_selectedFile!, reportId, username, uId);
        Navigator.pop(context);
        Fluttertoast.showToast(msg: 'Report Uploaded Successfully',backgroundColor: Colors.green);

    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Error Uploading Report',backgroundColor: Colors.red);

    }
  }

  Future uploadDataToFirebaseStorage(File file, String reportId, String username,String? uId) async {
    try {
      // Create a Reference to the location Firebase Storage
      var storageReference = FirebaseStorage.instance.ref().child('uploads/reports/$reportId');

      // Upload the file to Firebase Storage
      UploadTask uploadTask = storageReference.putFile(file);

      // Get the URL of the uploaded file
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      print(uId);
      // Store additional information in Firebase Database
      FirebaseFirestore.instance.collection('reports').doc(uId).
      set(
      {
        'report_id': reportId,
        'username': username,
        'file_url': downloadURL,
      });
    } catch (e) {
      print('Error uploading file to Firebase Storage: $e');
    }
  }
}