import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:restobillsplitter/pages/guest_list_screen.dart';
import 'package:restobillsplitter/pages/home_screen.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends HookWidget {
  // final Logger logger = getLogger();
  // final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics();

  // Set routes to use in Navigator
  final Map<String, Widget> routes = <String, Widget>{
    HomeScreen.routeName: HomeScreen(),
    GuestListScreen.routeName: GuestListScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        title: "Rest\'O Bill Splitter",
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
