import 'package:chat/constants.dart';
import 'package:chat/cubits/cubit.dart';
import 'package:chat/helper/show_dialog.dart';
import 'package:chat/models/user.dart';
import 'package:chat/pages/main_page.dart';
import 'package:chat/widgets/custom_button.dart';
import 'package:chat/widgets/custom_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterPage extends StatefulWidget {
  static String id = 'registerPage';

  const RegisterPage({super.key});
  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final _formKey2 = GlobalKey<FormState>();
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          showAlertDialog(context, state.errorMessage!);
        }
      },
      builder: (context, state) {
        final cubit = context.read<RegisterCubit>();

        return ModalProgressHUD(
          inAsyncCall: state.isLoading,
          child: Scaffold(
            backgroundColor: kPrimaryColor,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Form(
                key: _formKey2,
                child: ListView(
                  children: [
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: Image.asset(kLogo),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Chat App',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: 'Raleway'),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    const SizedBox(height: 15),
                    customTextField(
                      hintText: 'User Name',
                      controller: nameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        } else if (value.length < 3) {
                          return 'Name must be more than 2 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    customTextField(
                      hintText: 'Phone',
                      controller: phoneController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your phone';
                        } else if (value.length < 11) {
                          return 'Phone must be 11 numbers';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    customTextField(
                      hintText: 'Email',
                      controller: emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(
                                r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                            .hasMatch(value)) {
                          return 'Email must contain a valid domain and extension (e.g. example@domain.com)';
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
                      text: 'Sign Up',
                      onTap: () {
                        if (_formKey2.currentState!.validate()) {
                          cubit.registerUser(
                            register: () => FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            ),
                            addUserToDatabase: () => users.add({
                              'email': emailController.text.trim(),
                              'name': nameController.text.trim(),
                              'phone': phoneController.text.trim(),
                              'image': 'assets/images/profile.png'
                            }),
                            onSuccess: (_) {
                              cubit.user = UserData(
                                  email: emailController.text,
                                  name: nameController.text,
                                  phone: phoneController.text);
                              Navigator.pushNamed(context, MainPage.id,
                                  arguments: emailController.text);
                            },
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(color: Colors.white),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(color: kSecondaryColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
