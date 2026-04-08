import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> createChat(String otherUserId, String otherUserName) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return null;

    try {
      final chatId = _generateChatId(currentUser.uid, otherUserId);

      final chatDoc = await _firestore.collection('chats').doc(chatId).get();
      if (chatDoc.exists) {
        return chatId;
      }

      await _firestore.collection('chats').doc(chatId).set({
        'participants': [currentUser.uid, otherUserId],
        'participantNames': {
          currentUser.uid: currentUser.displayName ?? 'Unknown',
          otherUserId: otherUserName,
        },
        'lastMessage': '',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      return chatId;
    } catch (e) {
      print('Error creating chat: $e');
      return null;
    }
  }

  String _generateChatId(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserChats() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return const Stream.empty();

    return _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUser.uid)
        .withConverter<Map<String, dynamic>>(
          fromFirestore: (snapshot, _) => snapshot.data() ?? {},
          toFirestore: (value, _) => value,
        )
        .snapshots();
  }

  Future<void> sendMessage(String chatId, String message) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      final messageData = {
        'senderId': currentUser.uid,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'text',
      };

      await _addMessageToChat(chatId, messageData);
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  Future<void> sendMediaMessage(String chatId, File file, String mediaType) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      final downloadUrl = await _uploadFile(file, mediaType);
      
      if (downloadUrl != null) {
        final messageData = {
          'senderId': currentUser.uid,
          'message': '',
          'timestamp': FieldValue.serverTimestamp(),
          'type': mediaType,
          'mediaUrl': downloadUrl,
        };

        await _addMessageToChat(chatId, messageData);
      }
    } catch (e) {
      print('Error sending media message: $e');
    }
  }

  Future<String?> _uploadFile(File file, String mediaType) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return null;

      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('chat_media')
          .child(currentUser.uid)
          .child(fileName);

      final uploadTask = storageRef.putFile(file);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  Future<void> _addMessageToChat(String chatId, Map<String, dynamic> messageData) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(messageData);

    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': messageData['type'] == 'text' ? messageData['message'] : 
                    messageData['type'] == 'image' ? '📷 Фото' : '🎥 Видео',
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .withConverter<Map<String, dynamic>>(
          fromFirestore: (snapshot, _) => snapshot.data() ?? {},
          toFirestore: (value, _) => value,
        )
        .snapshots();
  }
}