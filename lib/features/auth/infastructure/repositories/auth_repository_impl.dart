import 'package:teslo_shop/features/auth/domain/auth_datasource.dart';
import 'package:teslo_shop/features/auth/domain/entities/user.dart';
import 'package:teslo_shop/features/auth/infastructure/datasocurces/auth_datasource_impl.dart';
import 'package:teslo_shop/features/auth/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl([AuthDatasource? datasource])
      : datasource = datasource ?? AuthDatasourceImpl();

  @override
  Future<User> checkAuthStatus(String token) {
    return datasource.checkAuthStatus(token);
  }

  @override
  Future<User> login(String user, String password) {
    return datasource.login(user, password);
  }

  @override
  Future<User> registre(String user, String password, String fullName) {
    return datasource.registre(user, password, fullName);
  }
}
