// Page 3: Home Page
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        foregroundColor: Colors.white,
        title: Text('SecCam App'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
        ],
      ),
      backgroundColor: Colors.yellow[800],
      body: Column(
        children: [
          // Banner or Row of Buttons for navigation
          Container(
            color: Colors.yellow[800],
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  },
                  child: Text('Home'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/camera_view');
                  },
                  child: Text('Cameras'),
                ),
              ],
            ),
          ),
          // Your main content goes here
          Expanded(
            child: Center(
              child: Text('Welcome to SecCam App', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
            ),
          ),
        ],
      ),
    );
  }
}