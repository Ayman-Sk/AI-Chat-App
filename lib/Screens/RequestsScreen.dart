import 'dart:convert';

import 'package:chatapp/Models/Message.dart';
import 'package:chatapp/Models/User.dart';
import 'package:chatapp/Provider/Conversation.dart';
import 'package:chatapp/Screens/UserProfileScreen.dart';
import 'package:chatapp/Widget/DrawerBuild.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../DummyData.dart';

class RequestsScreen extends StatefulWidget {
  final User me;

  RequestsScreen({required this.me});

  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  late IO.Socket socket;
  Message? newMessage;
  late String rate = '';

  @override
  void initState() {
    super.initState();
    socket = IO.io(url, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect();
    socket.onConnect((data) {
      print(data);
      socket.emit('join_room',
          {"username": widget.me.name, "room": widget.me.phoneNumber});
      socket.on('receive_message', (data) {
        setState(() {
          newMessage = Message.fromJson(jsonDecode(data['message']));
          rate = data['rate'];
        });

        print(newMessage!.text);
      });
    });
    print(socket.connected);
    socket.on('join_room_announcement', (data) => print(data.toString()));
  }

  @override
  Widget build(BuildContext context) {
    final conversation = Provider.of<Conversation>(context);
    final request = conversation.getAlRequest();
    if (newMessage != null) {
      conversation.addRequest(newMessage!);
      setState(() {
        newMessage = null;
      });
    }
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Request'),
        elevation: 0,
      ),
      drawer: DrawerBuild(
        me: widget.me,
      ),
      body: Container(
        decoration: BoxDecoration(
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
          child: ListView.builder(
            itemCount: request.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  conversation.readRequest(index);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UserProfileScreen(
                        user:
                            conversation.getAlRequest().elementAt(index).sender,
                        suciedMessage:
                            conversation.getAlRequest().elementAt(index).text,
                        rate: rate,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 5.0, right: 20.0, top: 5.0),
                  decoration: BoxDecoration(
                    color: request.elementAt(index).isRead
                        ? Colors.black
                        : Color(0xFFFFEFEE),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      request.elementAt(index).text,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      request.elementAt(index).sender.name,
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          request.elementAt(index).time,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        !request.elementAt(index).isRead
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
          ),
        ),
      ),
    );
  }
}
