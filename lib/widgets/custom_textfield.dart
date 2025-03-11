import 'package:flutter/material.dart';

Widget customTextField(
    {required String hintText,
    required TextEditingController controller,
    required FormFieldValidator validator,
    bool obsecureText = false}) {
  return TextFormField(
    style: TextStyle(color: Colors.white),
    validator: validator,
    controller: controller,
    obscureText: obsecureText,
    decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.white)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        )),
  );
}
