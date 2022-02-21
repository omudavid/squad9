import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week12/providers/student_provider.dart';
import 'package:week12/providers/theme_provider.dart';
import 'package:week12/user_interface/tab_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => StudentProvider(),
          ),
          ChangeNotifierProvider(
            lazy: false,
            create: (_) => ThemeProvider(),
          ),
        ],
        child: Consumer<ThemeProvider>(
          builder: (context, value, child) {
            return MaterialApp(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              themeMode: value.currentTheme,
              darkTheme: ThemeData(
                primarySwatch: Colors.red,
              ),
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: const TabScreen(),
            );
          },
        ));
  }
}
