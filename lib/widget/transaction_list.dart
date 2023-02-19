// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTrans;
  TransactionList(this.transactions, this.deleteTrans);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          return Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: FittedBox(
                    child: Text('\$ ${transactions[index].amount}'),
                  ),
                ),
              ),
              title: Text(
                transactions[index].title,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              subtitle: Text(
                DateFormat.yMMMd().format(transactions[index].date),
              ),
              trailing: MediaQuery.of(context).size.width > 460
                  ? TextButton.icon(
                      onPressed: () => deleteTrans(transactions[index].id),
                      icon: const Icon(Icons.delete),
                      label: const Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.red, //for text color
                        ),
                      ),
                    )
                  : IconButton(
                      icon: const Icon(Icons.delete),
                      color: Theme.of(context).errorColor,
                      onPressed: () => deleteTrans(transactions[index].id),
                    ),
            ),
          );
        },
        itemCount: transactions.length,
      ),
    );
  }
}
