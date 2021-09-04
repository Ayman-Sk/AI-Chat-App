// import 'package:chatapp/Models/User.dart';
// import 'package:flutter/material.dart';

// import '/DummyData.dart';
// import '../Screens/ChatScreen.dart';

// class FavoriteContacts extends StatelessWidget {
//   const FavoriteContacts({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Favorite Contacts",
//                   style: TextStyle(
//                     color: Colors.blueGrey,
//                     fontSize: 18.0,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 1.0,
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () {},
//                   icon: Icon(Icons.more_horiz),
//                   iconSize: 30,
//                   color: Colors.blueGrey,
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             height: 120,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               padding: EdgeInsets.only(left: 10),
//               itemCount: favorites.length,
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: InkWell(
//                     onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => ChatScreen(
//                           user: favorites[index],
//                           me: User(id: 2, name: 'Ayman', imageUrl: ''),
//                         ),
//                       ),
//                     ),
//                     child: Column(
//                       children: [
//                         CircleAvatar(
//                           radius: 35.0,
//                           backgroundImage:
//                               AssetImage(favorites[index].imageUrl),
//                         ),
//                         SizedBox(
//                           height: 6,
//                         ),
//                         Text(
//                           favorites[index].name,
//                           style: TextStyle(
//                               color: Colors.blueGrey,
//                               fontSize: 16.0,
//                               fontWeight: FontWeight.w600),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
