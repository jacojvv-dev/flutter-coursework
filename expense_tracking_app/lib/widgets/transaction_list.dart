import 'package:intl/intl.dart';

import '../models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteCallback;

  TransactionList(this.transactions, this.deleteCallback);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: transactions.isEmpty
          ? Column(
              children: [
                Text(
                  "No transactions",
                  style: Theme.of(context).textTheme.title,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    height: 200,
                    child: Image.asset(
                      "assets/images/waiting.png",
                      fit: BoxFit.contain,
                    ))
              ],
            )
          : ListView.builder(
              // itemBuilder: (ctx, index) {
              //   return Card(
              //     child: Row(
              //       children: [
              //         Container(
              //           padding: EdgeInsets.all(10),
              //           margin:
              //               EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              //           decoration: BoxDecoration(
              //             border: Border.all(
              //               width: 2,
              //               color: Theme.of(context).primaryColor,
              //             ),
              //           ),
              //           child: Text(
              //             "R${transactions[index].amount.toStringAsFixed(2)}",
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold,
              //               fontSize: 20,
              //               color: Theme.of(context).primaryColor,
              //             ),
              //           ),
              //         ),
              //         Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               transactions[index].title,
              //               style: Theme.of(context).textTheme.title,
              //             ),
              //             Text(
              //               DateFormat.yMMMd().format(transactions[index].date),
              //               style: TextStyle(
              //                 color: Theme.of(context).primaryColor,
              //               ),
              //             ),
              //           ],
              //         )
              //       ],
              //     ),
              //   );
              // },
              itemBuilder: (ctx, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  elevation: 5,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: FittedBox(
                          child: Text("R${transactions[index].amount}"),
                        ),
                      ),
                    ),
                    title: Text(
                      transactions[index].title,
                      style: Theme.of(context).textTheme.title,
                    ),
                    subtitle: Text(
                      DateFormat.yMMMMd().format(transactions[index].date),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      color: Theme.of(context).errorColor,
                      onPressed: () => deleteCallback(transactions[index].id),
                    ),
                  ),
                );
              },
              itemCount: transactions.length,
            ),
    );
  }
}
