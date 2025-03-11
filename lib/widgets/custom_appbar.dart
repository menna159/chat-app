import 'package:chat/constants.dart';
import 'package:flutter/material.dart';

AppBar buildAppBar(
    {String title = '',
    String subTitle = '',
    Color color = Colors.transparent}) {
  return AppBar(
    automaticallyImplyLeading: false,
    foregroundColor: Colors.white,
    backgroundColor: color,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          kLogo,
          height: 50,
        ),
        Column(
          children: [
            Text(
              title,
              style: TextStyle(color: kPrimaryColor),
            ),
            Text(subTitle)
          ],
        ),
      ],
    ),
  );
}
