import 'dart:convert';

import 'package:chatapp/Models/Message.dart';
import 'package:chatapp/Models/User.dart';
import 'package:chatapp/Provider/Conversation.dart';
import 'package:chatapp/Widget/RecentChats.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Screens/RequestsScreen.dart';
import '../DummyData.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// ignore: must_be_immutable
class CategorySelector extends StatefulWidget {
  static const categorySelectorRoute = '/HomeAppScreenRoute';
  final bool isDoctor;
  final User me;
  late List<Contact> listContacts;
  CategorySelector(
      {this.isDoctor = false, required this.me, required this.listContacts});

  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  late List<Widget> _screen;
  late IO.Socket socket;

  Message? newMessage;
  @override
  void initState() {
    super.initState();
    _screen = [
      RecentChats(me: widget.me, listContacts: widget.listContacts),
      RequestsScreen(
        me: widget.me,
      ),
    ];
    socket = IO.io(url, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });

    socket.connect();
    socket.onConnect(
      (data) {
        socket.emit('join_room',
            {"username": widget.me.name, "room": widget.me.phoneNumber});
        socket.on(
          'receive_message',
          (data) {
            setState(
              () {
                newMessage = Message.fromJson(jsonDecode(data['message']));
              },
            );
          },
        );
      },
    );
  }

  int _selectedScreenIndex = 0;
  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final conversation = Provider.of<Conversation>(context);
    if (newMessage != null) {
      conversation.addMessage(newMessage!.sender, newMessage!);
      setState(() {
        newMessage = null;
      });
    }

    return Scaffold(
        backgroundColor: Colors.red,
        appBar: AppBar(
          title: Center(
            child: Text(
              "Chat",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
          elevation: 0,
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: _selectScreen,
          backgroundColor: Theme.of(context).primaryColor,
          selectedItemColor: Colors.white,
          unselectedItemColor: Theme.of(context).accentColor,
          currentIndex: _selectedScreenIndex,
          type: BottomNavigationBarType.shifting,
          items: [
            BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.message),
              label: 'Message',
            ),
            BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.request_page),
              label: 'Request',
            ),
          ],
        ),
        body: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Expanded(child: _screen[_selectedScreenIndex])
          ],
        ));
  }
}
