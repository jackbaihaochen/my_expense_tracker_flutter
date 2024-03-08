import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_expense_tracker/models/expense_model.dart';

final auth = FirebaseAuth.instance;
final db = FirebaseFirestore.instance;

class ExpenseListNotifier
    extends StateNotifier<Map<String, List<ExpenseModel>>> {
  ExpenseListNotifier() : super({});

  void getData(String selectedMonth) async {
    // Get current user
    final user = auth.currentUser;
    if (user == null) {
      // Log the user out
      auth.signOut();
    }
    // GEt the user's uid
    final userUid = user!.uid;
    // Get the expenses from the firestore by the user's uid and selected month, order by date from the newest
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
      tmpExpenseRecords.add(
        ExpenseModel(
          title: title,
          amount: amount,
          date:
              DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch),
          id: doc.id,
        ),
      );
    }
    state = {...state, selectedMonth: tmpExpenseRecords};
  }

  // Return true if successful, false if not
  Future<bool> addExpense({
    required BuildContext context,
    required String month,
    required ExpenseModel expense,
    required String userUid,
  }) async {
    final expenseData = <String, dynamic>{
      'title': expense.title,
      'amount': expense.amount,
      'date': expense.date,
    };
    // Delete in firestore
    return await db
        .collection(userUid)
        .add(expenseData)
        .then((DocumentReference doc) {
      // If successful, add the expense to the state
      final expenseWithId = ExpenseModel(
          title: expense.title,
          amount: expense.amount,
          date: expense.date,
          id: doc.id);
      if (state.containsKey(month)) {
        state[month] = [expenseWithId, ...state[month]!];
      } else {
        state[month] = [expenseWithId];
      }
      state = {
        ...state,
        month: [...state[month]!]
      };
      // Show a snackbar
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Expense added successfully'),
        ),
      );
      return true;
    }).catchError((error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add expense: $error'),
        ),
      );
      return false;
    });
  }

  // Return true if successful, false if not
  Future<bool> removeExpense({
    required BuildContext context,
    required String month,
    required String id,
  }) async {
    final user = auth.currentUser;
    if (user == null) {
      // Log the user out
      auth.signOut();
    }
    final userUid = user!.uid;
    // Delete in firestore
    return await db.collection(userUid).doc(id).delete().then((doc) {
      // If successful, remove the expense from the state
      if (state.containsKey(month)) {
        state[month]!.removeWhere((element) => element.id == id);
        state = {
          ...state,
          month: [...state[month]!],
        };
      }
      // Show a snackbar
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Expense removed successfully'),
        ),
      );
      return true;
    }).catchError((error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to remove expense: $error'),
        ),
      );
      return false;
    });
  }

  int getExpenseCount(String month) {
    if (state.containsKey(month)) {
      return state[month]!.length;
    } else {
      return 0;
    }
  }

  int getExpenseSum(String month) {
    if (state.containsKey(month)) {
      int totalAmount = 0;
      for (var expenseRecord in state[month]!) {
        totalAmount += expenseRecord.amount;
      }
      return totalAmount;
    } else {
      return 0;
    }
  }
}

final expenseListProvider =
    StateNotifierProvider<ExpenseListNotifier, Map<String, List<ExpenseModel>>>(
  (ref) => ExpenseListNotifier(),
);
