import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:official_pbl/NotificationsRelated/notimodel.dart';
import 'package:official_pbl/components/noticards.dart';
import '../components/navbar.dart';





class zezonoti extends StatefulWidget {
  const zezonoti({super.key});

  @override
  State<zezonoti> createState() => _zezonotiState();
}

class _zezonotiState extends State<zezonoti> {

  // final example = FirebaseFirestore.instance.collection('trying').doc('imaging').snapshots();


  final Stream<QuerySnapshot> _notificationsStream =
      FirebaseFirestore.instance.collection('zezo').snapshots();


  List<notimodel> makinglist(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return notimodel(
        title1: data['zezo'] ?? '',
        // title2: data['title2'] ?? '',
        // title3: data['title3'] ?? '',
        // title4: data['title4'] ?? '',
        // title5: data['title5'] ?? '',
      );
    }).toList();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[800],
      bottomNavigationBar: navbar(),
      appBar: AppBar(
        title: Text('SecCam App'),
        backgroundColor: Colors.grey[800],
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _notificationsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No notifications found'));
          }


          List<notimodel> notifications = makinglist(snapshot.data!);

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  "List of Notifications",
                  style: TextStyle(fontSize: 30),
                ),




                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
                        child: Text(
                          notifications[index].title1,
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),







                    // Card(
                    //   margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    //   child: Padding(
                    //     padding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
                    //     child: Text(
                    //       notifications[index].title2,
                    //       style: TextStyle(
                    //         fontSize: 25,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // Card(
                    //   margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    //   child: Padding(
                    //     padding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
                    //     child: Text(
                    //       notifications[index].title3,
                    //       style: TextStyle(
                    //         fontSize: 25,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // Card(
                    //   margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    //   child: Padding(
                    //     padding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
                    //     child: Text(
                    //       notifications[index].title4,
                    //       style: TextStyle(
                    //         fontSize: 25,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // Card(
                    //   margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    //   child: Padding(
                    //     padding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
                    //     child: Column(
                    //       children: [
                    //         Text("this is a constant" , style: TextStyle(fontSize: 25,),),
                    //         Text(
                    //           notifications[index].title5,
                    //           style: TextStyle(
                    //             fontSize: 25,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),





                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

