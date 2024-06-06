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



//image with text


class base644 extends StatefulWidget {
  @override
  _base644State createState() => _base644State();
}

class _base644State extends State<base644> {
  String? base64Image;
  bool isLoading = true;
  late Stream<DocumentSnapshot> imageStream;

  @override
  void initState() {
    super.initState();
    imageStream = FirebaseFirestore.instance
        .collection('Glove')  //collection name
        .doc('Glove') // Replace with your document ID
        .snapshots();

    imageStream.listen((doc) {
      setState(() {
        base64Image = doc['base64']; // Replace with your field name
        isLoading = false;
      });
    });
  }







  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (base64Image == null) {
      return Center(
        child: Text('Error loading image.'),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.memory(
          base64Decode(base64Image!),
          width: 200, // Adjust width as needed
          height: 200, // Adjust height as needed
        ),

        SizedBox(height: 20),

        // Add some space between the image and text
        StreamBuilder<DocumentSnapshot>(
          stream: imageStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            var data = snapshot.data!.data() as Map<String, dynamic>;

            return Text(
              data['error'], // Assuming 'text' is the field name for your text in Firestore
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ],
    );
  }
}