import 'package:chat/constants.dart';
import 'package:chat/models/messege.dart';
import 'package:flutter/material.dart';

Widget chatBubbleForFriend(Messege message) {
  return Align(
    alignment: Alignment.centerRight,
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.only(left: 8, top: 16, bottom: 16, right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            bottomLeft: Radius.circular(25),
            topRight: Radius.circular(25)),
        color: kPrimaryColor,
      ),
      child: Text(
        message.message,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
  );
}
