import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

import '../DummyData.dart';
import '../Models/User.dart';
import '../Screens/HomeAppScreen.dart';

class SignupScreen extends StatefulWidget {
  static const LoginScreenRoute = '/LoginScreenRoute';

  final User me;
  SignupScreen({required this.me});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final userNameFocus = FocusNode();

  final passwordFocus = FocusNode();

  final confirmPasswordFocus = FocusNode();

  final numberFocus = FocusNode();

  final userNameController = TextEditingController();

  String name = '';

  final passwordController = TextEditingController();

  String password = '';

  final confirmPasswordController = TextEditingController();

  String confirmPassword = '';

  final numberController = TextEditingController();

  String number = '';

  final _formKey = GlobalKey<FormState>();

  late User newUser;

  late IO.Socket socket;

  bool _load = false;

  bool _isSetImage = false;

  Image? _image;

  String base64Image = '';

  List<Contact> listContacts = [];

  @override
  Widget build(BuildContext context) {
    // widget.me.name = 'Ayman';
    // widget.me.phoneNumber = '+963936309172';
    if (widget.me.imageUrl.isNotEmpty) {
      base64Image = widget.me.imageUrl;
      _image = Image.memory(base64Decode(widget.me.imageUrl));
    }

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
                        widget.me.phoneNumber.isEmpty
                            ? 'Signup'
                            : 'Edit profile',
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
                    Container(
                      height: 150,
                      child: Stack(
                        children: [
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CircleAvatar(
                                backgroundColor: Colors.black,
                                radius: 75,
                                child: widget.me.imageUrl.isNotEmpty
                                    ? _image
                                    : !_isSetImage
                                        ? Image.asset('Asset/Images/user.png')
                                        : _image,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: IconButton(
                              icon: Icon(
                                Icons.photo,
                                color: Colors.black,
                              ),
                              onPressed: () async {
                                final imagePicker = ImagePicker();
                                final image = await imagePicker.pickImage(
                                    source: ImageSource.gallery);
                                final fileImage = File(image!.path);
                                List<int> imageBytes =
                                    await fileImage.readAsBytes();
                                base64Image = base64Encode(imageBytes);
                                print("basssssssssssssssssse" + base64Image);
                                setState(() {
                                  _image =
                                      Image.memory(base64Decode(base64Image));
                                  _isSetImage = true;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
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
                              initialValue: widget.me.phoneNumber.isNotEmpty
                                  ? widget.me.name
                                  : null,
                              controller: widget.me.phoneNumber.isNotEmpty
                                  ? null
                                  : userNameController,
                              focusNode: userNameFocus,
                              style: TextStyle(color: Colors.white),
                              onChanged: (value) {
                                name = value;
                                print(value);
                                print(name);
                              },
                              decoration: InputDecoration(
                                labelText: 'User Name',
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
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Please enter your name';
                                return null;
                              },
                              onFieldSubmitted: (_) =>
                                  widget.me.phoneNumber.isNotEmpty
                                      ? getResponse('Update')
                                      : FocusScope.of(context)
                                          .requestFocus(numberFocus),
                            ),
                          ),
                          widget.me.phoneNumber.isNotEmpty
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 15, left: 15.0, right: 15.0),
                                  child: TextFormField(
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    controller: numberController,
                                    focusNode: numberFocus,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      labelText: 'Phone number',
                                      labelStyle:
                                          TextStyle(color: Colors.red[300]),
                                      filled: true,
                                      fillColor: Color(0xFF212121),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.red, width: 2),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.red, width: 2),
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
                                    onFieldSubmitted: (_) =>
                                        FocusScope.of(context)
                                            .requestFocus(passwordFocus),
                                  ),
                                ),
                          widget.me.phoneNumber.isNotEmpty
                              ? Container()
                              : Padding(
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
                                      labelText: 'Password',
                                      labelStyle:
                                          TextStyle(color: Colors.red[300]),
                                      filled: true,
                                      fillColor: Color(0xFF212121),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.red, width: 2),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.red, width: 2),
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
                                    onFieldSubmitted: (_) =>
                                        FocusScope.of(context)
                                            .requestFocus(confirmPasswordFocus),
                                  ),
                                ),
                          widget.me.phoneNumber.isNotEmpty
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 15, left: 15.0, right: 15.0),
                                  child: TextFormField(
                                    obscureText: true,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    controller: confirmPasswordController,
                                    focusNode: confirmPasswordFocus,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      labelText: 'Re-Enter Password',
                                      labelStyle:
                                          TextStyle(color: Colors.red[300]),
                                      filled: true,
                                      fillColor: Color(0xFF212121),

                                      // focusColor: Colors.green,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.red, width: 2),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.red, width: 2),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.visiblePassword,
                                    validator: (value) {
                                      if (value == null || value.isEmpty)
                                        return 'Please confirm your password';
                                      return null;
                                    },
                                    onFieldSubmitted: (_) =>
                                        FocusScope.of(context)
                                            .requestFocus(confirmPasswordFocus),
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
                                widget.me.phoneNumber.isEmpty
                                    ? getResponse('Signup')
                                    : getResponse('Update');
                              },
                              child: Text(
                                widget.me.phoneNumber.isEmpty
                                    ? 'Signup'
                                    : 'Update',
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

  Future<void> getContact() async {
    final PermissionStatus permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      listContacts =
          (await ContactsService.getContacts(withThumbnails: false)).toList();
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

  Future<void> getResponse(String state) async {
    if (base64Image.isEmpty) {
      final fileImage = File('Asset/Images/user.png');
      List<int> imageBytes = await fileImage.readAsBytes();
      base64Image = base64Encode(imageBytes);
    }
    if (state == 'Signup') {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _load = true;
        });
        var client = getClient();
        try {
          client.post(Uri.parse(url + 'signup'), body: {
            'username': userNameController.text,
            'password': passwordController.text,
            'phone': numberController.text,
            'image': base64Image,
          })
            ..then((response) {
              Map<String, dynamic> data = jsonDecode(response.body);
              if (data['response'] == "done") {
                newUser = User(
                  id: 0,
                  name: userNameController.text,
                  phoneNumber: numberController.text,
                  imageUrl: base64Image,
                );
                setState(() {
                  _load = false;
                });
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomeAppScreen(
                      me: newUser,
                      listContacts: listContacts,
                    ),
                  ),
                );
              } else {
                userNameController.clear();
                passwordController.clear();
                passwordFocus.unfocus();
                setState(() {
                  _load = false;
                });
              }
            });
        } finally {
          client.close();
        }
      }
    } else {
      var client = getClient();
      try {
        client.post(Uri.parse(url + 'update'), body: {
          'username': name,
          'phone': widget.me.phoneNumber,
          'image': base64Image,
        })
          ..then((response) {
            Map<String, dynamic> data = jsonDecode(response.body);
            if (data['response'] == "done") {
              newUser = User(
                id: 0,
                name: name,
                phoneNumber: widget.me.phoneNumber,
                imageUrl: base64Image,
              );
              setState(() {
                _load = false;
              });
              // print(userData['username'].toString());
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => HomeAppScreen(
                    me: newUser,
                    listContacts: listContacts,
                  ),
                ),
              );
            } else {
              userNameController.clear();
              passwordController.clear();
              passwordFocus.unfocus();
              setState(() {
                _load = false;
              });
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
}
