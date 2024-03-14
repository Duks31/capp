import 'package:capp/components/chat_bubble.dart';
import 'package:capp/components/my_textfield.dart';
import 'package:capp/services/auth/auth_service.dart';
import 'package:capp/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chatpage extends StatelessWidget {
  final String receiverEmail;
  final String receiverID;
  
  Chatpage({super.key, required this.receiverEmail, required this.receiverID});

  //text controller
  final TextEditingController _messageController = TextEditingController();

  //chat $ auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  // send message
  void sendMessage() async {
    // if there is something in the text field
    if (_messageController.text.isNotEmpty) {
      // send message
      await _chatService.sendMessage(receiverID, _messageController.text);
      // clear the text field
      _messageController.clear();
    }
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(receiverEmail),),
      body: Column(children: [
        //display all messages
        Expanded(child: _buildMessageList()),

        //user input
        _buildUserInput(),
      ],)
    );
  }

  //build message List

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(senderID, receiverID),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          return const Text("Error");
        }

        // loading...
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        // return list view
        return ListView(
          children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      }
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // is current user
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    // algin to the right if sender is current user, otheriwse left
    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;


    return Container(alignment: alignment,child: Column(
      crossAxisAlignment: isCurrentUser?  CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
        ChatBubble(isCurrentUser: isCurrentUser, message: data["message"])
      ],
    ),);
  }

  //build message input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(children: [
        // text field should take most of the space
        Expanded(child: MyTextField(controller: _messageController, hintText: "Type a message", obscureText: false,),),
        // send button
        Container(
          decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
          margin: const EdgeInsets.only(right: 25),
          child: IconButton(icon: const Icon(Icons.send, color: Colors.white,), onPressed: sendMessage)),
      ],),
    );
  }
}