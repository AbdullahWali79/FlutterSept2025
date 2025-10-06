import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/student.dart';
import 'add_student_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onThemeToggle;
  
  const HomeScreen({super.key, this.onThemeToggle});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Student> students = [];

  void _loadStudents() async {
    final data = await DatabaseHelper.instance.getStudents();
    setState(() {
      students = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Info Manager'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => SettingsScreen(onThemeToggle: widget.onThemeToggle)));
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return ListTile(
            title: Text(student.name),
            subtitle: Text('${student.email} | Age: ${student.age}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
              context, MaterialPageRoute(builder: (_) => AddStudentScreen()));
          _loadStudents();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
