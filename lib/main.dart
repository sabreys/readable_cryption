import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readable_cryption/providers/serverProvider.dart';

void main() {

  runApp(  MultiProvider(providers: [
    Provider<ServerProvider>(create: (_) => ServerProvider()),
  ],child: HomePage()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
      Text("sa"));
  }
}


