import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note/component/alert.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var myEmail, myPassword;

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  signin() async {
    var formatData = formState.currentState;

    if (formatData!.validate()) {
      formatData.save();

      try {
        showLoading(context);
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: myEmail, password: myPassword);
        return credential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Navigator.of(context).pop();
          CoolAlert.show(
            context: context,
            title: "Error",
            type: CoolAlertType.error,
            text: "No user found for that email.",
          );
        } else if (e.code == 'wrong-password') {
          Navigator.of(context).pop();
          CoolAlert.show(
            context: context,
            title: "Error",
            type: CoolAlertType.error,
            text: "Wrong password provided for that user.",
          );
        }
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
                          prefixIcon: Icon(Icons.person),
                          hintText: "Email",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1))),
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
                          Text("If you havan't account "),
                          InkWell(
                            child: Text(
                              'Click Here',
                              style: TextStyle(color: Colors.blue),
                            ),
                            onTap: () {
                              Navigator.of(context)
                                  .pushReplacementNamed("signup");
                              print("go to signup");
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
                              UserCredential response = await signin();

                              print("uid => ${response.user}");
                              if (response != null) {
                                Navigator.of(context)
                                    .pushReplacementNamed("homepage");
                              }
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(fontSize: 30,color: Colors.white),
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
