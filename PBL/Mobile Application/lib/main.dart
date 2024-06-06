import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:official_pbl/NotificationsRelated/base644.dart';
import 'package:official_pbl/NotificationsRelated/base6444.dart';
import 'package:official_pbl/NotificationsRelated/fifthbase64.dart';
import 'package:official_pbl/NotificationsRelated/fourthbase64.dart';
import 'package:official_pbl/NotificationsRelated/secondbase64.dart';
import 'package:official_pbl/NotificationsRelated/thirdbase64.dart';
import 'package:official_pbl/NotificationsRelated/zezonoti.dart';
import 'package:official_pbl/NotificationsRelated/base64.dart';
import 'package:official_pbl/NotificationsRelated/notipage.dart';
import 'package:official_pbl/pages/splash.dart';
import 'firebase_options.dart';
import 'pages/CameraViewPage.dart';
import 'pages/HomePageNotUsed.dart';
import 'NotificationsRelated/NotificationPagenotused.dart';
import 'pages/RegisterPage.dart';
import 'pages/WelcomePage.dart';
import 'pages/Dashboard.dart';
import 'pages/auth_page.dart';
import 'NotificationsRelated/firstbase64.dart';





void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SecCam App',
      theme: ThemeData(
        primaryColor: Colors.yellow,
        secondaryHeaderColor: Colors.grey,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => splash(),
        '/signin': (context) => RegisterPage(),
        '/register': (context) => RegisterPage(),
        '/camera_view': (context) => CameraViewPage(), //have a navbar
        '/notifications': (context) => notipage(), //have a navbar
        '/Dashboard': (context) => Dashboard(), //have a navbar
        '/auth': (context) => AuthPage(), //this is just a condition

        '/first': (context) => firstbase64(),
        '/second': (context) => secondbase64(),
        '/third': (context) => thirdbase64(),
        '/fourth': (context) => fourthbase64(),
        '/fifth': (context) => fifthbase64(),


        '/zezo': (context) => zezonoti(),




      },
    );
  }
}

/*
the logical flow of the screens:
first go to splash.. splash goes to auth.. auth goes to text fields.. then to dashboard..
dashboard have a sign out button
*/



