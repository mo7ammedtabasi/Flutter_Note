import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../component/alert.dart';

class EditeNote extends StatefulWidget {
  final docId;
  final list;

  const EditeNote({super.key, this.docId, this.list});

  @override
  State<EditeNote> createState() => _EditeNoteState();
}

class _EditeNoteState extends State<EditeNote> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  File? file;
  var title, note, imageUrl;
  late Reference ref;
  CollectionReference noteRef = FirebaseFirestore.instance.collection("notes");

  editNotes(context) async {
    showLoading(context);
    var formData = formState.currentState;
    if (file == null) {
      if (formData!.validate()) {
        formData.save();

        await noteRef.doc(widget.docId).update({
          "title": title,
          "note": note,
          "userId": FirebaseAuth.instance.currentUser?.uid
        }).then((value) => {
        Navigator.of(context).pushReplacementNamed("homepage")
        }).catchError((e){
          print("$e");
        });
      }
    } else {
      if (formData!.validate()) {
        formData.save();

        await ref.putFile(file!);
        imageUrl = await ref.getDownloadURL();

        await noteRef.doc(widget.docId).update({
          "title": title,
          "note": note,
          "imageUrl": imageUrl,
          "userId": FirebaseAuth.instance.currentUser?.uid
        }).then((value) => {
          Navigator.of(context).pushReplacementNamed("homepage")
        }).catchError((e){
          print("$e");
        });

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Edite Notes',style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        child: Column(
          children: [
            Form(
                key: formState,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: widget.list['title'],
                      onSaved: (val) {
                        title = val;
                      },
                      validator: (val) {
                        if (val!.length > 30) {
                          return "Title can't to be larger than 30 latter";
                        } else if (val.length < 2) {
                          return "Title can't to be less than 2 latter";
                        }
                        return null;
                      },
                      maxLength: 30,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Title Note",
                        prefixIcon: Icon(Icons.note),
                      ),
                    ),
                    TextFormField(
                      initialValue: widget.list['note'],
                      onSaved: (val) {
                        note = val;
                      },
                      validator: (val) {
                        if (val!.length > 255) {
                          return "Note can't to be larger than 255 latter";
                        } else if (val.length < 10) {
                          return "Note can't to be less than 10 latter";
                        }
                        return null;
                      },
                      minLines: 1,
                      maxLines: 3,
                      maxLength: 255,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Description  Note",
                        prefixIcon: Icon(Icons.description),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          showBottomSheet(context);
                        },
                        child: Text("Edite Image")),
                    ElevatedButton(
                      onPressed: () async {
                        await editNotes(context);
                      },
                      child: Text(
                        "Edite Note",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 100)),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  showBottomSheet(context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(20),
            height: 170,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Please choose Image",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () async {
                    print("Click gallery");
                    var picked = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    print("end");
                    if (picked != null) {
                      file = File(picked.path);
                      var rand = Random().nextInt(1000000);
                      var imageName = "$rand" + basename(picked.path);
                      ref = FirebaseStorage.instance
                          .ref("images")
                          .child("$imageName");
                    }
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    child: Row(children: [
                      Icon(Icons.photo),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'From Gallery',
                        style: TextStyle(fontSize: 18),
                      ),
                    ]),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    print("Click camera");
                    var picked = await ImagePicker()
                        .pickImage(source: ImageSource.camera);
                    if (picked != null) {
                      file = File(picked.path);
                      var rand = Random().nextInt(1000000);
                      var imageName = "$rand" + basename(picked.path);
                      ref = FirebaseStorage.instance
                          .ref("images")
                          .child("$imageName");
                      await ref.putFile(file!);

                      imageUrl = await ref.getDownloadURL();
                    }
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    child: Row(children: [
                      Icon(Icons.camera),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'From Camera',
                        style: TextStyle(fontSize: 18),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          );
        });
  }
}


