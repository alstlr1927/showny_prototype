import 'package:flutter/material.dart';
import 'package:flutter_setting_test/main/test_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const TestPage(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: 'dd',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.circle),
            label: 'dd',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'dd',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'dd',
          ),
        ],
      ),
    );
  }
}
