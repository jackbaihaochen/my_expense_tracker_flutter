import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_expense_tracker/models/expense_model.dart';
import 'package:my_expense_tracker/providers/expense_list_provider.dart';
import 'package:my_expense_tracker/utils.dart';
import 'package:my_expense_tracker/widgets/main_expense_item.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    int totalAmount =
        ref.watch(expenseListProvider.notifier).getExpenseSum(widget.month);
    List<ExpenseModel> expenseRecords =
        ref.watch(expenseListProvider)[widget.month] ?? [];

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
              clipBehavior: Clip.hardEdge,
              margin: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: expenseRecords.length,
                itemBuilder: (context, index) {
                  ExpenseModel expenseRecord = expenseRecords[index];
                  return MainExpenseItem(
                    expenseRecord: expenseRecord,
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
