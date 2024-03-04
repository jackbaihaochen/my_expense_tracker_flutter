import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final db = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;

class AddScreen extends StatefulWidget {
  const AddScreen({
    super.key,
  });

  @override
  AddScreenState createState() => AddScreenState();
}

class AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  int _amount = 0;

  void onAddExpense() {
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
      final expense = <String, dynamic>{
        'title': _title,
        'amount': _amount,
        'date': DateTime.now(),
      };
      db.collection(userUid).add(expense).then((DocumentReference doc) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Expense added successfully'),
          ),
        );
        Navigator.of(context).pop();
      }).catchError((error) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add expense: $error'),
          ),
        );
      });
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
