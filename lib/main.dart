// ignore_for_file: prefer_const_constructors

import './widget/new_transaction.dart';
import './widget/transaction_list.dart';
import 'package:flutter/material.dart';
import './models/transaction.dart';
import './widget/chart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Quicksand',
        errorColor: Colors.red,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.purple,
            textStyle: TextStyle(color: Colors.white),
          ),
        ),
        appBarTheme: AppBarTheme(
          toolbarTextStyle: TextStyle(
            fontSize: 30,
          ),
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    //   Transaction(
    //     id: 't1',
    //     title: 'New Shoes',
    //     amount: 69.99,
    //     date: DateTime.now(),
    //   ),
    //   Transaction(
    //     id: 't2',
    //     title: 'Buy Dress',
    //     amount: 123.89,
    //     date: DateTime.now(),
    //   ),
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  bool _switchValue = false;

  void _addNewTrans(
    String txTitle,
    double txAmount,
    DateTime chosenDate,
  ) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTrans(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: NewTransaction(_addNewTrans),
        );
      },
    );
  }

  void _deleteTRansaction(String id) {
    setState(() {
      _userTransactions.removeWhere(
        (tx) => tx.id == id,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appBar = AppBar(
      title: Text(
        'Flutter App',
        style: TextStyle(
          fontFamily: 'OpenSans',
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => _startAddNewTrans(context),
          icon: Icon(
            Icons.add,
          ),
        )
      ],
    );
    final ListTransWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          1,
      child: TransactionList(_userTransactions, _deleteTRansaction),
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Show Chart',
                  ),
                  Switch.adaptive(
                      value: _switchValue,
                      onChanged: (val) {
                        setState(() {
                          _switchValue = val;
                        });
                      }),
                ],
              ),
            if (!isLandscape)
              Container(
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.3,
                child: Chart(_recentTransactions),
              ),
            if (!isLandscape) ListTransWidget,
            if (isLandscape)
              _switchValue
                  ? Container(
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.4,
                      child: Chart(_recentTransactions),
                    ) 
                  : ListTransWidget
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startAddNewTrans(context),
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
