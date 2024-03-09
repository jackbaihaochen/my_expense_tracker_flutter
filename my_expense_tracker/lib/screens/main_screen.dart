import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_expense_tracker/providers/category_list_provider.dart';
import 'package:my_expense_tracker/screens/add_screen.dart';
import 'package:my_expense_tracker/utils.dart';
import 'package:my_expense_tracker/widgets/main_drawer.dart';
import 'package:my_expense_tracker/widgets/main_date_tab.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  // Basic setup for the tab bar
  final monthCount = 12;

  List<String> getPastMonths() {
    List<String> monthsList = [];
    DateTime now = DateTime.now();

    for (int i = 0; i < monthCount; i++) {
      DateTime pastMonth = DateTime(
        now.year,
        now.month - i,
      );
      String formattedMonth = monthFormatter.format(pastMonth);
      monthsList.add(formattedMonth);
    }

    return monthsList.reversed.toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> pastMonths = getPastMonths();

    void goToAddExpenseScreen() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return const AddScreen();
          },
        ),
      );
    }

    ref.read(categoryListProvider.notifier).getCategories();

    return DefaultTabController(
      length: monthCount,
      initialIndex: monthCount - 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Expense Tracker'),
          centerTitle: true,
          actions: [
            TextButton.icon(
              onPressed: goToAddExpenseScreen,
              icon: const Icon(Icons.add),
              label: const Text('add'),
            ),
          ],
        ),
        drawer: const MainDrawer(),
        body: MainDateTab(pastMonths: pastMonths),
      ),
    );
  }
}
