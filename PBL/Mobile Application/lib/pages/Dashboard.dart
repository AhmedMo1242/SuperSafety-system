import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:official_pbl/components/navbar.dart';

class Dashboard extends StatelessWidget {

  final user = FirebaseAuth.instance.currentUser!;

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SecCam App'),
        backgroundColor: Colors.grey[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: Icon(Icons.logout),
          )
        ],
      ),
      backgroundColor: Colors.yellow[800],
      body: const Center(
        child: Column(
          children: [
            Image(image: AssetImage('assets/seccam_logo.png')),
            Text('Welcome to SecCam App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),
            ),
            //timer to show "all good" notification

          ],
        ),
      ),

      bottomNavigationBar: navbar()
    );
  }
}

