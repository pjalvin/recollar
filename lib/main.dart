import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:recollar/screensMain/initial_main.dart';
import 'package:recollar/util/configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'RecollAR',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textSelectionTheme:  TextSelectionThemeData(
          selectionHandleColor: color1,
          cursorColor: color1,
        ),
        fontFamily: 'Nexa'
      ),
      home: const InitialMain(),
    );
  }
}
