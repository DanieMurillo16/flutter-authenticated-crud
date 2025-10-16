import 'package:teslo_shop/features/auth/domain/entities/user.dart';

class UserMappers {
  static User userJsonEntity(Map<String, dynamic> json) => User(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      roles: List<String>.from(json['roles']),
      token: json['token'] ?? '');
}
