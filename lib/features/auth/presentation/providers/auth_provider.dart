import 'package:flutter_riverpod/legacy.dart';
import 'package:teslo_shop/features/auth/domain/entities/user.dart';
import 'package:teslo_shop/features/auth/infastructure/errors/auth_error.dart';
import 'package:teslo_shop/features/auth/infastructure/repositories/auth_repository_impl.dart';
import 'package:teslo_shop/features/auth/repositories/auth_repository.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage_services_impl.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) {
    final aut = AuthRepositoryImpl();
    final keyValueStorage = KeyValueStorageServicesImpl();
    return AuthNotifier(authRepository: aut, keyValueStorage: keyValueStorage);
  },
);

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final KeyValueStorage keyValueStorage;
  AuthNotifier({required this.authRepository, required this.keyValueStorage})
      : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on WrongCredentials {
      // Si el error es específicamente por credenciales incorrectas
      logout('Credenciales incorrectas. Por favor, verifique su correo y contraseña.');

    } catch (e) {
      // Para cualquier otro error (sin conexión, error del servidor, etc.)
      logout('Error no controlado. Por favor, intente de nuevo.');
      // Opcional: puedes registrar el error 'e' en algún servicio de logging
      // print(e);
    }
  }

  void registerUser(String email, String password, String fullName) {}

  void checkAuthStatus() async {
    final token = await keyValueStorage.getValue<String>('token');
    if (token == null) return logout();
    try {
      final user = await authRepository.checkAuthStatus(token);
      _setLoggedUser(user);
    } catch (e) {
      logout();
    }
  }

  void _setLoggedUser(User user) async {
    await keyValueStorage.setKeyValue('token', user.token);
    state = state.copyWith(
        user: user, authStatus: AuthStatus.authenticated, errorMessage: '');
  }

  Future<void> logout([String? errorMessage]) async {
    await keyValueStorage.removeKey('token');
    state = state.copyWith(
        authStatus: AuthStatus.notAuthenticated,
        user: null,
        errorMessage: errorMessage);
  }
}

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState(
      {this.authStatus = AuthStatus.checking,
      this.user,
      this.errorMessage = ''});

  AuthState copyWith(
          {AuthStatus? authStatus, User? user, String? errorMessage}) =>
      AuthState(
          authStatus: authStatus ?? this.authStatus,
          user: user ?? this.user,
          errorMessage: errorMessage ?? this.errorMessage);
}
