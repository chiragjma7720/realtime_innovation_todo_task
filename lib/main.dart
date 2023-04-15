import 'package:flutter/material.dart';
import 'package:todo/router/routers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /* theme: ThemeData(
          primaryColor: mainColor,
          textTheme: Theme.of(context).textTheme.apply(
            bodyColor: textColor,
          )
      ),*/
      routes: routes!,
      debugShowCheckedModeBanner: false,
      // home: user==null? const SigninScreen(): const DashBoardScreen(),

    );
  }
}
