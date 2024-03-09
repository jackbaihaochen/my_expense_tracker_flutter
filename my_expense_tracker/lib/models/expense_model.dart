import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_expense_tracker/models/category_model.dart';

class ExpenseModel {
  final String id;
  final String title;
  final int amount;
  final DateTime date;
  final CategoryModel category;
  final DateTime updatedAt;

  ExpenseModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.updatedAt,
  });

  factory ExpenseModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return ExpenseModel(
      id: data?['id'],
      title: data?['title'],
      amount: data?['amount'],
      date: DateTime.fromMillisecondsSinceEpoch(
          data?['date'].millisecondsSinceEpoch),
      category: CategoryModel.fromMap(
        data?['category'],
      ),
      updatedAt: data?['updatedAt'].toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date,
      'category': category.toFirestore(),
      'updatedAt': updatedAt,
    };
  }
}
