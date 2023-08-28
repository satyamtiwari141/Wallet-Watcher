import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const MoneyTracker());
}

class MoneyTracker extends StatelessWidget {
  const MoneyTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,     
      title: 'Personal Expenses',
      color: Colors.black,
      
      theme: ThemeData(
        primarySwatch: Colors.green,
        // accentColor: Colors.amber,
        // ignore: deprecated_member_use
        errorColor: Colors.red,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              titleLarge: const TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              labelLarge: const TextStyle(color: Colors.white),
            ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}
