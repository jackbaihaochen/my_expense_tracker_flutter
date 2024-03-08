import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_expense_tracker/models/expense_model.dart';
import 'package:my_expense_tracker/providers/expense_list_provider.dart';
import 'package:my_expense_tracker/utils.dart';

class MainExpenseItem extends ConsumerStatefulWidget {
  const MainExpenseItem({
    super.key,
    required this.expenseRecord,
  });
  final ExpenseModel expenseRecord;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MainExpenseItemState();
}

class _MainExpenseItemState extends ConsumerState<MainExpenseItem> {
  bool _isDeleting = false;

  void deleteExpenseRecord() {
    ref.read(expenseListProvider.notifier).removeExpense(
          id: widget.expenseRecord.id,
          month: monthFormatter.format(widget.expenseRecord.date),
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: _isDeleting ? Colors.red : Colors.transparent,
            ),
          ),
          Dismissible(
            key: Key(widget.expenseRecord.id),
            onDismissed: (direction) {
              setState(() {
                _isDeleting = true;
              });
              deleteExpenseRecord();
            },
            background: Container(
              color: Colors.transparent,
            ),
            child: ListTile(
              title: Text(
                widget.expenseRecord.title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Text(
                // Date time format as YYYY/MM/DD HH:MM:SS
                dateFormatter.format(
                  widget.expenseRecord.date,
                ),
              ),
              trailing: Text(
                '${currencyFormatter.format(widget.expenseRecord.amount)}.00円',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          )
        ],
      ),
    );
  }
}
