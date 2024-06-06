import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:official_pbl/components/navbar.dart';
import 'package:provider/provider.dart';
import 'zezonoti.dart';




//
// class NotificationPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamProvider<QuerySnapshot?>.value(
//         value: dope().collection,
//         initialData:null,
//         child: Scaffold(
//           body: noti_item(),
//         )
//     );
//   }
// }
//




//
//
// class NotificationPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Notifications'),
//         backgroundColor: Colors.grey[800],
//         foregroundColor: Colors.white,
//       ),
//       backgroundColor: Colors.yellow[800],
//       body: ListView(
//         children: [
//           ListTile(
//             leading: Icon(Icons.warning),
//             title: Text('Hazard Detected'),
//             subtitle: Text('💀'),
//           ),
//           ListTile(
//             leading: Icon(Icons.warning),
//             title: Text('No Helmet Detected'),
//             subtitle: Text('⛑️'),
//           ),
//           ListTile(
//             leading: Icon(Icons.check_circle),
//             title: Text('Everything Looks Cool'),
//             subtitle: Text('✅'),
//           ),
//         ],
//       ),
//       bottomNavigationBar: navbar(),
//     );
//   }
// }
//
//





//
// class NotificationPage extends StatefulWidget {
//   @override
//   _NotificationPageState createState() => _NotificationPageState();
// }
//
// class _NotificationPageState extends State<NotificationPage> {
//   final Stream<QuerySnapshot> _usersStream =
//   FirebaseFirestore.instance.collection('notifications_').snapshots();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Notifications'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _usersStream,
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: const Text('Something went wrong'));
//           }
//
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: const CircularProgressIndicator());
//           }
//
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: const Text('No notifications found'));
//           }
//
//           return ListView(
//             children: snapshot.data!.docs.map((DocumentSnapshot document) {
//               Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
//               if (data == null) {
//                 return ListTile(
//                   title: Text('No details available'),
//                 );
//               }
//
//               String details = data['details'] as String? ?? 'No details available';
//
//               return ListTile(
//                 title: Text(details),
//               );
//             }).toList(),
//           );
//         },
//       ),
//     );
//   }
// }
