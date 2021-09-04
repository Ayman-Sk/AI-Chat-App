import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'User.dart';

class Message with ChangeNotifier {
  User sender;
  String time;
  String text;
  bool isRead;
  bool isLiked;
  bool isImage;

  Message({
    required this.sender,
    required this.time,
    required this.text,
    required this.isRead,
    required this.isLiked,
    required this.isImage,
  });

  void toggleLiked() {
    this.isLiked = !isLiked;
    notifyListeners();
  }

  Map<String, dynamic> toJson() => {
        'sender': sender.toJson(),
        'time': time,
        'text': text,
        'isRead': isRead,
        'isLiked': isLiked,
        'isImage': isImage,
      };

  Message.fromJson(Map<String, dynamic> json)
      : sender = User.fromJson(json['sender']),
        time = json['time'],
        text = json['text'],
        isRead = json['isRead'],
        isLiked = json['isLiked'],
        isImage = json['isImage'];

  File readMessage() {
    List<int> imageBytes = base64Decode(this.text);
    File file = File('ayman.jpg');
    file.writeAsBytesSync(imageBytes);
    return file;
  }
}
