import 'package:chat/constants.dart';
import 'package:chat/helper/show_dialog.dart';
import 'package:chat/models/messege.dart';
import 'package:chat/widgets/chat_bubble.dart';
import 'package:chat/widgets/chat_bubble_friend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  static String id = "chatPage";

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController controller = ScrollController();
  final FocusNode focusNode = FocusNode();
  bool showEmojiPicker = false;
  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus && showEmojiPicker) {
        setState(() {
          showEmojiPicker = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map? args = ModalRoute.of(context)?.settings.arguments as Map?;
    if (args == null || args['from'] == null || args['to'] == null) {
      return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: kPrimaryColor,
          title: const Text('Error'),
        ),
        body: const Center(
          child:
              Text('Chat details are missing. Please go back and try again.'),
        ),
      );
    }

    final String from = args['from'];
    final String to = args['to'];
    final String toName = args['name'];
    final String toPhone = args['phone'];
    final CollectionReference messages = FirebaseFirestore.instance
        .collection('messages')
        .doc(getChatId(args['from'], args['to']))
        .collection('messages');

    Future<void> sendMessage(String text) async {
      if (text.trim().isEmpty) return;
      try {
        await messages.add({
          kMessegeDoc: text.trim(),
          kCreatedAt: DateTime.now(),
          'from': from,
          'to': to
        });
        controller.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      } catch (e) {
        if (context.mounted) {
          showAlertDialog(context, 'Failed to send message: ${e.toString()}');
        }
      }
      messageController.clear();
      setState(() => showEmojiPicker = false);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(kCreatedAt, descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 255, 235, 242),
            appBar: AppBar(
              foregroundColor: Colors.white,
              backgroundColor: kPrimaryColor,
              title: Row(
                children: [
                  Column(
                    children: [
                      Text(
                        toName,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Text(
                        toPhone,
                        style: TextStyle(color: Colors.grey[800], fontSize: 15),
                      )
                    ],
                  ),
                ],
              ),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final List<Messege> messagesList = snapshot.data!.docs
            .map((doc) => Messege.fromJson(doc.data() as Map<String, dynamic>))
            .toList();

        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 255, 235, 242),
          appBar: AppBar(
            foregroundColor: Colors.white,
            backgroundColor: kPrimaryColor,
            title: Row(
              children: [
                Column(
                  children: [
                    Text(
                      toName,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Text(
                      toPhone,
                      style: TextStyle(color: Colors.grey[700], fontSize: 15),
                    )
                  ],
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  controller: controller,
                  itemCount: messagesList.length,
                  itemBuilder: (context, index) {
                    final Messege message = messagesList[index];
                    return message.from == from
                        ? chatBubble(message)
                        : chatBubbleForFriend(message);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: focusNode,
                        controller: messageController,
                        onSubmitted: (value) => sendMessage(value),
                        decoration: InputDecoration(
                          hintText: 'Send Message',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: kPrimaryColor),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.emoji_emotions),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          showEmojiPicker = !showEmojiPicker;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      color: kPrimaryColor,
                      onPressed: () => sendMessage(messageController.text),
                    ),
                  ],
                ),
              ),
              if (showEmojiPicker)
                SizedBox(
                  height: 250,
                  child: EmojiPicker(
                    onEmojiSelected: (category, emoji) {
                      messageController.text += emoji.emoji;
                      messageController.selection = TextSelection.fromPosition(
                        TextPosition(offset: messageController.text.length),
                      );
                    },
                    config: const Config(
                      height: 250,
                      checkPlatformCompatibility: true,
                      viewOrderConfig: ViewOrderConfig(),
                      skinToneConfig: SkinToneConfig(),
                      categoryViewConfig: CategoryViewConfig(),
                      bottomActionBarConfig: BottomActionBarConfig(),
                      searchViewConfig: SearchViewConfig(),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  String getChatId(String user1Id, String user2Id) {
    return user1Id.compareTo(user2Id) < 0
        ? '${user1Id}_$user2Id'
        : '${user2Id}_$user1Id';
  }
}
