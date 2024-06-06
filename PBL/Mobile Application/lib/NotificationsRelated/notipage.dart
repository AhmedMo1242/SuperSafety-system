import 'package:flutter/material.dart';
import 'package:official_pbl/NotificationsRelated/base64.dart';
import 'package:official_pbl/NotificationsRelated/zezonoti.dart';

class notipage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.yellow[800],
        appBar: AppBar(
          title: Text('notifications list'),
          backgroundColor: Colors.grey[800],
          foregroundColor: Colors.white,
        ),


        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [





              Container(
                margin: EdgeInsets.all(10), // You can adjust the margin as needed
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/first');
                  },

                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blue, // Text color
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20), // Button padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Button border radius
                    ),
                    elevation: 3, // Elevation
                  ),

                  child: Text('Helmet' , style: TextStyle(fontSize: 25),),
                ),
              ),




              Container(
                margin: EdgeInsets.all(10), // You can adjust the margin as needed
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/second');
                  },

                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blue, // Text color
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20), // Button padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Button border radius
                    ),
                    elevation: 3, // Elevation
                  ),

                  child: Text('Glove' , style: TextStyle(fontSize: 25),),
                ),
              ),




              Container(
                margin: EdgeInsets.all(10), // You can adjust the margin as needed
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/third');
                  },

                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blue, // Text color
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20), // Button padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Button border radius
                    ),
                    elevation: 3, // Elevation
                  ),

                  child: Text('Google' , style: TextStyle(fontSize: 25),),
                ),
              ),





              Container(
                margin: EdgeInsets.all(10), // You can adjust the margin as needed
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/fourth');
                  },

                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blue, // Text color
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20), // Button padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Button border radius
                    ),
                    elevation: 3, // Elevation
                  ),

                  child: Text('Vest' , style: TextStyle(fontSize: 25),),
                ),
              ),




              Container(
                margin: EdgeInsets.all(10), // You can adjust the margin as needed
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/fifth');
                  },

                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blue, // Text color
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20), // Button padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Button border radius
                    ),
                    elevation: 3, // Elevation
                  ),

                  child: Text('Line' , style: TextStyle(fontSize: 25),),
                ),
              ),


              //
              // Container(
              //   margin: EdgeInsets.all(10), // You can adjust the margin as needed
              //   child: ElevatedButton(
              //     onPressed: () {
              //       Navigator.pushNamed(context, '/zezo');
              //     },
              //
              //     style: ElevatedButton.styleFrom(
              //       foregroundColor: Colors.white, backgroundColor: Colors.blue, // Text color
              //       padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20), // Button padding
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10), // Button border radius
              //       ),
              //       elevation: 3, // Elevation
              //     ),
              //
              //     child: Text('zezo' , style: TextStyle(fontSize: 25),),
              //   ),
              // ),



            ],
          ),
        ),
      ),
    );
  }
}


