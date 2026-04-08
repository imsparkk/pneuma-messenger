import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

ValueNotifier<AuthService> authService = ValueNotifier(AuthService());

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    await _updateOnlineStatus(true);
  }

  Future<UserCredential> signUpWithEmailAndPassword(String email, String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
      'lastSeen': FieldValue.serverTimestamp(),
      'isOnline': true,
      'photoUrl': '',
      'name': '',
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return userCredential;
  }

  Future<void> signOut() async {
    await _updateOnlineStatus(false);
    await _auth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateUsername(String displayName) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.updateDisplayName(displayName);
      await user.reload();
      
      await _updateUsernameInChats(displayName);
    }
  }

  Future<void> _updateUsernameInChats(String displayName) async {
    User? user = _auth.currentUser;
    if (user == null) return;

    try {
      final chatsQuery = await FirebaseFirestore.instance
          .collection('chats')
          .where('participants', arrayContains: user.uid)
          .get();

      final batch = FirebaseFirestore.instance.batch();
      for (final chatDoc in chatsQuery.docs) {
        final chatData = chatDoc.data();
        final participantNames = Map<String, dynamic>.from(chatData['participantNames'] ?? {});
        participantNames[user.uid] = displayName;
        
        batch.update(chatDoc.reference, {'participantNames': participantNames});
      }
      
      await batch.commit();
    } catch (e) {
      print('Error updating username in chats: $e');
    }
  }

  Future<void> deleteAccount() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _updateOnlineStatus(false);
      await user.delete();
    }
  }

  Future<void> _updateOnlineStatus(bool isOnline) async {
    User? user = _auth.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'isOnline': isOnline,
        'lastSeen': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating online status: $e');
    }
  }

  Future<void> updateOnlineStatusOnAppStart() async {
    await _updateOnlineStatus(true);
  }

  Future<void> updateOnlineStatusOnAppClose() async {
    await _updateOnlineStatus(false);
  }

  Future<void> resetPasswordFromCurrentPassword(String currentPassword, String newPassword) async {
    User? user = _auth.currentUser;
    if (user != null && user.email != null) {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    }
  }
}