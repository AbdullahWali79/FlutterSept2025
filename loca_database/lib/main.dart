import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const StudentInfoApp());
}

class StudentInfoApp extends StatefulWidget {
  const StudentInfoApp({super.key});

  @override
  State<StudentInfoApp> createState() => _StudentInfoAppState();
}

class _StudentInfoAppState extends State<StudentInfoApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  void _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDark') ?? false;
    });
  }

  void toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    _saveThemePreference(_isDarkMode);
  }

  void _saveThemePreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Info Manager',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(onThemeToggle: toggleTheme),
    );
  }
}
