// import 'package:chatapp/DummyData.dart';
import 'package:flutter/material.dart';

import '../Models/Message.dart';
import '../Models/User.dart';

class Conversation with ChangeNotifier {
  late final User currentUser;
  final Map<User, List<Message>> _conversationsData = {
    // rayan: [
    //   Message(
    //     sender: rayan,
    //     time: '2:30 PM',
    //     text: "مشتقلك والله",
    //     isLiked: true,
    //     isRead: false,
    //     isImage: false,
    //   ),
    //   Message(
    //       sender: currentUser1,
    //       time: '2:30 PM',
    //       text: "تمام انتا كيفك",
    //       isLiked: false,
    //       isRead: true,
    //       isImage: false),
    //   Message(
    //       sender: rayan,
    //       time: '2:30 PM',
    //       text: "شو اخبارك",
    //       isLiked: false,
    //       isRead: true,
    //       isImage: false),
    //   Message(
    //       sender: rayan,
    //       time: '2:30 PM',
    //       text: "كيفك ؟",
    //       isLiked: true,
    //       isRead: true,
    //       isImage: false),
    //   Message(
    //       sender: currentUser1,
    //       time: '2:29 PM',
    //       text: "يا هلاااا",
    //       isLiked: false,
    //       isRead: true,
    //       isImage: false),
    //   Message(
    //       sender: rayan,
    //       time: '2:29 PM',
    //       text: "مرحبا",
    //       isLiked: false,
    //       isRead: false,
    //       isImage: false),
    // ],
    // haya: [
    //   Message(
    //     sender: haya,
    //     time: '2:00 PM',
    //     text: "بعيد الشر",
    //     isLiked: true,
    //     isRead: false,
    //     isImage: false,
    //   ),
    //   Message(
    //       sender: currentUser1,
    //       time: '2:00 PM',
    //       text: "طيب انا بموت لترتاحي ",
    //       isLiked: false,
    //       isRead: true,
    //       isImage: false),
    //   Message(
    //       sender: haya,
    //       time: '2:00 PM',
    //       text: "ما بدي موت",
    //       isLiked: false,
    //       isRead: true,
    //       isImage: false),
    //   Message(
    //       sender: haya,
    //       time: '2:00 PM',
    //       text: "بعيد الشر",
    //       isLiked: true,
    //       isRead: true,
    //       isImage: false),
    //   Message(
    //       sender: currentUser1,
    //       time: '2:00 PM',
    //       text: "موتي بترتاحي",
    //       isLiked: false,
    //       isRead: true,
    //       isImage: false),
    //   Message(
    //       sender: haya,
    //       time: '1:59 PM',
    //       text: "ايمااان دايق خلقي",
    //       isLiked: false,
    //       isRead: false,
    //       isImage: false),
    // ],
    // abd: [
    //   Message(
    //     sender: abd,
    //     time: '1:00 PM',
    //     text: "لا تطول",
    //     isLiked: true,
    //     isRead: false,
    //     isImage: false,
    //   ),
    //   Message(
    //       sender: currentUser1,
    //       time: '1:00 PM',
    //       text: "يلا ماشي جاي ",
    //       isLiked: false,
    //       isRead: true,
    //       isImage: false),
    //   Message(
    //       sender: abd,
    //       time: '1:00 PM',
    //       text: "عالmtn",
    //       isLiked: false,
    //       isRead: true,
    //       isImage: false),
    //   Message(
    //       sender: abd,
    //       time: '1:00 PM',
    //       text: "ما دخلك قوم تعال ",
    //       isLiked: true,
    //       isRead: true,
    //       isImage: false),
    //   Message(
    //       sender: currentUser1,
    //       time: '12:59 PM',
    //       text: "مين ومين ووين",
    //       isLiked: false,
    //       isRead: true,
    //       isImage: false),
    //   Message(
    //       sender: abd,
    //       time: '12:59 PM',
    //       text: "شلونك معلم برتية تركس وتكسير روس ",
    //       isLiked: false,
    //       isRead: false,
    //       isImage: false),
    // ],
  };
  final List<Message> _request = [
    // Message(
    //   sender: User(
    //       id: 5, name: 'Ahmad', phoneNumber: '+963994509145', imageUrl: ''),
    //   time: '10:30',
    //   text: 'مالي طايق هالعيشة',
    //   isRead: false,
    //   isLiked: false,
    //   isImage: false,
    // ),
  ];

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
    // _conversationsData[newUser] = [];
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
    print('vvvvvvvvvvvvv' + _conversationsData[userSender].toString());

    if (hasNumber(userSender)) {
      _conversationsData[getKey(userSender)]!.insert(0, newMessage);
      print('Adddddddddddddddddddddddddddddeeeeeeeeeeesssssssssssssss');
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
