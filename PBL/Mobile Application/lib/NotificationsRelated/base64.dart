import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_image/flutter_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


//image only


class base64 extends StatefulWidget {
  @override
  _base64State createState() => _base64State();
}

class _base64State extends State<base64> {
  String? base64Image;
  bool isLoading = true;
  late Stream<DocumentSnapshot> imageStream;

  @override
  void initState() {
    super.initState();
    imageStream = FirebaseFirestore.instance
        .collection('Errors1')  //collection name
        .doc('Glove1') // Replace with your document ID
        .snapshots();

    imageStream.listen((doc) {
      setState(() {
        base64Image = doc['base641']; // Replace with your field name
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return CircularProgressIndicator();
    }

    if (base64Image == null) {
      return Text('Error loading image.');
    }

    Uint8List bytes = base64Decode(base64Image!);
    return Image.memory(bytes);
  }
}