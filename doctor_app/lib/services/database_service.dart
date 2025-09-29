import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/patient.dart';

class DatabaseService extends ChangeNotifier {
  Database? _database;
  List<Patient> _patients = [];
  bool _isLoading = false;

  List<Patient> get patients => _patients;
  bool get isLoading => _isLoading;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'doctor_patient_records.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE patients(
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        dateOfBirth TEXT,
        phoneNumber TEXT,
        email TEXT,
        address TEXT,
        medicalHistory TEXT,
        allergies TEXT,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  Future<void> loadPatients() async {
    _isLoading = true;
    notifyListeners();

    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'patients',
        orderBy: 'createdAt DESC',
      );

      _patients = List.generate(maps.length, (i) {
        return Patient.fromMap(maps[i]);
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading patients: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addPatient(Patient patient) async {
    try {
      final db = await database;
      await db.insert(
        'patients',
        patient.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      await loadPatients(); // Refresh the list
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error adding patient: $e');
      }
      return false;
    }
  }

  Future<bool> updatePatient(Patient patient) async {
    try {
      final db = await database;
      await db.update(
        'patients',
        patient.toMap(),
        where: 'id = ?',
        whereArgs: [patient.id],
      );
      await loadPatients(); // Refresh the list
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error updating patient: $e');
      }
      return false;
    }
  }

  Future<bool> deletePatient(int id) async {
    try {
      final db = await database;
      await db.delete(
        'patients',
        where: 'id = ?',
        whereArgs: [id],
      );
      await loadPatients(); // Refresh the list
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting patient: $e');
      }
      return false;
    }
  }

  Future<Patient?> getPatientById(int id) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'patients',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return Patient.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting patient: $e');
      }
      return null;
    }
  }

  Future<List<Patient>> searchPatients(String query) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'patients',
        where: 'name LIKE ? OR phoneNumber LIKE ? OR email LIKE ?',
        whereArgs: ['%$query%', '%$query%', '%$query%'],
        orderBy: 'name ASC',
      );

      return List.generate(maps.length, (i) {
        return Patient.fromMap(maps[i]);
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error searching patients: $e');
      }
      return [];
    }
  }

  @override
  void dispose() {
    _database?.close();
    super.dispose();
  }
}
