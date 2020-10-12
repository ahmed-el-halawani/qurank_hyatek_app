import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/controller/elsurah_load_provider.dart';
import 'package:quran/controller/viewProvider.dart';
import 'package:quran/pages/down_loading_screen.dart';
import 'controller/constProvider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ViewProvider>(
          create: (context) => ViewProvider.instance,
        ),
        ChangeNotifierProvider<ElsurahProvider>(
          create: (context) => ElsurahProvider.instance,
        ),
        ChangeNotifierProvider<ConstProvider>(
          create: (context) => ConstProvider.instance,
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ConstProvider cProv = Provider.of<ConstProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: cProv.theme,
      home: DownLoadScreen(),
    );
  }
}
