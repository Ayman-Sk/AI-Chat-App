import 'dart:ui';

import 'package:contacts_service/contacts_service.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

import '../DummyData.dart';
import '../Models/User.dart';
import '../Screens/LoginScreen.dart';

import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const ResetPasswordScreenRoute = '/ResetPasswordScreenRoute';

  // static const String url = 'http://192.168.1.103:5000/reset';
  // static const String url = 'http://192.168.42.130:5000/reset';

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final passwordFocus = FocusNode();

  final confirmPasswordFocus = FocusNode();

  final userNameFocus = FocusNode();

  final phoneNumberFocus = FocusNode();

  final passwordController = TextEditingController();

  final userNameController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  final phoneNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late final User newUser;

  late IO.Socket socket;

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
                        'Reset Password',
                        style: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 20.0),
                    //   child: Text(
                    //     'Welcom to our chat app',
                    //     style: TextStyle(fontSize: 13.5, color: Colors.white),
                    //   ),
                    // ),
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
                                labelText: 'Phone number',
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
                                bottom: 15, left: 15.0, right: 15.0),
                            child: TextFormField(
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,
                                controller: passwordController,
                                focusNode: passwordFocus,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'New Password',

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
                                onFieldSubmitted: (_) => FocusScope.of(context)
                                    .requestFocus(confirmPasswordFocus)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 20, left: 15.0, right: 15.0),
                            child: TextFormField(
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,
                                controller: confirmPasswordController,
                                focusNode: confirmPasswordFocus,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Re-Enter New Password',

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
                                  if (value == null ||
                                      value.isEmpty ||
                                      value != passwordController.text)
                                    return 'Please enter your password';
                                  return null;
                                },
                                onFieldSubmitted: (_) => getResponse()),
                          ),
                          // TextButton(
                          //   onPressed: () {},
                          //   child: Text(
                          //     'Forget password ?',
                          //     style: TextStyle(color: Colors.red[300]),
                          //   ),
                          // ),
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
                                // getContact();
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
                                'Reset Password',
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
                      child: Text('Don\'t have an account ?',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center),
                    ),
                    TextButton(
                      onPressed: () {},
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

  Future<void> getResponse() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _load = true;
      });
      var client = getClient();
      try {
        client.post(Uri.parse(url + 'reset'), body: {
          'phone': phoneNumberController.text,
          'password': passwordController.text,
        })
          ..then(
            (response) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => LoginScreen(),
                ),
              );
              // print(response.statusCode.toString());
              // print(response.body);
              // Map<String, dynamic> data = jsonDecode(response.body);

              // // print(data['response'][3]);
              // if (data['response'] != "null") {
              //   Map<String, dynamic> userData = jsonDecode(data['response']);
              //   // print(userData.toString());
              //   // print(userData['username'].toString());
              //   newUser = User(
              //       id: 0,
              //       name: userData['username'],
              //       phoneNumber: userData['phone_number'],
              //       imageUrl: "");
              //   setState(() {
              //     _load = false;
              //   });
              //   Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //       builder: (_) => HomeAppScreen(
              //         me: newUser,
              //         listContacts: listContacts,
              //       ),
              //     ),
              //   );
              // } else {
              //   userNameController.clear();
              //   passwordController.clear();
              //   passwordFocus.unfocus();
              // }
            },
          );
      } finally {
        client.close();
        setState(() {
          _load = false;
        });
      }
    }
  }

  http.Client getClient() {
    return http.Client();
  }
}



    // return new Scaffold(
    //   backgroundColor: Colors.white,
    //   body:  new Stack(children: <Widget>[new Padding(
    //     padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
    //     child: new ListView(

    //       children: <Widget>[
    //         new Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           crossAxisAlignment: CrossAxisAlignment.center
    //           ,children: <Widget>[
    //         new TextField(),
    //         new TextField(),

    //         new FlatButton(color:Colors.blue,child: new Text('Sign In'),
    //             onPressed: () {
    //           setState((){
    //             _load=true;
    //           });

    //               //Navigator.of(context).push(new MaterialPageRoute(builder: (_)=>new HomeTest()));
    //             }
    //         ),

    //         ],),],
    //     ),),
    //     new Align(child: loadingIndicator,alignment: FractionalOffset.center,),

    //   ],));
