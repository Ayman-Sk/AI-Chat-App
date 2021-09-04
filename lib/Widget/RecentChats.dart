import 'dart:convert';

import 'package:chatapp/Models/User.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:http/http.dart' as http;

import '../DummyData.dart';
import '../Screens/ChatScreen.dart';
import '../Provider/Conversation.dart';

class RecentChats extends StatefulWidget {
  final User me;

  final List<Contact> listContacts;

  RecentChats({required this.me, required this.listContacts});

  // static const String url = 'http://192.168.1.103:5000/check';
  // static const String url = 'http://192.168.42.130:5000/check';

  @override
  _RecentChatsState createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> {
  // bool _load = false;

  @override
  Widget build(BuildContext context) {
    // Widget loadingIndicator = _load
    //     ? CircularProgressIndicator(
    //         color: Colors.red,
    //       )
    //     : new Container();
    final conversation = Provider.of<Conversation>(context);

    return Container(
      decoration: BoxDecoration(
//          color: Colors.white,
        color: Color(0xFF212121),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
//            color: Colors.white,
          color: Color(0xFF212121),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: conversation.getUserLength() > 0
              ? ListView.builder(
                  itemCount: conversation.getUserLength(),
                  itemBuilder: (context, index) {
                    final message = conversation.getUserLastMessage(index);
                    final user = conversation.getUserConversation(index);
                    return InkWell(
                      onTap: () {
                        conversation.setAllMessageRead(user);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(
                              user: user,
                              me: widget.me,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin:
                            EdgeInsets.only(bottom: 5.0, right: 20.0, top: 5.0),
                        decoration: BoxDecoration(
                          color:
                              message.isRead ? Colors.black : Color(0xFFFFEFEE),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        // color: chats[index].unRead ? Color(0xFFFFEFEE) : Colors.white,
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CircleAvatar(
                              radius: 37.0,
                              child: Image.memory(base64Decode(user.imageUrl)),
                            ),
                          ),

                          title: Text(
                            user.name,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: isMe(message.sender.id)
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'You : ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.38,
                                      child: Text(
                                        message.text,
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  message.text,
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                          // Text(
                          //   lastMessageSender(message.sender.id, message.text),
                          //   style: TextStyle(
                          //     color: Colors.blueGrey,
                          //     fontSize: 12.0,
                          //     fontWeight: FontWeight.w600,
                          //   ),
                          //   overflow: TextOverflow.ellipsis,
                          // ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                message.time,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              !message.isRead
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(35),
                                      ),
                                      padding: EdgeInsets.all(5.0),
                                      child: Text(
                                        "New",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : Container(
                                      height: 0,
                                      width: 0,
                                    ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: TextButton(
                      onPressed: checkAllContact,
                      child: Text('Sync your contact')),
                ),
        ),
      ),
    );
  }

  void checkAllContact() {
    int id = 0;
    print("sssss" + widget.listContacts.length.toString());
    widget.listContacts.forEach((element) {
      var client = getClient();
      try {
        if (element.phones!.length > 0) {
          String phoneNumber;
          if (element.phones!.elementAt(0).value![0] == '+') {
            phoneNumber = element.phones!.elementAt(0).value!;
          } else {
            phoneNumber =
                '+963' + element.phones!.elementAt(0).value!.substring(1);
          }
          phoneNumber = phoneNumber.replaceAll(" ", "");
          print(element.displayName);
          print(phoneNumber + '\n\n\n');
          // Provider.of<Conversation>(context, listen: false)
          //     .addNewUserConversation(
          //   User(
          //       id: id++,
          //       name: element.displayName.toString(),
          //       phoneNumber: phoneNumber,
          //       imageUrl: ""),
          // );

          client.post(Uri.parse(url + 'check'), body: {'phone': phoneNumber})
            ..then((response) {
              print(response.statusCode.toString());
              print(response.body);
              Map<String, dynamic> data = jsonDecode(response.body);
              if (data['response'] != "null") {
                Map<String, dynamic> userData = jsonDecode(data['response']);
                if (userData['phone_number'] != widget.me.phoneNumber) {
                  Provider.of<Conversation>(context, listen: false)
                      .addNewUserConversation(
                    User(
                        id: id++,
                        name: userData['username'],
                        phoneNumber: userData['phone_number'],
                        imageUrl: userData['image']),
                  );
                }
              }
            });
        }
      } finally {
        client.close();
      }
    });
    print(Provider.of<Conversation>(context, listen: false).getUserLength());
  }

  http.Client getClient() {
    return http.Client();
  }

  String lastMessageSender(int id, String text) {
    if (id == 0) return "You :" + text;
    return text;
  }

  bool isMe(int id) {
    return id == 0;
  }
}
