import 'dart:io';

import 'package:amuze/model/chat.dart'; // 채팅과 관련된 모델을 가져옵니다.
import 'package:amuze/service/firebase_storage_service.dart'; // Firebase 스토리지 서비스를 사용하기 위해 가져옵니다.
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore를 사용하기 위해 가져옵니다.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // 안전한 저장소를 사용하기 위해 가져옵니다.
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences를 사용하기 위해 가져옵니다.

// 채팅 서비스 클래스 정의
class ChatService {
  static final ChatService _chatService = ChatService._internal();
  factory ChatService() {
    return _chatService;
  }
  late String _userEmail = ''; // 초기화 추가
  ChatService._internal() {
    _userEmail = '';
    _getUserEmail(); // 사용자 이메일을 가져오는 내부 메서드를 호출합니다.
  }

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore 인스턴스를 가져옵니다.
  final FlutterSecureStorage _secureStorage =
      const FlutterSecureStorage(); // 안전한 저장소 인스턴스를 가져옵니다.
  late SharedPreferences _prefs;

  // 채팅방 ID를 생성하는 메서드입니다.
  Future<String> makeChatroomId(String otherEmail) async {
    if (_userEmail.isEmpty) await _getUserEmail(); // 사용자 이메일이 비어있으면 가져옵니다.

    final List<String> emails = [_userEmail, otherEmail];
    emails.sort();
    return emails.join('&').replaceAll('.', ''); // 이메일을 정렬하여 채팅방 ID를 생성합니다.
  }

