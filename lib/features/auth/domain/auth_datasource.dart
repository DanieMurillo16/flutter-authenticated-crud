import 'package:teslo_shop/features/auth/domain/entities/user.dart';

abstract class AuthDatasource {
  Future<User> login(String user, String password);
  Future<User> registre(String user, String password, String fullName);
  Future<User> checkAuthStatus(String token);
}
