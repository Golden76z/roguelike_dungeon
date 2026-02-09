import 'package:flutter/material.dart';
import 'package:roguelike_dungeon/ui/main_menu/main_menu_screen.dart';

class RoguelikeApp extends StatelessWidget {
  const RoguelikeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roguelike Dungeon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainMenuScreen(),
    );
  }
}

