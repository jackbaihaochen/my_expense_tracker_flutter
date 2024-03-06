// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_expense_tracker/models/expense_model.dart';
import 'package:my_expense_tracker/providers/expense_list_provider.dart';

// final db = FirebaseFirestore.instance;
// final auth = FirebaseAuth.instance;
final dateFormatter = DateFormat('yyyy/MM/dd HH:mm:ss');
final currencyFormatter = NumberFormat('#,###', 'ja_JP');

class MainExpenseList extends ConsumerStatefulWidget {
  const MainExpenseList({
    super.key,
    required this.month,
  });

  final String month;

  @override
  ConsumerState<MainExpenseList> createState() => _MainExpenseListState();
}

class _MainExpenseListState extends ConsumerState<MainExpenseList> {
  @override
  void initState() {
    super.initState();
    ref.read(expenseListProvider.notifier).getData(widget.month);
    print('hi');
  }

  @override
  Widget build(BuildContext context) {
    int totalAmount =
        ref.watch(expenseListProvider.notifier).getExpenseSum(widget.month);
    List<ExpenseModel> expenseRecords =
        ref.watch(expenseListProvider)[widget.month] ?? [];
    print('expenseRecords: $expenseRecords');

    return Column(
      children: [
        Text(
          'Total Amount: ${currencyFormatter.format(totalAmount)}円',
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: Center(
            child: Card(
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
                        dateFormatter.format(
                          expenseRecord.date,
                        ),
                      ),
                      trailing: Text(
                        '${currencyFormatter.format(expenseRecord.amount)}.00円',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
