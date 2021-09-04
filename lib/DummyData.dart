import 'Models/User.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

const String url = 'http://192.168.1.103:5000/';
// const String url = 'http://192.168.43.145:5000/';
// const String url = 'http://192.168.42.16:5000/';
// const String url = 'http://192.168.42.231:5000/';
// const String url = 'http://192.168.42.197:5000/';

// final IO.Socket socket = IO.io(url, <String, dynamic>{
//   "transports": ["websocket"],
//   "autoConnect": false,
// });

// final User currentUser1 = User(
//     id: 0, name: 'Current User', phoneNumber: '+963936309172', imageUrl: 'ima');

// final User rayan = User(
//     id: 1,
//     name: 'Rayan',
//     phoneNumber: '+9639123456789',
//     imageUrl: 'Asset/Images/Rayan.jpg');
// final User obada = User(
//     id: 2, name: 'obada', imageUrl: 'Asset/Images/Obada.jpg', phoneNumber: '');
// final User dania = User(
//     id: 3, name: 'Dania', imageUrl: 'Asset/Images/Dania.jpg', phoneNumber: '');
// final User nada = User(
//     id: 4, name: 'Nada', imageUrl: 'Asset/Images/Nada.jpg', phoneNumber: '');
// final User abd =
//     User(id: 5, name: 'Abd', imageUrl: 'Asset/Images/Abd.jpg', phoneNumber: '');
// final User ayham = User(
//     id: 6, name: 'Ayham', imageUrl: 'Asset/Images/Ayham.jpg', phoneNumber: '');
// final User haya = User(
//     id: 7, name: 'Haya', imageUrl: 'Asset/Images/Haya.jpg', phoneNumber: '');

// List<User> favorites = [obada, nada, ayham, haya, rayan];

// List<Message> chats = [
//   Message(
//     sender: rayan,
//     time: '5:30 PM',
//     text: "Hey, how\'s it going? What did you do today",
//     isLiked: false,
//     isRead: true,
//   ),
//   Message(
//     sender: obada,
//     time: '4:30 PM',
//     text: "Hey, how\'s it going? What did you do today",
//     isLiked: false,
//     isRead: true,
//   ),
//   Message(
//     sender: nada,
//     time: '3:30 PM',
//     text: "Hey, how\'s it going? What did you do today",
//     isLiked: false,
//     isRead: false,
//   ),
//   Message(
//     sender: dania,
//     time: '2:30 PM',
//     text: "Hey, how\'s it going? What did you do today",
//     isLiked: false,
//     isRead: true,
//   ),
//   Message(
//     sender: abd,
//     time: '1:30 PM',
//     text: "Hey, how\'s it going? What did you do today",
//     isLiked: false,
//     isRead: false,
//   ),
//   Message(
//     sender: ayham,
//     time: '12:30 PM',
//     text: "Hey, how\'s it going? What did you do today",
//     isLiked: false,
//     isRead: false,
//   ),
//   Message(
//     sender: haya,
//     time: '11:30 AM',
//     text: "Hey, how\'s it going? What did you do today",
//     isLiked: false,
//     isRead: false,
//   ),
// ];

// List<Message> messages = [
//   Message(
//     sender: rayan,
//     time: '5:30 PM',
//     text: "Hey, how\'s it going? What did you do today",
//     isLiked: true,
//     isRead: false,
//   ),
//   Message(
//     sender: currentUser,
//     time: '4:30 PM',
//     text: "Just walked my dog. She was super duper cute. The best pupper",
//     isLiked: false,
//     isRead: true,
//   ),
//   Message(
//     sender: rayan,
//     time: '3:45 PM',
//     text: "How\'s the doggo?",
//     isLiked: false,
//     isRead: true,
//   ),
//   Message(
//     sender: rayan,
//     time: '3:45 PM',
//     text: "All the food",
//     isLiked: true,
//     isRead: true,
//   ),
//   Message(
//     sender: currentUser,
//     time: '2:30 PM',
//     text: "Nice! What kind of food did you eat?",
//     isLiked: false,
//     isRead: true,
//   ),
//   Message(
//     sender: rayan,
//     time: '2:30 PM',
//     text: "I ate so much food today.",
//     isLiked: false,
//     isRead: false,
//   ),
// ];
// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:ui_flutter/core/consts.dart';

