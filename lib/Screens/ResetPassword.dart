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
                                  .requestFocus(confirmPasswordFocus),
                            ),
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
                                getResponse();
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
