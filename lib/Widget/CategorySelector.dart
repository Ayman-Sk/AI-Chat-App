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
      print(newMessage!.sender.name);
      print(newMessage!);
      conversation.addMessage(newMessage!.sender, newMessage!);
      setState(() {
        newMessage = null;
      });
    }

    return Scaffold(
        backgroundColor: Colors.red,
        appBar: AppBar(
          // leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
          title: Center(
            child: Text(
              "Chat",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
          elevation: 0,
        ),
        // drawer: Drawer(
        //     child: BuildDrawer(),
        // ),

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
            ]),
        body: Column(
          children: [
            SizedBox(
              height: 20,

//          color: Colors.white,
            ),
            Expanded(child: _screen[_selectedScreenIndex])
          ],
        ));
  }
}


//
//     @override
//     Widget build(BuildContext context) {
//         if (widget.isDoctor) category.add('Request');
//         return Container(
//             height: 100,
//             width: MediaQuery.of(context).size.width,
//             color: Theme.of(context).primaryColor,
//             child: SafeArea(
//                 child: DefaultTabController(
//                     length: widget.isDoctor ? 2 : 1,
//                     child: Scaffold(
//                         appBar: AppBar(
//                             title: Text(
//                                 "Chat",
//                                 style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//                             ),
//                             bottom: TabBar(
//                                 tabs: widget.isDoctor
//                                     ? <Widget>[
//                                     TabBar(
//                                         tabs: [],
//                                         child: Text(
//                                             'Message',
//                                             style: TextStyle(
//                                                 letterSpacing: 1.0,
//                                                 fontSize: 22,
//                                                 color: Colors.white,
//                                             ),
//                                         ),
//                                     ),
//                                     Tab(
//                                         child: Text(
//                                             'Request',
//                                             style: TextStyle(
//                                                 letterSpacing: 1.0,
//                                                 fontSize: 22,
//                                                 color: Colors.white,
//                                             ),
//                                         ),
//                                     ),
//                                 ]
//                                     : <Widget>[
//                                     Tab(
//                                         child: Text(
//                                             'Message',
//                                             style: TextStyle(
//                                                 letterSpacing: 1.0,
//                                                 fontSize: 22,
//                                                 color: Colors.white,
//                                             ),
//                                         ),
//                                     ),
//                                 ]),
//                         ),
//                         body: TabBarView(
//                           controller: TabController(initialIndex: 0,length: widget.isDoctor?2:1, vsync: ),
//                             children: <Widget>[
//                                 Container(
//
//                                     child: Center(
//                                         child: Text(
//                                             "Home",
//                                             style: TextStyle(color: Colors.white, fontSize: 30.0),
//                                         ),
//
//                                     ),
//                                 ),
//                                 Container(
//
//                                     child: Center(
//                                         child: Text(
//                                             "Favorite",
//                                             style: TextStyle(color: Colors.white, fontSize: 30.0),
//                                         ),
//                                     ),
//                                 ),
//
//                             ],
//                         ),
//                     ),
//                 ),
//             )
//             // Center(
//             //   child: Text(
//             //     'Message',
//             //     style: TextStyle(
//             //       letterSpacing: 1.0,
//             //       fontSize: 22,
//             //       color: Colors.white,
//             //     ),
//             //   ),
//             // )
//             // ListView.builder(
//             //
//             //   scrollDirection: Axis.horizontal,
//             //   itemCount: category.length,
//             //   padding: const EdgeInsets.all(8.0),
//             //   itemBuilder: (context, index) => InkWell(
//             //     onTap: () {
//             //       setState(() {
//             //         selectedIndex = index;
//             //       });
//             //     },
//             //     child: Padding(
//             //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
//             //       child: Text(
//             //         category[index],
//             //         style: TextStyle(
//             //           letterSpacing: 1.0,
//             //           fontSize: 22,
//             //           color: selectedIndex == index ? Colors.white : Colors.white60,
//             //         ),
//             //       ),
//             //     ),
//             //   ),
//             // ),
//         );
//     }
// }
