import 'package:flutter/material.dart';
import '../NotificationsRelated/zezonoti.dart';
import '../components/my_button.dart';
import '../components/routes_.dart';
import 'CameraViewPage.dart';
import 'Dashboard.dart';
import '../NotificationsRelated/NotificationPagenotused.dart';
import 'RegisterPage.dart';
import 'auth_page.dart';

class splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/signin': (context) => RegisterPage(),
        '/register': (context) => RegisterPage(),
        '/camera_view': (context) => CameraViewPage(), //have a navbar
        '/notifications': (context) => zezonoti(), //have a navbar
        '/Dashboard': (context) => Dashboard(), //have a navbar
        '/auth': (context) => AuthPage(),
      },
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.yellow[800],
          body: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 75,
                ),
                Text(
                  "Welcome to Sec Cam App",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),



                Text(
                  "We care about your saftey",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
                ),



                SizedBox(
                  height: 60,
                ),




                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  child: Image.asset(
                    'assets/man.png',
                    width: 500,
                    height: 415,
                    fit: BoxFit.cover,
                  ),
                ),


                MyButton(
                  onTap: () {
                    Navigator.pushNamed(context, '/auth');
                  },
                  backcolor_: Colors.yellow[400]!,
                  textcolor_: Colors.black,
                  text_: "Enter",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
