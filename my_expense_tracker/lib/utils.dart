import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

// Formatters
final monthFormatter = DateFormat('yyyy/MM');
final timeFormatter = DateFormat('yyyy/MM/dd HH:mm:ss');
final dateFormatter = DateFormat('yyyy/MM/dd');
final currencyFormatter = NumberFormat('#,###', 'ja_JP');

// Uuid
const uuid = Uuid();

// User
final auth = FirebaseAuth.instance;
String getUserUid() {
  // Get current user
  final user = auth.currentUser;
  if (user == null) {
    // Log the user out
    auth.signOut();
    return '';
  }
  // GEt the user's uid
  final userUid = user.uid;
  return userUid;
}

// Icons
IconData codePointToIcon(int codePoint) {
  return IconData(codePoint, fontFamily: 'MaterialIcons');
}

// Show SnackBar
void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}
