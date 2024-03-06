import 'package:flutter/material.dart';
import 'package:my_expense_tracker/widgets/main_expense_list.dart';

class MainDateTab extends StatefulWidget {
  const MainDateTab({
    super.key,
    required this.pastMonths,
  });
  final List<String> pastMonths;

  @override
  State<MainDateTab> createState() => _MainDateTabState();
}

class _MainDateTabState extends State<MainDateTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          isScrollable: true,
          tabs: [
            for (String month in widget.pastMonths)
              Tab(
                text: month,
              ),
          ],
        ),
        Expanded(
          child: TabBarView(
            children: [
              for (String month in widget.pastMonths)
                Container(
                  padding: const EdgeInsets.all(16),
                  child: MainExpenseList(month: month),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
