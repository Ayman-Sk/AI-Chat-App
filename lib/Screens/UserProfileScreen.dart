import 'dart:convert';

import 'package:flutter/material.dart';

import '../Models/User.dart';

// ignore: must_be_immutable
class UserProfileScreen extends StatelessWidget {
  final User user;
  final String suciedMessage;
  final String rate;
  UserProfileScreen(
      {required this.user, required this.suciedMessage, required this.rate});
  Image? _image;

  @override
  Widget build(BuildContext context) {
    _image = Image.memory(base64Decode(user.imageUrl));
    return Scaffold(
      backgroundColor: Color(0xFF212121),
      appBar: AppBar(
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            height: 150,
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(150),
              ),
            ),
            // child: Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Padding(
            //       padding:
            //           const EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0),
            //       child: Text(
            //         widget.me.phoneNumber.isEmpty ? 'Signup' : 'Edit profile',
            //         style: TextStyle(
            //             fontSize: 58,
            //             fontWeight: FontWeight.bold,
            //             color: Colors.white),
            //       ),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.only(left: 20.0),
            //       child: Text(
            //         'Welcom to our chat app',
            //         style: TextStyle(fontSize: 13.5, color: Colors.white),
            //       ),
            //     ),
            //   ],
            // ),
          ),
          Expanded(
            child: ListView(
              children: [
                SizedBox(height: 20),
                Container(
                  height: 150,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 75,
                        child: _image,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Username : ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      user.name,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Phone Number : ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      user.phoneNumber,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Suicide Message : ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ]),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    suciedMessage,
                    overflow: TextOverflow.visible,
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Our System Rate : ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      rate + " %",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Divider(
                    thickness: 4,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
