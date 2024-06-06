import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


//checks errors


class base6444 extends StatefulWidget {
  @override
  _base6444State createState() => _base6444State();
}

class _base6444State extends State<base6444> {
  String? base64Image;
  String? text;
  bool isLoading = true;
  late Stream<DocumentSnapshot> imageStream;

  @override
  void initState() {
    super.initState();
    imageStream = FirebaseFirestore.instance
        .collection('Errors1')  // Replace with your collection name
        .doc('Glove1') // Replace with your document ID
        .snapshots();

    imageStream.listen((doc) {
      if (doc.exists) {
        setState(() {
          base64Image = doc['base641']; // Replace with your image field name
          text = doc['error']; // Replace with your text field name
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          base64Image = null;
          text = null;
        });
      }
    }).onError((error) {
      setState(() {
        isLoading = false;
        base64Image = null;
        text = null;
      });
      // Handle the error, e.g., show a dialog or toast
      print('Error loading document: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (base64Image == null || text == null) {
      return Center(child: Text('Error loading data.'));
    }

    Uint8List bytes = base64Decode(base64Image!);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.memory(
          bytes,
          width: 200, // Adjust width as needed
          height: 200, // Adjust height as needed
        ),
        SizedBox(height: 20), // Add some space between the image and text
        Text(
          text!, // Display the text
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
