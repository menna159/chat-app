import 'package:chat/firebase_options.dart';
import 'package:chat/pages/chat.dart';
import 'package:chat/pages/login.dart';
import 'package:chat/pages/main_chat.dart';
import 'package:chat/pages/main_page.dart';
import 'package:chat/pages/profile.dart';
import 'package:chat/pages/register.dart';
import 'package:chat/cubits/cubit.dart'; // Import your cubit
import 'package:chat/pages/splach_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          LoginPage.id: (context) => LoginPage(),
          RegisterPage.id: (context) => RegisterPage(),
          ChatPage.id: (context) => ChatPage(),
          MainChatPage.id: (context) => MainChatPage(),
          MainPage.id: (context) => MainPage(),
          ProfilePage.id: (context) => ProfilePage(),
          SplachScreen.id:(context)=>SplachScreen()
        },
        initialRoute: SplachScreen.id, // Set the initial route
      ),
    );
  }
}
