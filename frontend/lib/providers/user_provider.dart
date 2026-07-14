import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  UserModel _user = UserModel.defaultUser;

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  UserModel get user => _user;

  Future<void> loadUserInfo(String userId) async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();

    final response = await _userRepository.getUserInfo(userId);

    if (response.isSuccess && response.data != null) {
      _user = response.data!;
      _hasError = false;
    } else {
      _hasError = true;
      _errorMessage = response.message;
      // Keep default user on error
    }

    _isLoading = false;
    notifyListeners();
  }
}
