import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Screens/LoginScreen.dart';
import 'Provider/Conversation.dart';
import 'Models/Message.dart';
import 'Models/User.dart';
import 'Screens/HomeAppScreen.dart';

void main(List<String> args) => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Conversation()),
        ChangeNotifierProvider.value(
          value: Message(
            sender: User(name: '', phoneNumber: '', imageUrl: '', id: -1),
            text: '',
            time: '',
            isLiked: false,
            isRead: false,
            isImage: false,
          ),
        ),
      ],
      child: MaterialApp(
        title: "ChatApp",
        theme: ThemeData(
          primaryColor: Colors.red,
          accentColor: Color(0XFFFEF9EB),
        ),
        initialRoute: LoginScreen.LoginScreenRoute,
        routes: {
          HomeAppScreen.homeAppScreenRoute: (_) => HomeAppScreen(
              me: User(id: 0, imageUrl: '', name: 's', phoneNumber: '5'),
              listContacts: []),
          LoginScreen.LoginScreenRoute: (_) => LoginScreen(),
        },
      ),
    );
  }
}
