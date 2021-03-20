import 'package:flutter/material.dart';
import 'package:flutter_application_1/home.dart';
import 'SplashScreen.dart';
import 'appTheme.dart';

void main()
{
  runApp(MyApp());
}

class MyApp extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<MyApp>
{

  @override
  void initState()
  {
    super.initState();

  }

    @override
    Widget build(BuildContext context)
    {
      return MaterialApp(
        home: SplashScreen(),
        theme: appTheme,
        debugShowCheckedModeBanner: false,
      );
    }

}