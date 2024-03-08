import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_expense_tracker/models/expense_model.dart';
import 'package:my_expense_tracker/providers/expense_list_provider.dart';
import 'package:my_expense_tracker/utils.dart';

final db = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;

class AddScreen extends ConsumerStatefulWidget {
  const AddScreen({
    super.key,
  });

  @override
  AddScreenState createState() => AddScreenState();
}

class AddScreenState extends ConsumerState<AddScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  int _amount = 0;

  void onAddExpense() async {
    final addExpense = ref.read(expenseListProvider.notifier).addExpense;

    // Validate the form
    if (_formKey.currentState!.validate()) {
      // Get the current user
      final user = auth.currentUser;
      if (user == null) {
        // Log the user out
        auth.signOut();
      }
      final userUid = user!.uid;

      // Add the expense to the database
      final now = DateTime.now();
      final expense = ExpenseModel(
        id: "",
        title: _title,
        amount: _amount,
        date: now,
      );
      final isSuccessful = await addExpense(
        context: context,
        userUid: userUid,
        expense: expense,
        month: monthFormatter.format(now),
      );
      if (isSuccessful) {
        if (!context.mounted) {
          return;
        }
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                onChanged: (value) {
                  setState(() {
                    _title = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Price（円）',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _amount = int.parse(value);
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: onAddExpense,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
