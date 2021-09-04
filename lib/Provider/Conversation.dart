// import 'package:chatapp/DummyData.dart';
import 'package:flutter/material.dart';

import '../Models/Message.dart';
import '../Models/User.dart';

class Conversation with ChangeNotifier {
  late final User currentUser;
  final Map<User, List<Message>> _conversationsData = {};
  final List<Message> _request = [];

  void readRequest(int index) {
    _request.elementAt(index).isRead = true;
    notifyListeners();
  }

  void addRequest(Message message) {
    _request.add(message);
    notifyListeners();
  }

  int getRequestsLength() {
    return _request.length;
  }

  List<Message> getAlRequest() {
    return _request;
  }

  void setThisUser(User thisUser) {
    currentUser = thisUser;
  }

  void addNewUserConversation(User newUser) {
    _conversationsData.putIfAbsent(newUser, () => []);
    notifyListeners();
  }

  bool hasNumber(User user) {
    bool has = false;
    _conversationsData.forEach((key, value) {
      if (key.phoneNumber == user.phoneNumber) has = true;
    });
    notifyListeners();
    return has;
  }

  User getKey(User user) {
    User returnUser = User(id: 0, name: '', phoneNumber: '', imageUrl: '');
    _conversationsData.forEach((key, value) {
      if (key.phoneNumber == user.phoneNumber) returnUser = key;
    });
    notifyListeners();
    return returnUser;
  }

  void addMessage(User userSender, Message newMessage) {
    if (hasNumber(userSender)) {
      _conversationsData[getKey(userSender)]!.insert(0, newMessage);
    }

    notifyListeners();
  }

  List<Message>? getAllMessage(User user) {
    return _conversationsData[user];
  }

  int getUserMesaagesLength(User user) {
    if (!_conversationsData.containsKey(user)) addNewUserConversation(user);
    return _conversationsData[user]!.length;
  }

  int getUserLength() {
    return _conversationsData.length;
  }

  User getUserConversation(int index) {
    return _conversationsData.keys.elementAt(index);
  }

  void toggleFavorite(User userSender, Message message) {
    _conversationsData[userSender]!.forEach((element) {
      if (element == message) element.toggleLiked();
    });
    notifyListeners();
  }

  void setAllMessageRead(User user) {
    _conversationsData[user]!.forEach((element) {
      element.isRead = true;
    });
    notifyListeners();
  }

  Message getUserLastMessage(int index) {
    if (_conversationsData[getUserByIndex(index)]!.isEmpty)
      return Message(
        sender: User(id: -1, name: '', phoneNumber: '', imageUrl: ''),
        time: '',
        text: '',
        isRead: true,
        isLiked: false,
        isImage: false,
      );
    else
      return _conversationsData[getUserByIndex(index)]!.first;
  }

  String getLastUserMessageText(int index) {
    return _conversationsData[getUserByIndex(index)]!.first.text;
  }

  String getLastUserMessageTime(int index) {
    return _conversationsData[getUserByIndex(index)]!.first.time;
  }

  bool getgetLastUserMessageIsRead(int index) {
    return _conversationsData[getUserByIndex(index)]!.first.isRead;
  }

  int getLastMessageUserId(int index) {
    return _conversationsData.keys.elementAt(index).id;
  }

  User getUserByIndex(int index) {
    return _conversationsData.keys.elementAt(index);
  }
}
