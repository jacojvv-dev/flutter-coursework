import 'package:expense_tracking_app/models/transaction.dart';
import 'package:expense_tracking_app/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get goupedTransactionsValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));

      final currentTransactions = recentTransactions
          .where((t) =>
              t.date.day == weekDay.day &&
              t.date.year == weekDay.year &&
              t.date.month == weekDay.month)
          .map((t) => t.amount);
      final total = currentTransactions.isEmpty
          ? 0.0
          : currentTransactions.reduce((value, element) => value + element);

      return {
        "day": DateFormat.E().format(weekDay),
        "amount": total,
      };
    }).reversed.toList();
  }

  double get maxSpending {
    return goupedTransactionsValues.isEmpty
        ? 0.0
        : goupedTransactionsValues.fold(
            0.0, (previousValue, element) => previousValue + element["amount"]);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: goupedTransactionsValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                data["day"],
                data["amount"],
                maxSpending == 0 ? 0 : (data["amount"] as double) / maxSpending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
