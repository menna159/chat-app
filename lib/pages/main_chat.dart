import 'package:chat/constants.dart';
import 'package:chat/pages/chat.dart';
import 'package:chat/widgets/custom_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MainChatPage extends StatefulWidget {
  const MainChatPage({super.key});
  static String id = 'main chat page';

  @override
  State<MainChatPage> createState() => _MainChatPageState();
}

class _MainChatPageState extends State<MainChatPage> {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  String searchQuery = '';
  List<QueryDocumentSnapshot> allUsers = [];
  List<QueryDocumentSnapshot> filteredUsers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final querySnapshot = await users.get();
      setState(() {
        allUsers = querySnapshot.docs;
        filteredUsers = allUsers;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterUsers(String query) {
    setState(() {
      searchQuery = query;
      filteredUsers = allUsers
          .where((user) => user['name']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final String? email = ModalRoute.of(context)?.settings.arguments as String?;

    if (email == null) {
      return const Scaffold(
        body: Center(
          child: Text('User email not found. Please try logging in again.'),
        ),
      );
    }

    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final List<QueryDocumentSnapshot> displayUsers =
        filteredUsers.where((user) => user['email'] != email).toList();

    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by name',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: kPrimaryColor)),
                prefixIcon: Icon(
                  Icons.search,
                  color: kPrimaryColor,
                ),
              ),
              onChanged: _filterUsers,
            ),
          ),
          Expanded(
            child: displayUsers.isEmpty
                ? const Center(
                    child: Text('No users found.'),
                  )
                : ListView.separated(
                    separatorBuilder: (context, index) =>
                        const Divider(color: Colors.grey),
                    itemCount: displayUsers.length,
                    itemBuilder: (context, index) {
                      final user = displayUsers[index];
                      final userEmail = user['email'];
                      final userName = user['name'];
                      final id = user.id;
                      final userPhone = user['phone'];
                      final userImage = user['image'];
                      return ListTile(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ChatPage.id,
                            arguments: {
                              'to': userEmail,
                              'from': email,
                              'name': userName,
                              'id': id,
                              'phone': userPhone,
                            },
                          );
                        },
                        leading: CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              AssetImage('assets/images/profile.png')
                                  as ImageProvider,
                        ),
                        title: Text(userName),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
