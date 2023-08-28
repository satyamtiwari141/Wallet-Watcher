import 'package:expanse_tracker/models/transaction.dart';
import 'package:flutter/material.dart';

import '../widgets/chart.dart';
import '../widgets/new_transaction.dart';
import '../widgets/transaction_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Transaction> _userTransaction = [
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransaction {
    return _userTransaction.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
    );
    setState(() {
      _userTransaction.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      isScrollControlled: true,
      context: ctx,
      builder: (_) {
        return NewTransaction(_addNewTransaction);
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((tx) => tx.id == id);
    });
  }

  List<Widget> _buildLandscape(
      MediaQueryData mediaQuery, AppBar appbar, Widget txWidgetList) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Show Chart'),
          Switch(
            value: _showChart,
            onChanged: (value) {
              setState(() {
                _showChart = value;
              });
            },
          ),
        ],
      ),
      _showChart
          ? SizedBox(
              height: (mediaQuery.size.height -
                      appbar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(_recentTransaction),
            )
          : txWidgetList
    ];
  }

  List<Widget> _buildPortrait(
      MediaQueryData mediaQuery, AppBar appbar, Widget txWidgetList) {
    return [
      SizedBox(
        height: (mediaQuery.size.height -
                appbar.preferredSize.height -
                mediaQuery.padding.top) *
            0.25,
        child: Chart(_recentTransaction),
      ),
      txWidgetList
    ];
  }

  @override
Widget build(BuildContext context) {
  final mediaQuery = MediaQuery.of(context);
  final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
  final appbar = AppBar(
    title: const Text(
      'Personal Expenses',
      style: TextStyle(fontFamily: 'OpenSans'),
    ),
  );

  // Define padding and margin values for the TransactionList
  const double listPaddingHorizontal = 16.0;
  const double listMarginVertical = 8.0;

  final txWidgetList = Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Container(
        margin:  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Add margin
        padding: const EdgeInsets.all(20.0), // Add padding around the text
        decoration: BoxDecoration(
          color: Colors.green, // Customize the background color
          borderRadius: BorderRadius.circular(10.0), // Make it circular
        ),
        child: const Text(
          'Spends List', // Your text here
          style: TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.bold, 
            color: Colors.white,
          ), // Customize text style
        ),
      ),
      
      Container(
        margin: const EdgeInsets.symmetric(vertical: listMarginVertical),
        padding: const EdgeInsets.symmetric(horizontal: listPaddingHorizontal),
        height: (mediaQuery.size.height - appbar.preferredSize.height - mediaQuery.padding.top) * 0.7,
        child: TransactionList(_userTransaction, _deleteTransaction),
      ),
    ],
  );

  return Scaffold(
    backgroundColor: Colors.grey[300],
    appBar: appbar,
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (isLandscape)
            ..._buildLandscape(
              mediaQuery,
              appbar,
              txWidgetList,
            ),
          if (!isLandscape)
            ..._buildPortrait(
              mediaQuery,
              appbar,
              txWidgetList,
            ),
        ],
      ),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    floatingActionButton: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: FloatingActionButton(
        onPressed: () {
          _startAddNewTransaction(context);
        },
        child: const Icon(Icons.add),
      ),
    ),
  );
}
}