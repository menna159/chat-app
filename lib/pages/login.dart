import 'package:chat/constants.dart';
import 'package:chat/cubits/cubit.dart';
import 'package:chat/helper/show_dialog.dart';
import 'package:chat/models/user.dart';
import 'package:chat/pages/main_page.dart';
import 'package:chat/pages/register.dart';
import 'package:chat/widgets/custom_button.dart';
import 'package:chat/widgets/custom_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String id = 'loginPage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 30),
              const SizedBox(
                width: 150,
                height: 150,
                child: Image(image: AssetImage(kLogo)),
              ),
              const SizedBox(height: 15),
              const Text(
                'Chat App',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontFamily: 'Raleway',
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Login',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 15),
              customTextField(
                hintText: 'Email',
                controller: emailController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter email';
                  } else if (!RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z]+\.[a-zA-Z]+')
                      .hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              customTextField(
                obsecureText: true,
                hintText: 'Password',
                controller: passwordController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter password';
                  } else if (value.length < 8) {
                    return 'Password length must be more than 8';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              customButton(
                text: isLoading ? 'Loading...' : 'Login',
                onTap: () async {
                  if (_formKey.currentState!.validate() && !isLoading) {
                    setState(() {
                      isLoading = true;
                    });
                    await handleLogin(context);
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Don\'t have an account?',
                    style: TextStyle(color: Colors.white),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, RegisterPage.id);
                    },
                    child: Text(
                      ' Register',
                      style: TextStyle(color: kSecondaryColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> handleLogin(BuildContext context) async {
    try {
      // Authenticate user
      await loginUser();

      // Fetch user data from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: emailController.text)
          .get();

      if (userDoc.docs.isNotEmpty) {
        final userName = userDoc.docs.first['name'];
        final userEmail = userDoc.docs.first['email'];
        final userPhone = userDoc.docs.first['phone'];
        final userImage = userDoc.docs.first['image'];
        // Update RegisterCubit
        if (context.mounted) {
          BlocProvider.of<RegisterCubit>(context).user = UserData(
              email: userEmail,
              name: userName,
              phone: userPhone,
              image: userImage);

          Navigator.pushNamed(context, MainPage.id,
              arguments: emailController.text);
        }
      } else {
        if (context.mounted) {
          showAlertDialog(context, 'User data not found.');
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else {
        errorMessage = 'An unknown error occurred. Please try again.';
      }
      if (context.mounted) {
        showAlertDialog(context, errorMessage);
      }
    } catch (e) {
      if (context.mounted) {
        showAlertDialog(context, 'An error occurred: $e');
      }
    }
  }

  Future<UserCredential> loginUser() async {
    var auth = FirebaseAuth.instance;
    return await auth.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );
  }
}
