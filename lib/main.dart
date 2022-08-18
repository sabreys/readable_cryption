
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:readable_cryption/pages/LoginPage.dart';
import 'package:readable_cryption/providers/serverProvider.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<ServerProvider>(create: (_) => ServerProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginForm(),
    );
  }
}