  // 사용자 이메일을 가져오는 메서드입니다.
  Future<void> _getUserEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    _prefs = await SharedPreferences.getInstance();
    _userEmail = user?.email?.replaceAll('.', '') ?? '';
    ; // 이메일에서 점을 제거하여 사용자 이메일을 가져옵니다.
  }

  // 사용자의 채팅 목록을 가져오는 메서드입니다.
  Future<List<MyChat>> getChatList() async {
    try {
      if (_userEmail.isEmpty) {
        await _getUserEmail();
      }

      final snapshot =
          await _firestore.collection('usersChat').doc(_userEmail).get();
      if (snapshot.exists) {
        final List<MyChat> chats = [];
        (snapshot.data() as Map).entries.forEach((entry) {
          chats.add(MyChat.fromJson(entry.value));
        });
        return chats;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // 사용자의 채팅 목록을 스트림으로 가져오는 메서드입니다.
  Stream<List<MyChat>> getChatListData() async* {
    try {
      if (_userEmail.isEmpty) {
        await _getUserEmail();
      }
      final data = _firestore
          .collection('usersChat')
          .doc(_userEmail)
          .snapshots()
          .map((event) {
        final List<MyChat> chats = [];
        if (event.data() == null) return chats;
        (event.data() as Map).entries.forEach((entry) {
          chats.add(MyChat.fromJson(entry.value));
        });
        return chats;
      });
      yield* data;
    } catch (e) {
      print(e);
      if (e is FirebaseException && e.code == 'path.isNotEmpty') yield [];
    }
  }

  // 채팅방 데이터를 가져오는 스트림을 설정하는 메서드입니다.
  Stream<ChatRoom> getChatRoomData(String chatroomId) {
    try {
      final stream = _firestore
          .collection('chatrooms')
          .doc(chatroomId)
          .snapshots()
          .map((event) {
        return ChatRoom.fromDocumentSnapshot(event);
      });
      return stream;
    } catch (e) {
      throw e;
    }
  }

  // 메시지를 전송하는 메서드입니다.
  Future<void> sendMessage(String chatRoomId, Message message) async {
    try {
      final snapshot =
          await _firestore.collection('chatrooms').doc(chatRoomId).get();
      if (snapshot.exists) {
        final roomData = ChatRoom.fromDocumentSnapshot(snapshot);
        final messages = roomData.messages;
        messages.add(message);
        await _firestore
            .collection('chatrooms')
            .doc(chatRoomId)
            .update({'messages': messages.map((e) => e.toJson()).toList()});
      }

      await _saveLastMessage(_userEmail, chatRoomId, message);
      await _saveLastMessage(chatRoomId.split('&')[0], chatRoomId, message);
    } catch (e) {
      print(e);
    }
  }

  // 마지막 메시지를 저장하는 메서드입니다.
  Future<void> _saveLastMessage(
      String id, String chatRoomId, Message message) async {
    try {
      final snapshot = await _firestore.collection('usersChat').doc(id).get();
      if (snapshot.exists) {
        final chat = MyChat.fromJson(snapshot.data()![chatRoomId]);
        chat.lastMessage =
            message.content.contains('image@') ? '사진' : message.content;
        chat.lastTime = message.createdAt;
        await _firestore
            .collection('usersChat')
            .doc(id)
            .update({chatRoomId: chat.toJson()});
      } else {
        final chat = MyChat(
          chatRoomId: chatRoomId,
          otherEmail: chatRoomId.split('&')[0] == id
              ? chatRoomId.split('&')[1]
              : chatRoomId.split('&')[0],
          otherName: chatRoomId.split('&')[0] == id
              ? chatRoomId.split('&')[1]
              : chatRoomId.split('&')[0],
          otherPhotoUrl: '1',
          lastMessage: message.content,
          lastTime: message.createdAt,
        );
        await _firestore
            .collection('usersChat')
            .doc(id)
            .set({chatRoomId: chat.toJson()});
      }
    } catch (e) {
      if (e is FirebaseException && e.code == 'not-found') {
        final chat = MyChat(
          chatRoomId: chatRoomId,
          otherEmail: chatRoomId.split('&')[0] == id
              ? chatRoomId.split('&')[1]
              : chatRoomId.split('&')[0],
          otherName: chatRoomId.split('&')[0] == id
              ? chatRoomId.split('&')[1]
              : chatRoomId.split('&')[0],
          otherPhotoUrl: '1',
          lastMessage: message.content,
          lastTime: message.createdAt,
        );
        await _firestore
            .collection('usersChat')
            .doc(id)
            .set({chatRoomId: chat.toJson()});
      } else {
        print(e);
      }
    }
  }

  // 이미지를 전송하는 메서드입니다.
  Future<void> sendImage(String chatRoomId, File file, Message message) async {
    final url = await FirebaseStorageService()
        .uploadImage('$chatRoomId/${file.path}', file);
    message.content = 'image@$url';
    await sendMessage(chatRoomId, message);
  }

  // 새로운 채팅방을 생성하는 메서드입니다.
  Future<void> newChatRoom(ChatRoom chatroom, Message message) async {
    try {
      await _saveUserChatlist(
        chatroom.user1.email.replaceAll('.', ''),
        MyChat(
          chatRoomId: chatroom.chatRoomId,
          otherEmail: chatroom.user2.email,
          otherName: chatroom.user2.nickname,
          otherPhotoUrl: chatroom.user2.photoUrl!,
          lastMessage: message.content,
          lastTime: message.createdAt,
        ),
      );

      await _saveUserChatlist(
        chatroom.user2.email.replaceAll('.', ''),
        MyChat(
          chatRoomId: chatroom.chatRoomId,
          otherEmail: chatroom.user1.email,
          otherName: chatroom.user1.nickname,
          otherPhotoUrl: chatroom.user1.photoUrl!,
          lastMessage: message.content,
          lastTime: message.createdAt,
        ),
      );

      await _firestore
          .collection('chatrooms')
          .doc(chatroom.chatRoomId)
          .set(chatroom.toJson());
    } catch (e) {
      print(e);
    }
  }

  // 사용자의 채팅 목록을 저장하는 메서드입니다.
  Future<void> _saveUserChatlist(String id, MyChat chat) async {
    try {
      final snapshot = await _firestore.collection('usersChat').doc(id).get();
      if (snapshot.exists && snapshot.data() != null) {
        await _firestore
            .collection('usersChat')
            .doc(id)
            .update({chat.chatRoomId: chat.toJson()});
      } else {
        await _firestore
            .collection('usersChat')
            .doc(id)
            .set({chat.chatRoomId: chat.toJson()});
      }
    } catch (e) {
      if (e is FirebaseException && e.code == 'not-found') {
        await _firestore
            .collection('usersChat')
            .doc(id)
            .set({chat.chatRoomId: chat.toJson()});
      } else {
        print(e);
      }
    }
  }
}
