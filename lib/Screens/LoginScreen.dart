import 'dart:convert';
import 'dart:ui';

import 'package:chatapp/DummyData.dart';
import 'package:chatapp/Screens/RequestsScreen.dart';
import 'package:chatapp/Widget/CategorySelector.dart';
import 'package:flutter/material.dart';

import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

import '../Models/User.dart';
import '../Screens/HomeAppScreen.dart';
import '../Screens/ResetPassword.dart';
import '../Screens/SignupScreen.dart';
import '../DummyData.dart';

class LoginScreen extends StatefulWidget {
  static const LoginScreenRoute = '/LoginScreenRoute';

  // static const String url = 'http://192.168.1.103:5000/login';
  // // static const String url = 'http://192.168.42.130:5000/login';
  // static const String url = 'http://192.168.42.206:5000/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final passwordFocus = FocusNode();

  final userNameFocus = FocusNode();

  final phoneNumberFocus = FocusNode();

  final passwordController = TextEditingController();

  final userNameController = TextEditingController();

  final phoneNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late final User newUser;

  bool _load = false;

  List<Contact> listContacts = [];

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _load
        ? CircularProgressIndicator(
            color: Colors.red,
          )
        : new Container();
    return Scaffold(
      backgroundColor: Color(0xFF212121),
      appBar: AppBar(
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 40.0),
                      child: Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 58,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        'Welcom to our chat app',
                        style: TextStyle(fontSize: 13.5, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(height: 50),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 15, left: 15.0, right: 15.0),
                            child: TextFormField(
                              controller: phoneNumberController,
                              focusNode: phoneNumberFocus,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                labelStyle: TextStyle(color: Colors.red[300]),
                                filled: true,
                                fillColor: Color(0xFF212121),

                                // focusColor: Colors.green,
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Please enter your phone number';
                                return null;
                              },
                              onFieldSubmitted: (_) => FocusScope.of(context)
                                  .requestFocus(passwordFocus),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 0, left: 15.0, right: 15.0),
                            child: TextFormField(
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,
                                controller: passwordController,
                                focusNode: passwordFocus,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(color: Colors.red[300]),
                                  filled: true,
                                  fillColor: Color(0xFF212121),

                                  // focusColor: Colors.green,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.red, width: 2),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.red, width: 2),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.visiblePassword,
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return 'Please enter your password';
                                  return null;
                                },
                                onFieldSubmitted: (_) {
                                  getContact();
                                  getResponse();
                                }),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ResetPasswordScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Forget password ?',
                              style: TextStyle(color: Colors.red[300]),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                bottom: 20.0, left: 20.0, right: 20.0),
                            width: double.maxFinite,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.red),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side:
                                              BorderSide(color: Colors.red)))),
                              onPressed: () {
                                getContact();
                                getResponse();

                                // getResponse().then((_) {
                                // print('vvvvvvvvvvvvvvvvvv' +
                                //     // value.toString() +
                                //     _load.toString());

                                // if (!_load && value) {
                                //   Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (_) => HomeAppScreen(
                                //         me: newUser,
                                //         listContacts: listContacts,
                                //       ),
                                //     ),
                                //   );
                                // }
                                // });
                              },
                              child: Text(
                                'Login',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Divider(
                        thickness: 4,
                        color: Colors.red,
                      ),
                    ),
                    // Center(
                    //     child: SignInButton(Buttons.Google, onPressed: () {})),
                    // Center(
                    //     child: SignInButton(Buttons.FacebookNew,
                    //         onPressed: () {})),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        'Don\'t have an account ?',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SignupScreen(
                              me: User(
                                id: -1,
                                imageUrl: '',
                                name: '',
                                phoneNumber: '',
                              ),
                            ),
                          ),
                        );
                      },
                      child: Text('Sign Up'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            child: loadingIndicator,
            alignment: FractionalOffset.center,
          ),
        ],
      ),
    );
  }

  void login() {
    // List<Contact> contacts =
    //     (await ContactsService.getContacts(withThumbnails: false)).toList();
    // print(contacts.elementAt(0));

    // var client = getClient();
    // try{
    //   client.post(Uri.parse(url), body: {
    //     "username" : userNameController.text,
    //     "password" : passwordController.text,
    //   })..then((response) => null);
    // }
    // newUser = User(
    //     id: 0,
    //     name: userNameController.text,
    //     email: emailController.text,
    //     phoneNumber: phoneNumberController.text,
    //     imageUrl: "");
    // socket = IO.io(url, <String, dynamic>{
    //   "transports": ["websocket"],
    //   "autoConnect": false,
    // });
    // socket.connect();
    // socket.onConnect((data) {
    //   print(data);
    //   socket.emit('join_room', {
    //     'email': emailController.text,
    //     'room': emailController.text,
    //     'password': passwordController.text,
    //   });
    //   // socket.emit('join_room', {
    //   //   "user": newUser.toJson(),
    //   //   "room": newUser.email,
    //   // });

    //   // socket.on('receive_message', (data) {
    //   //   setState(() {
    //   //     newMessage = Message.fromJson(jsonDecode(data['message']));
    //   //   });

    //   //   print(newMessage!.text);
    //   // });
    // });
    // print(socket.connected);
    // socket.on('join_room_announcement', (data) => print(data.toString()));
  }

  // {"title":"Tagliatelle With Purple Sprouting Broccoli, Anchovies And Pecorino"}
  Future<void> getContact() async {
    final PermissionStatus permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      listContacts =
          (await ContactsService.getContacts(withThumbnails: false)).toList();

      // print(listContacts.length);
      // print(listContacts.elementAt(244).displayName);
      // print(listContacts.elementAt(244).phones!.elementAt(0).value);
    }
  }

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ?? PermissionStatus.limited;
    } else {
      return permission;
    }
  }

  Future<void> getResponse() async {
    // if (_formKey.currentState!.validate())
    {
      // setState(() {
      //   _load = true;
      // });
      var client = getClient();
      // print(url + 'login');
      try {
        client.post(Uri.parse(url), body: {
          "title":
             "Tagliatelle With Purple Sprouting Broccoli, Anchovies And Pecorino"
        }

            // {
            //   'phone': phoneNumberController.text,
            //   'password': passwordController.text,
            // }
            )
          ..then((response) {
            print(response.statusCode.toString());
            print('bbbbbbbbbbbbbbb'+response.body);
            Map<String, dynamic> data = jsonDecode(response.body);
            print(data);

            // print(data['response'][3]);
            // if (data['response'] != "null") {
            //   Map<String, dynamic> userData = jsonDecode(data['response']);
            //   // print(userData.toString());
            //   // print(userData['username'].toString());
            //   newUser = User(
            //       id: 0,
            //       name: userData['username'],
            //       phoneNumber: userData['phone_number'],
            //       imageUrl: userData['image']);

            //   setState(() {
            //     _load = false;
            //   });
            //   print(
            //       'dddddddddddddddddooooooooooooooooooocccccccccccccccccttttttttttttttttooooooooooorrrrrrrrr' +
            //           userData['is_doctor'].toString());
            //   if (userData['is_doctor'] == true) {
            //     Navigator.pushReplacement(
            //       context,
            //       MaterialPageRoute(builder: (_) => RequestsScreen(me: newUser)
            //           // CategorySelector(
            //           //   me: newUser,
            //           //   listContacts: listContacts,
            //           // ),
            //           ),
            //     );
            //   }
            // else {
            //   Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(
            //       builder: (_) => HomeAppScreen(
            //         me: newUser,
            //         listContacts: listContacts,
            //       ),
            //     ),
            //   );
            // }
            // } else {
            //   phoneNumberController.clear();
            //   passwordController.clear();
            //   passwordFocus.unfocus();
            //   setState(() {
            //     _load = false;
            //   });
            // }
          });
      } finally {
        client.close();
      }
    }
  }

  http.Client getClient() {
    return http.Client();
  }
}
