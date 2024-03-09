import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

final monthFormatter = DateFormat('yyyy/MM');
final dateFormatter = DateFormat('yyyy/MM/dd HH:mm:ss');
final currencyFormatter = NumberFormat('#,###', 'ja_JP');

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
