import 'package:flutter/material.dart';
import 'package:machine2/controller/provider.dart';
import 'package:machine2/views/home_screen.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FetchProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GitHub Repos',
        home: MyHomePage(),
      ),
    );
  }
}
