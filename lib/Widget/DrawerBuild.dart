import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../DummyData.dart';
import '../Models/User.dart';
import '../Screens/LoginScreen.dart';
import '../Screens/SignupScreen.dart';

class DrawerBuild extends StatefulWidget {
  final User me;

  DrawerBuild({required this.me});

  @override
  _DrawerBuildState createState() => _DrawerBuildState();
}

class _DrawerBuildState extends State<DrawerBuild> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 20,
      child: Container(
        height: 100,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              color: Colors.red,
              child: DrawerHeader(
                child: Center(
                  child: Text(
                    "Chat App",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 36,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Divider(
              height: 0,
              color: Colors.red,
              thickness: 1,
            ),
            Container(
              color: Colors.black38,
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit profile'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => SignupScreen(me: widget.me)),
                  );
                },
              ),
            ),
            Divider(
              height: 0,
              color: Colors.red,
              thickness: 1,
            ),
            Container(
              color: Colors.black38,
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => LoginScreen()));
                },
              ),
            ),
            Divider(
              height: 0,
              color: Colors.red,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getResponse() async {
    var client = getClient();
    try {
      client.post(Uri.parse(url + 'logout'), body: {'username': widget.me.name})
        ..then((response) {
          // print(response.statusCode.toString());
          print(response.body);
          Map<String, dynamic> data = jsonDecode(response.body);

          // print(data['response'][3]);
          if (data['response'] == "done") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LoginScreen()),
            );
          }
        });
    } finally {
      client.close();
    }
  }
}

http.Client getClient() {
  return http.Client();
}
