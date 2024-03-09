import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_expense_tracker/models/category_model.dart';
import 'package:my_expense_tracker/models/expense_model.dart';
import 'package:my_expense_tracker/providers/category_list_provider.dart';
import 'package:my_expense_tracker/providers/expense_list_provider.dart';
import 'package:my_expense_tracker/utils.dart';

final db = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;

class UpsertExpenseScreen extends ConsumerStatefulWidget {
  const UpsertExpenseScreen({
    super.key,
    this.expenseRecord,
  });
  final ExpenseModel? expenseRecord;

  @override
  UpsertExpenseScreenState createState() => UpsertExpenseScreenState();
}

class UpsertExpenseScreenState extends ConsumerState<UpsertExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  String _id = '';
  String _title = '';
  int _amount = 0;
  DateTime _pickedDate = DateTime.now();
  CategoryModel _selectedCategory = othersCategory;

  void _showDatePicker() async {
    final now = DateTime.now();
    final start = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: start,
      lastDate: now,
    );
    if (pickedDate == null) {
      return;
    }
    setState(() {
      _pickedDate = pickedDate;
    });
  }

  void onAddExpense() async {
    final addExpense = ref.read(expenseListProvider.notifier).upsertExpense;

    // Validate the form
    if (_formKey.currentState!.validate()) {
      // Get user's uid
      final userUid = getUserUid();

      // Add the expense to the database
      final now = DateTime.now();
      final expense = ExpenseModel(
        id: _id == '' ? uuid.v4() : _id,
        title: _title,
        amount: _amount,
        category: _selectedCategory,
        date: _pickedDate,
        updatedAt: now,
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
  void initState() {
    super.initState();
    if (widget.expenseRecord != null) {
      final expense = widget.expenseRecord!;
      _title = expense.title;
      _amount = expense.amount;
      _pickedDate = expense.date;
      _selectedCategory = expense.category;
      _id = expense.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<CategoryModel> categories = ref.watch(categoryListProvider);

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
              // Name
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
                initialValue: _title,
              ),
              // Price
              const SizedBox(height: 16.0),
              TextFormField(
                initialValue: _amount.toString(),
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
              // Category
              const SizedBox(height: 16.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Category: ',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(width: 16.0),
                  DropdownButton(
                    value: _selectedCategory.name,
                    items: [
                      for (var category in categories)
                        DropdownMenuItem(
                          value: category.name,
                          child: Row(
                            children: [
                              Icon(
                                category.image,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 8.0),
                              Text(category.name),
                            ],
                          ),
                        ),
                    ],
                    onChanged: (name) {
                      if (name == null) {
                        return;
                      }
                      setState(() {
                        _selectedCategory = categories
                            .firstWhere((element) => element.name == name);
                      });
                    },
                  ),
                ],
              ),
              // Date
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Text(
                    'Date: ${dateFormatter.format(_pickedDate)}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  IconButton(
                    onPressed: _showDatePicker,
                    icon: const Icon(Icons.calendar_month),
                  ),
                ],
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
