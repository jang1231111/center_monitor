import 'package:center_monitor/data/datasources/local/db/db_heler.dart';
import 'package:center_monitor/domain/entities/user/user.dart';

class UserRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> addUser(User user) async {
    final db = await dbHelper.database;
    return await db.insert('users', user.toMap());
  }

  Future<List<User>> getAllUsers() async {
    final db = await dbHelper.database;
    final result = await db.query('users');
    return result.map((e) => User.fromMap(e)).toList();
  }

  Future<int> deleteUser(String phone) async {
    final db = await dbHelper.database;
    return await db.delete('users', where: 'phone = ?', whereArgs: [phone]);
  }
}
