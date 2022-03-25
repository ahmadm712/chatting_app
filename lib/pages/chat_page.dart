import 'package:chatting_app/pages/login_page.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  static const String id = 'chat_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room'),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            tooltip: 'Logout',
            onPressed: () =>
                Navigator.pushReplacementNamed(context, LoginPage.id),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Placeholder(),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                MaterialButton(
                  child: Text('SEND'),
                  color: Theme.of(context).primaryColor,
                  textTheme: ButtonTextTheme.primary,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
