import 'package:chat/constants.dart';
import 'package:chat/cubits/cubit.dart';
import 'package:chat/models/user.dart';
import 'package:chat/pages/login.dart';
import 'package:chat/widgets/custom_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  static String id = 'profile page';
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(color: kPrimaryColor),
      body: BlocBuilder<RegisterCubit, RegisterState>(
        builder: (context, state) {
          final user = BlocProvider.of<RegisterCubit>(context).user;
          final userName = user.name;
          return Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 85,
                  width: 85,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: kPrimaryColor,
                        child: Text(
                          userName[0].toString().toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(userName),
                    IconButton(
                      onPressed: () {
                        final newNameController = TextEditingController();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Update Name'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: newNameController,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter new name',
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    final newName =
                                        newNameController.text.trim();

                                    if (newName.isNotEmpty &&
                                        newName.length > 3) {
                                      try {
                                        final userCollection = FirebaseFirestore
                                            .instance
                                            .collection('users');
                                        final querySnapshot =
                                            await userCollection
                                                .where('email',
                                                    isEqualTo: user.email)
                                                .get();

                                        if (querySnapshot.docs.isNotEmpty) {
                                          final docId =
                                              querySnapshot.docs.first.id;

                                          await userCollection
                                              .doc(docId)
                                              .update({'name': newName});
                                          if (context.mounted) {
                                            BlocProvider.of<RegisterCubit>(
                                                        context)
                                                    .user =
                                                UserData(
                                                    email: user.email,
                                                    name: newName,
                                                    phone: user.phone);

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Name updated successfully!'),
                                              ),
                                            );
                                          }
                                          if (context.mounted) {
                                            Navigator.pop(context);
                                          }
                                          setState(() {});
                                        }
                                      } catch (e) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Failed to update name: ${e.toString()}'),
                                            ),
                                          );
                                        }
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Please enter a valid name'),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text('Update'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: kPrimaryColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(user.phone),
                    IconButton(
                      onPressed: () {
                        final newPhoneController = TextEditingController();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Update Phone'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: newPhoneController,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter new phone',
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    final newPhone =
                                        newPhoneController.text.trim();

                                    if (newPhone.isNotEmpty &&
                                        newPhone.length == 11) {
                                      try {
                                        final userCollection = FirebaseFirestore
                                            .instance
                                            .collection('users');
                                        final querySnapshot =
                                            await userCollection
                                                .where('email',
                                                    isEqualTo: user.email)
                                                .get();

                                        if (querySnapshot.docs.isNotEmpty) {
                                          final docId =
                                              querySnapshot.docs.first.id;

                                          await userCollection
                                              .doc(docId)
                                              .update({'phone': newPhone});

                                          // Update email in RegisterCubit
                                          if (context.mounted) {
                                            BlocProvider.of<RegisterCubit>(
                                                        context)
                                                    .user =
                                                UserData(
                                                    email: user.email,
                                                    name: user.name,
                                                    phone: newPhone);

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Phone updated successfully!'),
                                              ),
                                            );
                                          }
                                          if (context.mounted) {
                                            Navigator.pop(context);
                                          }
                                          setState(() {});
                                        }
                                      } catch (e) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Failed to update phone: ${e.toString()}'),
                                            ),
                                          );
                                        }
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Please enter a valid phone'),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text('Update'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: kPrimaryColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(user.email),
                    IconButton(
                      onPressed: () {
                        final newEmailController = TextEditingController();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Update Email'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: newEmailController,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter new email',
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    final newEmail =
                                        newEmailController.text.trim();

                                    if (newEmail.isNotEmpty &&
                                        RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z]+\.[a-zA-Z]+')
                                            .hasMatch(newEmail)) {
                                      try {
                                        final currentUser =
                                            FirebaseAuth.instance.currentUser;

                                        if (currentUser != null) {
                                          await currentUser
                                              .updateEmail(newEmail);

                                          final userCollection =
                                              FirebaseFirestore.instance
                                                  .collection('users');
                                          final querySnapshot =
                                              await userCollection
                                                  .where('email',
                                                      isEqualTo: user.email)
                                                  .get();

                                          if (querySnapshot.docs.isNotEmpty) {
                                            final docId =
                                                querySnapshot.docs.first.id;

                                            await userCollection
                                                .doc(docId)
                                                .update({'email': newEmail});
                                            if (context.mounted) {
                                              BlocProvider.of<RegisterCubit>(
                                                          context)
                                                      .user =
                                                  UserData(
                                                      email: newEmail,
                                                      name: user.name,
                                                      phone: user.phone);

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Email updated successfully!'),
                                                ),
                                              );

                                              if (context.mounted) {
                                                Navigator.pop(context);
                                              }
                                              setState(() {});
                                            }
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'No authenticated user found.'),
                                            ),
                                          );
                                        }
                                      } on FirebaseAuthException catch (e) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Failed to update email: ${e.message}'),
                                            ),
                                          );
                                        }
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Please enter a valid email'),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text('Update'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: kPrimaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text('Are you sure to log out ?'),
                            actions: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 160, 24, 14)
                                ),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed(LoginPage.id);
                                    BlocProvider.of<RegisterCubit>(context)
                                            .user =
                                        UserData(
                                            name: '', email: '', phone: '');
                                  },
                                  child: Text('ok',style: TextStyle(
                                    color: Colors.white
                                  ))),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.grey
                                ),
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('cancel',style: TextStyle(
                                    color: Colors.white
                                  ),))
                            ],
                          );
                        },
                      );
                    },
                    child: SizedBox(
                      width: 75,
                      height: 50,
                      child: Row(
                        children: [
                          Text(
                            'Log Out',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          Icon(
                            Icons.exit_to_app_rounded,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ))
              ],
            ),
          );
        },
      ),
    );
  }
}