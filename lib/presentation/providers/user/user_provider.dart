import 'package:center_monitor/data/datasources/local/db/user_repositories/user_repostiory.dart';
import 'package:center_monitor/domain/entities/user/user.dart';

class UserProvider {
  final UserRepository repository = UserRepository();
  List<User> _users = [];

  List<User> get users => _users;

  Future<void> fetchUsers() async {
    _users = await repository.getAllUsers();
    // print('유저 목록 ${users.toString()}');
  }

  Future<void> addUser(User user) async {
    await repository.addUser(user);
    await fetchUsers();
  }

  Future<void> deleteUser(String phone) async {
    await repository.deleteUser(phone);
    await fetchUsers();
  }
}
