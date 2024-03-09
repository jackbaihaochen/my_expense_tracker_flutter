import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_expense_tracker/models/category_model.dart';
import 'package:my_expense_tracker/models/expense_model.dart';
import 'package:my_expense_tracker/providers/category_list_provider.dart';
import 'package:my_expense_tracker/utils.dart';

final auth = FirebaseAuth.instance;
final db = FirebaseFirestore.instance;
const String expensesCollectionName = 'expenses_collection';
CollectionReference<Map<String, dynamic>> getExpensesCollection() {
  // Get user's uid
  final userUid = getUserUid();
  // Get the expenses collection from the firestore by the user's uid
  return db
      .collection(expensesCollectionName)
      .doc(userUid)
      .collection(expensesCollectionName);
}

class ExpenseListNotifier
    extends StateNotifier<Map<String, List<ExpenseModel>>> {
  Ref ref;
  ExpenseListNotifier(this.ref) : super({});

  // Return true if successful, false if not
  Future<bool> upsertExpense({
    required BuildContext context,
    required String month,
    required ExpenseModel expense,
    required String userUid,
  }) async {
    // Delete in firestore
    final collection = getExpensesCollection();
    return await collection
        .withConverter(
          fromFirestore: ExpenseModel.fromFirestore,
          toFirestore: (expense, options) => expense.toFirestore(),
        )
        .doc(expense.id)
        .set(expense)
        .then((doc) {
      // If successful, add the expense to the state
      if (state.containsKey(month)) {
        state[month] = [expense, ...state[month]!];
      } else {
        state[month] = [expense];
      }
      state = {
        ...state,
        month: [...state[month]!]
      };
      // Show a snackbar
      showSnackBar(context, 'Expense added successfully');
      return true;
    }).catchError((error) {
      showSnackBar(context, 'Failed to add expense: $error');
      return false;
    });
  }

  // Return true if successful, false if not
  Future<bool> removeExpense({
    required BuildContext context,
    required String month,
    required String id,
  }) async {
    final collection = getExpensesCollection();
    // Delete in firestore
    return await collection.doc(id).delete().then((doc) {
      // If successful, remove the expense from the state
      if (state.containsKey(month)) {
        state[month]!.removeWhere((element) => element.id == id);
        state = {
          ...state,
          month: [...state[month]!],
        };
      }
      // Show a snackbar
      showSnackBar(context, 'Expense removed successfully');
      return true;
    }).catchError((error) {
      showSnackBar(context, 'Failed to remove expense: $error');
      return false;
    });
  }

  // Get the expenses from the firestore by the user's uid and selected month, order by date from the newest
  void getData(String selectedMonth) async {
    // Get the start and end of the selected month
    final year = selectedMonth.split('/')[0];
    final month = selectedMonth.split('/')[1];
    final currentMonthStart = DateTime.parse('$year-$month-01');
    final currentMonthEnd = DateTime(
      int.parse(year),
      int.parse(month) + 1,
    ).subtract(
      const Duration(microseconds: 1),
    );
    // Get data
    final collection = getExpensesCollection();
    final snapshot = await collection
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
        .withConverter(
          fromFirestore: ExpenseModel.fromFirestore,
          toFirestore: (expense, options) => expense.toFirestore(),
        )
        .get();
    final expenseList = snapshot.docs.map((e) => e.data()).toList();
    state = {...state, selectedMonth: expenseList};
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
  (ref) => ExpenseListNotifier(ref),
);
