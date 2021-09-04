import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:contacts_service/contacts_service.dart';
import 'package:provider/provider.dart';

import '../Widget/RecentChats.dart';
import '../Models/User.dart';
import '../Widget/DrawerBuild.dart';
import '../DummyData.dart';
import '../Models/Message.dart';
import '../Provider/Conversation.dart';

class HomeAppScreen extends StatefulWidget {
  static const homeAppScreenRoute = '/HomeAppScreenRoute';

  // static const String url = 'http://192.168.1.103:5000/check';
  // static const String url = 'http://192.168.42.130:5000/check';

  final User me;

  final List<Contact> listContacts;

  HomeAppScreen({required this.me, required this.listContacts});

  @override
  _HomeAppScreenState createState() => _HomeAppScreenState();
}

class _HomeAppScreenState extends State<HomeAppScreen> {
  Message? newMessage;
  late IO.Socket socket;
  @override
  void initState() {
    super.initState();
    print("AyyyyyyyyyyyyyyyyyyyyyyyyyMaN" + widget.me.name);
    socket = IO.io(url, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect();
    socket.onConnect(
      (data) {
        print(data);
        socket.emit('join_room',
            {"username": widget.me.name, "room": widget.me.phoneNumber});
        socket.on(
          'receive_message',
          (data) {
            setState(() {
              newMessage = Message.fromJson(jsonDecode(data['message']));
              print('Sssssssssssoooooooooockkkkettt' + newMessage!.text);
            });
          },
        );
      },
    );
    // getContact();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // checkAllContact();
  }

  @override
  Widget build(BuildContext context) {
    final conversation = Provider.of<Conversation>(context);
    if (newMessage != null) {
      print(newMessage!.sender.name);
      print(newMessage!);
      conversation.addMessage(newMessage!.sender, newMessage!);
      setState(() {
        newMessage = null;
      });
    }

    return Scaffold(
      drawer: DrawerBuild(me: widget.me),
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Center(
          child: Text(
            "Chat",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        elevation: 0,
      ),
      body: RecentChats(
        me: widget.me,
        listContacts: widget.listContacts,
      ),
    );
  }
}
