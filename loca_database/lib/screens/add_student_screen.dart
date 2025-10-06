import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/student.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();

  void _saveStudent() async {
    if (_formKey.currentState!.validate()) {
      final student = Student(
        name: _nameController.text,
        email: _emailController.text,
        age: int.parse(_ageController.text),
      );
      await DatabaseHelper.instance.insertStudent(student);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Student added successfully!')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Student')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a name' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => !value!.contains('@')
                    ? 'Enter a valid email'
                    : null,
              ),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    int.tryParse(value!) == null ? 'Enter valid age' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveStudent,
                child: Text('Save Student'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
