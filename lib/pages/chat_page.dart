import 'package:capp/components/chat_bubble.dart';
import 'package:capp/components/my_textfield.dart';
import 'package:capp/services/auth/auth_service.dart';
import 'package:capp/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chatpage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  Chatpage({super.key, required this.receiverEmail, required this.receiverID});

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  //text controller
  final TextEditingController _messageController = TextEditingController();

  //chat $ auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  //for text field focus
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //add listener to focus node
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        // cause a delay so that the keyboard has time to show up 
        // then the amount of remaining space will be calaculated, 
        // then scroll down
        Future.delayed(
          const Duration(milliseconds: 500), 
          () => scrollDown(),
        );
      }
    });

    // wait a bit for listView to be built, then scroll down to bottom
    Future.delayed(
      const Duration(
        milliseconds: 500
      ), () => scrollDown(),
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();    
    _messageController.dispose();
    super.dispose();
  }

  // scroll controller
  final ScrollController _scrollController = ScrollController();
  void  scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn, );
  }

  // send message
  void sendMessage() async {
    // if there is something in the text field
    if (_messageController.text.isNotEmpty) {
      // send message
      await _chatService.sendMessage(widget.receiverID, _messageController.text);
      // clear the text field
      _messageController.clear();
    }

    sendMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: Text(widget.receiverEmail),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.grey,
          elevation: 0,
        ),
        body: Column(
          children: [
            //display all messages
            Expanded(child: _buildMessageList()),

            //user input
            _buildUserInput(),
          ],
        ));
  }

  //build message List
  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
        stream: _chatService.getMessages(senderID, widget.receiverID),
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
            controller: _scrollController,
            children: snapshot.data!.docs
                .map((doc) => _buildMessageItem(doc))
                .toList(),
          );
        });
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // is current user
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    // algin to the right if sender is current user, otheriwse left
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(isCurrentUser: isCurrentUser, message: data["message"])
        ],
      ),
    );
  }

  //build message input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          // text field should take most of the space
          Expanded(
            child: MyTextField(
              focusNode: myFocusNode,
              controller: _messageController,
              hintText: "Type a message",
              obscureText: false,
            ),
          ),
          // send button
          Container(
              decoration: const BoxDecoration(
                  color: Colors.green, shape: BoxShape.circle),
              margin: const EdgeInsets.only(right: 25),
              child: IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  onPressed: sendMessage)),
        ],
      ),
    );
  }
}
