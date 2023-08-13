
import 'package:flutter/material.dart';

showLoading(context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Please Wait",style: TextStyle(color: Colors.black),),
          content: Container(
            height: 50,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      });
}


showCustomDialog(context,title,content) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("$title",style: TextStyle(color: Colors.red,),),
          content: Container(
            height: 50,
            padding: EdgeInsets.all(8),
            child: Center(
              child: Text("$content",style: TextStyle(fontWeight: FontWeight.w600),),
            ),
          ),
        );
      });
}