

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';

final goRouterNotifierProvier=Provider((ref) {
  final authNotifier = ref.read(authProvider.notifier);
  return GoRouterNotifier(authNotifier);
},);


class GoRouterNotifier extends ChangeNotifier{
  final AuthNotifier _authNotifier;
  AuthStatus _authState = AuthStatus.checking;
  GoRouterNotifier(this._authNotifier){
    _authNotifier.addListener((state) {
      authStatus=state.authStatus;
    },);
  }

  AuthStatus get authStatus=>_authState;

  set authStatus(AuthStatus value){
    _authState=value;
    notifyListeners();
    

  }
}