import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
  void deleteExpenseRecord() {
    ref.read(expenseListProvider.notifier).removeExpense(
          id: widget.expenseRecord.id,
          month: monthFormatter.format(widget.expenseRecord.date),
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: 0.3,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              borderRadius: const BorderRadius.all(
                Radius.circular(8.0),
              ),
              autoClose: true,
              onPressed: (context) {
                deleteExpenseRecord();
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: ListTile(
          title: Row(
            children: [
              // Icon(
              //   widget.expenseRecord.category.image,
              //   color: Theme.of(context).primaryColor,
              // ),
              // const SizedBox(width: 8.0),
              Text(
                widget.expenseRecord.title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          subtitle: Text(
            // Date time format as YYYY/MM/DD HH:MM:SS
            timeFormatter.format(
              widget.expenseRecord.date.toLocal(),
            ),
          ),
          trailing: Text(
            '${currencyFormatter.format(widget.expenseRecord.amount)}.00円',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}
