import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:note/auth/signup.dart';
import 'package:note/curd/add_notes.dart';
import 'package:note/home/home_page.dart';

import 'auth/login.dart';
import 'firebase_options.dart';

var isLogin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print("===================== Background Message =======================");
  FirebaseMessaging.onBackgroundMessage(backgroundMessage);

  var user = FirebaseAuth.instance.currentUser;
  isLogin = user == null ? false : true;
  runApp(const MyApp());
}

Future backgroundMessage(RemoteMessage message) async {
  print("body => ${message.notification?.body}");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red,
        textTheme: TextTheme(
          headline6: TextStyle(fontSize: 22, color: Colors.white),
          headline5: TextStyle(fontSize: 30, color: Colors.blue),
          bodyText2: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
      home: isLogin == false ? Login() : HomePage(),
      routes: {
        "login": (context) => Login(),
        "signup": (context) => Signup(),
        "homepage": (context) => HomePage(),
        "addNotes": (context) => AddNote(),
      },
    );
  }
}
