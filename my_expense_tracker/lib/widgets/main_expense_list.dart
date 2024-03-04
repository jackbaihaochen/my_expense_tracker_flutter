import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_expense_tracker/models/expense_model.dart';

final db = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;
final formatter = DateFormat('yyyy/MM/dd HH:mm:ss');

class MainExpenseList extends StatefulWidget {
  const MainExpenseList({
    super.key,
    required this.month,
  });

  final String month;

  @override
  State<MainExpenseList> createState() => _MainExpenseListState();
}

class _MainExpenseListState extends State<MainExpenseList> {
  // Get the expenses from the firestore
  List<ExpenseModel> expenseRecords = [];
  void getExpenses() async {
    // Get current user
    final user = auth.currentUser;
    if (user == null) {
      // Log the user out
      auth.signOut();
    }
    // GEt the user's uid
    final userUid = user!.uid;
    // Get the expenses from the firestore by the user's uid and selected month, order by date from the newest
    final selectedMonth = widget.month;
    final year = selectedMonth.split('/')[0];
    final month = selectedMonth.split('/')[1];
    final currentMonthStart = DateTime.parse('$year-$month-01');
    final currentMonthEnd = DateTime(
      int.parse(year),
      int.parse(month) + 1,
    ).subtract(
      const Duration(microseconds: 1),
    );
    final data = await db
        .collection(userUid)
        .where(
          'date',
          isGreaterThanOrEqualTo: currentMonthStart,
        )
        .where(
          'date',
          isLessThanOrEqualTo: currentMonthEnd,
        )
        .orderBy(
          'date',
          descending: true,
        )
        .get();
    final List<QueryDocumentSnapshot> docs = data.docs;
    var tmpExpenseRecords = <ExpenseModel>[];
    for (var doc in docs) {
      final title = doc['title'];
      final amount = doc['amount'];
      final date = doc['date'];
      tmpExpenseRecords.add(ExpenseModel(
        title: title,
        amount: amount,
        date: date.millisecondsSinceEpoch,
        id: doc.id,
      ));
    }
    setState(() {
      expenseRecords = tmpExpenseRecords;
    });
  }

  // Call getExpenses when the widget is initialized
  @override
  void initState() {
    super.initState();
    getExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: expenseRecords.length,
        itemBuilder: (context, index) {
          ExpenseModel expenseRecord = expenseRecords[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                expenseRecord.title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Text(
                // Date time format as YYYY/MM/DD HH:MM:SS
                formatter.format(
                  DateTime.fromMillisecondsSinceEpoch(expenseRecord.date),
                ),
              ),
              trailing: Text(
                '${expenseRecord.amount.toStringAsFixed(2)}円',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          );
        },
      ),
    );
  }
}
