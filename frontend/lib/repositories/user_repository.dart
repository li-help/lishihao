import '../models/api_response.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class UserRepository {
  final ApiService _apiService = ApiService();

  Future<ApiResponse<UserModel?>> getUserInfo(String userId) {
    return _apiService.getUserInfo(userId);
  }
}