// class SimpleTab extends StatefulWidget {
//     static const routeName = '/SimpleTab';
//     @override
//     _SimpleTabState createState() => _SimpleTabState();
// }

// class _SimpleTabState extends State<SimpleTab> {
//     @override
//     Widget build(BuildContext context) {
//         return SafeArea(
//             child: DefaultTabController(
//                 length: 3,
//                 child: Scaffold(
//                     appBar: AppBar(
//                         title: Text("Simple Tab",style: TextStyle(color: Colors.black),),
//                         bottom: TabBar(
//                             tabs: <Widget>[
//                                 Tab(
//                                     child: Text('Home',style: TextStyle(color: Colors.black)),
//                                 ),
//                                 Tab(
//                                     child: Text('Favorite',style: TextStyle(color: Colors.black)),
//                                 ),
//                                 Tab(
//                                     child: Text('Settings',style: TextStyle(color: Colors.black)),
//                                 ),
//                             ],
//                         ),
//                     ),
//                     body: TabBarView(
//                         children: <Widget>[
//                             Container(
//                                 decoration: BoxDecoration(
//                                     image: DecorationImage(
//                                         colorFilter: ColorFilter.mode(
//                                             Colors.pinkAccent.withOpacity(0.4), BlendMode.darken),
//                                         image:  NetworkImage(
//                                             Constants.images[
//                                             Random().nextInt(Constants.images.length)],
//                                         ),
//                                         fit: BoxFit.cover),
//                                 ),
//                                 child: Center(
//                                     child: Text(
//                                         "Home",
//                                         style: TextStyle(color: Colors.white, fontSize: 30.0),
//                                     ),
//                                 ),
//                             ),
//                             Container(
//                                 decoration: BoxDecoration(
//                                     image: DecorationImage(
//                                         colorFilter: ColorFilter.mode(
//                                             Colors.yellow.withOpacity(0.4), BlendMode.darken),
//                                         image: NetworkImage(
//                                             Constants.images[
//                                             Random().nextInt(Constants.images.length)],
//                                         ),
//                                         fit: BoxFit.cover),
//                                 ),
//                                 child: Center(
//                                     child: Text(
//                                         "Favorite",
//                                         style: TextStyle(color: Colors.white, fontSize: 30.0),
//                                     ),
//                                 ),
//                             ),
//                             Container(
//                                 decoration: BoxDecoration(
//                                     image: DecorationImage(
//                                         colorFilter: ColorFilter.mode(
//                                             Colors.orangeAccent.withOpacity(0.4),
//                                             BlendMode.darken),
//                                         image:  NetworkImage(
//                                             Constants.images[
//                                             Random().nextInt(Constants.images.length)],
//                                         ),
//                                         fit: BoxFit.cover),
//                                 ),
//                                 child: Center(
//                                     child: Text(
//                                         "Settings",
//                                         style: TextStyle(color: Colors.white, fontSize: 30.0),
//                                     ),
//                                 ),

//                             ),
//                         ],
//                     ),
//                 ),
//             ),
//         );
//     }
// }


// import 'package:flutter/material.dart';
//
// class CategorySelector extends StatefulWidget {
//     bool isDoctor;
//
//     CategorySelector({this.isDoctor = false});
//
//     @override
//     _CategorySelectorState createState() => _CategorySelectorState();
// }
//
// class _CategorySelectorState extends State<CategorySelector> {
//     int selectedIndex = 0;
//     final List<String> category = ['Messages'];
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
//                     length: widget.isDoctor ? 1 : 2,
//                     child: Scaffold(
//                         appBar: AppBar(
//                             title: Text(
//                                 "Chat",
//                                 style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//                             ),
//                             bottom: TabBar(
//                                 tabs: widget.isDoctor
//                                     ? <Widget>[
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
//                             children: <Widget>[
//                                 Container(
//
//                                     child: Center(
//                                         child: Text(
//                                             "Home",
//                                             style: TextStyle(color: Colors.white, fontSize: 30.0),
//                                         ),
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
