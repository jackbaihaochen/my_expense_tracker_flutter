import 'package:flutter/material.dart';
import 'package:my_expense_tracker/widgets/main_expense_list.dart';

class MainDateTab extends StatelessWidget {
  const MainDateTab({
    super.key,
    required this.pastMonths,
  });
  final List<String> pastMonths;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          isScrollable: true,
          tabs: [
            for (String month in pastMonths)
              Tab(
                text: month,
              ),
          ],
        ),
        Expanded(
          child: TabBarView(
            children: [
              for (String month in pastMonths)
                Center(
                  child: MainExpenseList(
                    month: month,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
