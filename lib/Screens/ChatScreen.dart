import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../DummyData.dart';
import '../Models/User.dart';
import '../Models/Message.dart';
import '../Provider/Conversation.dart';

class ChatScreen extends StatefulWidget {
  static const chatScreenRoute = '/ChatScreenRoute';
  final User me;
  final User user;
  ChatScreen({required this.user, required this.me});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  Message? newMessage;

  File? _image;

  late IO.Socket socket;
  // static const String url = 'http://10.0.2.2:5000/';
  // static const String url = 'http://192.168.1.103:5000/';
  // static const String url = 'http://127.0.0.1:5000/';
  // static const String url = 'http://192.168.42.130:5000/';

  @override
  void initState() {
    super.initState();
    // socket = IO.io(url, <String, dynamic>{
    //   "transports": ["websocket"],
    //   "autoConnect": false,
    // });
    socket = IO.io(url, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect();
    socket.onConnect(
      (data) {
        print(data);
        // socket.emit('join_room',
        //     {"username": widget.me.name, "room": widget.me.phoneNumber});
        // socket.emit('join_room',
        //     {"username": widget.user.name, "room": widget.user.phoneNumber});
        socket.on(
          'receive_message',
          (datais) {
            setState(() {
              newMessage = Message.fromJson(jsonDecode(data['message']));
            });

            print(newMessage!.text);
          },
        );
      },
    );
    // print(socket.connected);
    // socket.on('join_room_announcement', (data) => print(data.toString()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final conversation = Provider.of<Conversation>(context);
    if (newMessage != null) {
      conversation.addMessage(widget.user, newMessage!);
      setState(() {
        newMessage = null;
      });
    }
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Center(
          child: Text(
            widget.user.name,
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        elevation: 0.0,
      ),
      body: Container(
        decoration: BoxDecoration(
//          color: Colors.white,
          color: Color(0xFF212121),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: ListView.builder(
                    reverse: true,
                    itemCount: conversation.getUserMesaagesLength(widget.user),
                    itemBuilder: (BuildContext _, int index) {
                      return _buildMessage(
                          conversation.getAllMessage(widget.user)![index]);
                    },
                  ),
                ),
              ),
              Divider(
                color: Colors.red,
                thickness: 3,
              ),
              _buildMessageComposer(),
            ],
          ),
        ),
      ),
    );
  }

  _buildMessage(Message message) {
    // final messages = Provider.of<Message>(ctx);
    final conversation = Provider.of<Conversation>(context);

    final Container msg = Container(
      margin: message.sender.phoneNumber == widget.me.phoneNumber
          ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80.0)
          : EdgeInsets.only(top: 8.0, bottom: 8.0),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.65,
      decoration: BoxDecoration(
        color: message.sender.phoneNumber == widget.me.phoneNumber
            ? Theme.of(context).accentColor
            : Color(0xFFFFEFEE),
        borderRadius: message.sender.phoneNumber == widget.me.phoneNumber
            ? BorderRadius.only(
                bottomLeft: Radius.circular(15.0),
                topLeft: Radius.circular(15.0),
              )
            : BorderRadius.only(
                bottomRight: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.time,
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          message.isImage
              ? Image.memory(base64Decode(message.text))
              : Text(
                  message.text,
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ],
      ),
    );
    if (message.sender.phoneNumber == widget.me.phoneNumber) return msg;
    return Row(
      children: [
        msg,
        IconButton(
          onPressed: () => conversation.toggleFavorite(widget.user, message),
          icon: Icon(
            message.isLiked ? Icons.favorite : Icons.favorite_border_outlined,
            color: message.isLiked
                ? Theme.of(context).primaryColor
                : Colors.blueGrey,
            size: 30.0,
          ),
        )
      ],
    );
  }

  IconButton get micIcon {
    return IconButton(
      onPressed: () {},
      icon: Icon(Icons.mic),
      color: Theme.of(context).primaryColor,
      iconSize: 25.0,
    );
  }

  IconButton get sendIcon {
    // final conversation = Provider.of<Conversation>(context);
    return IconButton(
      onPressed: () {
        // final User currentUser =
        //     User(id: 0, name: 'Current User', imageUrl: 'ima');
        // Message message = Message(
        //     sender: currentUser,
        //     time: DateTime.now().toString(),
        //     text: messageController.text,
        //     unRead: false,
        //     isLiked: false);
        // conversation.addMessage(widget.user.name, message);
      },
      icon: Icon(Icons.send),
      color: Theme.of(context).primaryColor,
      iconSize: 25.0,
    );
  }

  // void addNewMessageHandle() {
  //   final conversation = Provider.of<Conversation>(context);
  //   final User currentUser = User(id: 0, name: 'Current User', imageUrl: 'ima');
  //   Message message = Message(
  //       sender: currentUser,
  //       time: DateTime.now().toString(),
  //       text: messageController.text,
  //       unRead: false,
  //       isLiked: false);
  //   conversation.addMessage(widget.user.name, message);
  // }

  IconButton icon = IconButton(
    onPressed: () {},
    icon: Icon(Icons.mic),
    color: Colors.red,
    iconSize: 25.0,
  );
  _buildMessageComposer() {
    // final conversation = Provider.of<Conversation>(context);
    return Container(
      height: 70.0,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.image),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              getImage();
            },
          ),
          Expanded(
            child: TextField(
              style: TextStyle(color: Colors.white),
              controller: messageController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration.collapsed(
                  hintText: "Send a message...",
                  hintStyle: TextStyle(color: Colors.white38)),
            ),
          ),
          IconButton(
            onPressed: () {
              sendMessage();
              // if (message != null) {
              //   conversation.addMessage(widget.user, message!);
              //   setState(() {
              //     message = null;
              //   });
              // }
              // conversation.addMessage(widget.user, message);
              messageController.clear();
            },
            icon: Icon(Icons.send),
            color: Theme.of(context).primaryColor,
            iconSize: 25.0,
          ),
        ],
      ),
    );
  }

  Future<void> getImage() async {
    final imagePicker = ImagePicker();
    final image = await imagePicker.pickImage(source: ImageSource.gallery);
    // var x = image!.readAsBytes();
    // var y = base64Encode(x);
    // setState(() {
    //   _image = image as File?;
    // });
    _image = File(image!.path);
    List<int> imageBytes = _image!.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    Message message = Message(
      sender: widget.me,
      time: DateFormat('hh:mm a').format(DateTime.now()),
      text: base64Image,
      isRead: true,
      isLiked: false,
      isImage: true,
    );
    Provider.of<Conversation>(context, listen: false)
        .addMessage(widget.user, message);
    String jsonMessage = jsonEncode(message.toJson());
    socket.emit('send_message', {
      'username': widget.me.name,
      'room': widget.user.phoneNumber,
      'message': jsonMessage,
    });
  }

  void reciveMessage(BuildContext context) {
    // socket.on('receive_message', (data) {
    //   Message m = jsonDecode(data['message']);
    //   Provider.of<Conversation>(context).addMessage(widget.user, m);
    // });
  }

  void sendMessage() {
    Message message = Message(
        sender: widget.me,
        time: DateFormat('hh:mm a').format(DateTime.now()),
        text: messageController.text,
        isRead: false,
        isLiked: false,
        isImage: false);
    Provider.of<Conversation>(context, listen: false)
        .addMessage(widget.user, message);
    String jsonMessage = jsonEncode(message.toJson());
    print(jsonMessage);
    socket.emit('send_message', {
      'username': widget.me.name,
      'room': widget.user.phoneNumber,
      'message': jsonMessage,
    });
  }
}
