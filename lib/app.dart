import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sera_app/providers/entry_provider.dart';
import 'package:sera_app/screens/home.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => EntryProvider(),
        child: MaterialApp(
            home: HomeScreen(),
            theme: ThemeData(
              accentColor: Colors.pinkAccent,
              primaryColor: Colors.black,
              appBarTheme: AppBarTheme(backgroundColor: Colors.blue),
              textTheme: GoogleFonts.openSansTextTheme(),
            )));
  }
}
