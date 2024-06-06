import 'package:flutter/material.dart';

class navbar extends StatelessWidget {
  const navbar({super.key});
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt),
          label: 'Cameras',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notifications',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/Dashboard');
            // Navigator.popUntil(context, ModalRoute.withName('/Dashboard'));
            break;
          case 1:
            Navigator.pushNamed(context, '/camera_view');
            break;
          case 2:
            Navigator.pushNamed(context, '/notifications');
            break;
        }
      },
    );
  }
}
