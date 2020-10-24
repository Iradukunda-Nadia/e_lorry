
import 'package:e_lorry/manager/reporting/Reports.dart';
import 'package:e_lorry/reuse.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'login.dart';
import 'mechanic/car.dart';
import 'mechanic/mech.dart';
import 'package:e_lorry/user/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'admin/fields/carFields.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() {

  Crashlytics.instance.enableInDevMode = true;
  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-lorry',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),

      routes: <String, WidgetBuilder>{
        '/LoginScreen': (BuildContext context) => new LoginScreen()
      },

      home: new LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

