// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  final int? id;
  final String name;
  final String password;
  final String email;
  final String phone;

  User(
      {this.id,
      required this.name,
      required this.password,
      required this.email,
      required this.phone});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'password': password,
      'email': email,
      'phone': phone,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      password: map['password'],
      email: map['email'],
      phone: map['phone'],
    );
  }
}
