import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note/curd/edit_notes.dart';
import 'package:note/curd/viewNotes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.  key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference notesRef = FirebaseFirestore.instance.collection("notes");

  getUser() {
    var user = FirebaseAuth.instance.currentUser;
    print(user!.email);
  }

  var fbm = FirebaseMessaging.instance;

  initialMessage() async {
    var message = await FirebaseMessaging.instance.getInitialMessage();
    if(message != null){
      Navigator.of(context).pushNamed("addNotes");
    }
  }


  requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
    fbm.getToken().then((token) => {
      print("==================== \n$token =========================================================================")
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification?.title}');
      }
    });


    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      Navigator.of(context).pushNamed("addNotes");
    });


     initialMessage();

     requestPermission();
  }



  @override
  Widget build(BuildContext context) {
    double mdw = MediaQuery
        .of(context)
        .size
        .width;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.indigo,
            child: Icon(Icons.add,color: Colors.white,),
            onPressed: () {
              Navigator.of(context).pushNamed("addNotes");
            },
          ),
          appBar: AppBar(
            backgroundColor: Colors.indigo,
            title: Text(
              'Home Page',
              style: TextStyle(color: Colors.white),
               ),
            actions: [
              IconButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacementNamed("login");
                  },
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ))
            ],
          ),
          body: Container(
            child: FutureBuilder(
              future: notesRef
                  .where("userId",
                  isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .get(),
              builder: (context, snpshot) {
                if (snpshot.hasData) {
                  return ListView.builder(
                      itemCount: snpshot.data?.docs.length,
                      itemBuilder: (context, i) {
                        return Dismissible(
                            onDismissed: (diration) async {
                              await notesRef.doc(snpshot.data?.docs[i].id)
                                  .delete();
                              await FirebaseStorage.instance.refFromURL(
                                  snpshot.data?.docs[i]['imageUrl'])
                                  .delete()
                                  .then((value) => {
                              print("URL => ${snpshot.data?.docs[i]['imageUrl']}")
                            });
                            },
                            key: UniqueKey(),
                            child: ListNote(
                              notes: snpshot.data?.docs[i].data() as Map,
                              docId: snpshot.data?.docs[i].id,
                              mdw: mdw,
                            ));
                      });
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          )),
    );
  }
}

class ListNote extends StatelessWidget {
  final notes;
  final docId;
  final mdw;

  ListNote({this.notes, this.docId, this.mdw});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context){
          return ViewNotes(notes: notes,);
        }));
      },
      child: Card(
        child: Row(children: [
          Expanded(
              flex: 1,
              child: Image.network(
                "${notes['imageUrl']}",
                fit: BoxFit.fill,
                height: 100,
              )),
          Expanded(
            flex: 3,
            child: ListTile(
              title: Text("${notes['title']}"),
              subtitle: Text("${notes['note']}",style: TextStyle(fontSize: 14),),
              // leading: IconButton(
              //   icon: Icon(
              //     Icons.delete,
              //     color: Colors.red,
              //   ),
              //   onPressed: () {},
              // ),
              trailing: IconButton(
                icon: Icon(Icons.edit,color: Colors.indigo,),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return EditeNote(
                      docId: docId,
                      list: notes,
                    );
                  }));
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
