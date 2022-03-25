import 'package:chatting_app/pages/login_page.dart';
import 'package:chatting_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  static const String id = 'chat_page';

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late User _activeUser;
  var _auth = FirebaseAuth.instance;
  var _firestore = FirebaseFirestore.instance;
  final _messageTextController = TextEditingController();
  void getCurrentUser() async {
    try {
      var currentUser = await _auth.currentUser;

      if (currentUser != null) {
        _activeUser = currentUser;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _messageTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Room'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Logout',
            onPressed: () async {
              await _auth.signOut();
              Navigator.pushReplacementNamed(context, LoginPage.id);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _firestore
                    .collection('messages')
                    .orderBy('dateCreated', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView(
                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 16.0,
                    ),
                    children: snapshot.data!.docs.map((document) {
                      final messageText = document.data()['text'];
                      final messageSender = document.data()['sender'];
                      return MessageBubble(
                        sender: messageSender,
                        text: messageText,
                        isMyChat: messageSender == _activeUser.email,
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageTextController,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                MaterialButton(
                  child: const Text('SEND'),
                  color: Theme.of(context).primaryColor,
                  textTheme: ButtonTextTheme.primary,
                  onPressed: () {
                    _firestore.collection('messages').add({
                      'text': _messageTextController.text,
                      'sender': _activeUser.email,
                      'dateCreated': Timestamp.now()
                    });
                    _messageTextController.clear();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
