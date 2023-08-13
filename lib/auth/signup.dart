import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';

import '../component/alert.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  var myUsename, myEmail, myPassword;

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  signup() async {

    var formatData = formState.currentState;

      if (formatData!.validate()) {
        formatData.save();

        try {
          showLoading(context);
          UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: myEmail,
            password: myPassword,
          );
          return credential;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            Navigator.of(context).pop();
            CoolAlert.show(
              context: context,
              title:"Error",
              type: CoolAlertType.error,
              text: "The password provided is too weak.",
            );
          } else if (e.code == 'email-already-in-use  ') {
            Navigator.of(context).pop();
            CoolAlert.show(
              context: context,
              title:"Error",
              type: CoolAlertType.error,
              text: "The account already exists for that email.",
            );
          }
        } catch (e) {
          print(e);
        }

      } else {
        print("Not Valid");
      }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            SizedBox(
              height: 100,
            ),
            Center(
              child: Image.asset("images/logo.jpg"),
            ),
            Container(
              margin: EdgeInsets.only(top: 16),
              child: Form(
                key: formState,
                child: Column(
                  children: [
                    TextFormField(
                      onSaved: (val) {
                        myUsename = val;
                      },
                      validator: (val) {
                        if (val!.length > 50) {
                          return "username can't to be larger than 100 latter";
                        } else if (val.length < 2) {
                          return "username can't to be less than 2 latter";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          hintText: "username",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1))),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      child: TextFormField(
                        onSaved: (val) {
                          myEmail = val;
                        },
                        validator: (val) {
                          if (val!.length > 50) {
                            return "Email can't to be larger than 100 latter";
                          } else if (val.length < 2) {
                            return "Email can't to be less than 2 latter";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            hintText: "Email",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(width: 1))),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      child: TextFormField(
                        onSaved: (val) {
                          myPassword = val;
                        },
                        validator: (val) {
                          if (val!.length > 50) {
                            return "Password can't to be larger than 100 latter";
                          } else if (val.length < 6) {
                            return "Password can't to be less than 6 latter";
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            hintText: "password",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(width: 1))),
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Text("If you havan account "),
                          InkWell(
                            child: Text(
                              'Click Here',
                              style: TextStyle(color: Colors.blue),
                            ),
                            onTap: () {
                              print("go to Login");
                              Navigator.of(context).pushNamed("login");
                            },
                          )
                        ],
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 16),
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.indigo)),
                            onPressed: () async {
                              UserCredential response = await signup();
                              if(response != null){
                                await FirebaseFirestore.instance.collection("Users").
                                    add({"username": myUsename, "email" : myEmail});
                                Navigator.of(context).pushReplacementNamed("homepage");
                              }
                            },
                            child: Text(
                              'Create Account',
                              style:TextStyle(fontSize: 30,color: Colors.white),
                            ))),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
