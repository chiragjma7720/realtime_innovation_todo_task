import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/models/employee_data.dart';

import '../constants/string.dart';


class LocalDB {
  late Database _database;

  Future openDb() async {
    _database = await openDatabase(join(await getDatabasesPath(), dbName),
        version: 1, onCreate: (Database db, int version) async {
          await db.execute(
            "CREATE TABLE employee(id INTEGER PRIMARY KEY autoincrement, name TEXT, role TEXT, fromDate TEXT, toDate TEXT)",
          );
        });
    return _database;
  }

  Future<int> insertEmployeeData(EmployeeData employeeData) async {
    await openDb();
    return await _database.insert(tableName, employeeData.toJson());
  }

  Future<List<EmployeeData>> getEmployeeDataList() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.query(tableName);
    return maps.map((i) => EmployeeData.fromJson(i))
        .cast<EmployeeData>()
        .toList();
  }

  Future<int> updateEmployeeData(EmployeeData employeeData) async {
    await openDb();
    return await _database.update(tableName, employeeData.toJson(),
        where: "id = ?", whereArgs: [employeeData.id]);
  }

  Future<int> deleteEmployeeData(EmployeeData employeeData) async {
    await openDb();
    return await _database.delete(tableName, where: "id = ?", whereArgs: [employeeData.id]);
  }
}