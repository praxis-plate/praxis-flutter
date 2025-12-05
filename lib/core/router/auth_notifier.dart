import 'package:codium/core/bloc/auth/auth_bloc.dart';
import 'package:flutter/foundation.dart';

class AuthNotifier extends ChangeNotifier {
  final AuthBloc _authBloc;

  AuthNotifier(this._authBloc) {
    _authBloc.stream.listen((_) {
      notifyListeners();
    });
  }

  AuthState get state => _authBloc.state;
}
