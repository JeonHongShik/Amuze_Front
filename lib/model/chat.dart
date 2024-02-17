import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ChatRoom 모델 클래스 정의
class ChatRoom {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  String chatRoomId;
  ChatMember user1;
  ChatMember user2;
  List<Message> messages;

  ChatRoom({
    required this.chatRoomId,
    required this.user1,
    required this.user2,
    required this.messages,
  });

  // Firestore 문서 스냅샷에서 ChatRoom 객체로 변환하는 생성자
  factory ChatRoom.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final user1Data = data['user1'] as Map<String, dynamic>;
    final user2Data = data['user2'] as Map<String, dynamic>;

    final user1 = ChatMember.fromJson(user1Data);
    final user2 = ChatMember.fromJson(user2Data);

    // 프로필 사진과 닉네임을 가져옵니다.

    return ChatRoom(
      chatRoomId: data['chatRoomId'],
      user1: ChatMember.fromJson(data['user1']),
      user2: ChatMember.fromJson(data['user2']),
      messages: (data['messages'] as List<dynamic>)
          .map((message) => Message.fromJson(message))
          .toList(),
    );
  }

  // ChatRoom 객체를 JSON 데이터로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'chatRoomId': chatRoomId,
      'user1': user1.toJson(),
      'user2': user2.toJson(),
      'messages': messages.map((message) => message.toJson()).toList(),
    };
  }
}

// ChatMember 모델 클래스 정의
class ChatMember {
  String nickname;
  String email;
  String? photoUrl;
  String role;

  ChatMember({
    required this.nickname,
    required this.email,
    this.photoUrl,
    required this.role,
  });

  // JSON 데이터에서 ChatMember 객체로 변환하는 생성자
  factory ChatMember.fromJson(Map<String, dynamic> json) {
    return ChatMember(
      nickname: json['nickname'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      role: json['role'],
    );
  }

  // ChatMember 객체를 JSON 데이터로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'email': email,
      'photoUrl': photoUrl,
      'role': role,
    };
  }
}

// Message 모델 클래스 정의
class Message {
  String content;
  String sender;
  String createdAt;

  Message({
    required this.content,
    required this.sender,
    required this.createdAt,
  });

  // JSON 데이터에서 Message 객체로 변환하는 생성자
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      content: json['content'],
      sender: json['sender'],
      createdAt: json['createdAt'],
    );
  }

  // Message 객체를 JSON 데이터로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'sender': sender,
      'createdAt': createdAt,
    };
  }
}

// MyChat 모델 클래스 정의
class MyChat {
  String chatRoomId;
  String otherEmail;
  String otherName;
  String otherPhotoUrl;
  String lastMessage;
  String lastTime;

  MyChat({
    required this.chatRoomId,
    required this.otherEmail,
    required this.otherName,
    required this.otherPhotoUrl,
    required this.lastMessage,
    required this.lastTime,
  });

  // JSON 데이터에서 MyChat 객체로 변환하는 생성자
  factory MyChat.fromJson(Map<dynamic, dynamic> json) {
    return MyChat(
      chatRoomId: json['chatRoomId'],
      otherEmail: json['otherEmail'],
      otherName: json['otherName'],
      otherPhotoUrl: json['otherPhotoUrl'],
      lastMessage: json['lastMessage'],
      lastTime: json['lastTime'],
    );
  }

  // MyChat 객체를 JSON 데이터로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'chatRoomId': chatRoomId,
      'otherEmail': otherEmail,
      'otherName': otherName,
      'otherPhotoUrl': otherPhotoUrl,
      'lastMessage': lastMessage,
      'lastTime': lastTime,
    };
  }
}
