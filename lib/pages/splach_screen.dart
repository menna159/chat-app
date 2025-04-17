import 'dart:async';
import 'package:chat/constants.dart';
import 'package:chat/pages/login.dart';
import 'package:flutter/material.dart';

class SplachScreen extends StatefulWidget {
  const SplachScreen({super.key});
  static String id = 'splach screen';
  @override
  State<SplachScreen> createState() => _SplachScreenState();
}

class _SplachScreenState extends State<SplachScreen> {
  double _opacity = 0.0;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _opacity = 1.0;
      });
    });
    Timer( const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context,LoginPage.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
     backgroundColor: kPrimaryColor,
      body: Center(
        child:AnimatedOpacity(opacity: _opacity,
         duration:const Duration(
          seconds: 2
         ),curve: Curves.easeInOut,
         child: TweenAnimationBuilder(tween: Tween<double>(begin: 0.8, end: 1.0),
          duration:const Duration(seconds: 2),
          curve: Curves.easeOutBack,
           builder: (context,value,child){
            return Transform.scale(
                scale: value,
                child: child,
              );
           },
           child: Image.asset('assets/images/logo.png', width: 200,height: 200,), 
           ),
           )
      ),
    );
  }
}
