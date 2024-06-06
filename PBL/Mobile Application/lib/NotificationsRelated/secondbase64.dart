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


class secondbase64 extends StatefulWidget {
  @override
  _secondbase64State createState() => _secondbase64State();
}

class _secondbase64State extends State<secondbase64> {
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

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
                    child: Text(
                      data['error'],
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),



                Card(
                  margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
                    child: Text(
                      data['data_time'],
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
              ],
            );



            //
            //   Text(
            //   data['error'], // Assuming 'text' is the field name for your text in Firestore
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.bold,
            //   ),
            // );




          },
        ),
      ],
    );
  }
}