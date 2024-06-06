import 'package:flutter/material.dart';
import '../NotificationsRelated/zezonoti.dart';
import '../pages/CameraViewPage.dart';
import '../pages/Dashboard.dart';
import '../NotificationsRelated/NotificationPagenotused.dart';
import '../pages/RegisterPage.dart';
import '../pages/splash.dart';

// Define your routes here
Map<String, WidgetBuilder> routes_ = {
  '/signin': (context) => RegisterPage(),
  '/register': (context) => RegisterPage(),
  '/camera_view': (context) => CameraViewPage(), //have a navbar
  '/notifications': (context) => zezonoti(), //have a navbar
  '/Dashboard': (context) => Dashboard(), //have a navbar
};