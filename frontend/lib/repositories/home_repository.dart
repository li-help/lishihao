import '../models/api_response.dart';
import '../models/article_model.dart';
import '../models/banner_model.dart';
import '../models/category_model.dart';
import '../services/api_service.dart';

class HomeRepository {
  final ApiService _apiService = ApiService();

  Future<ApiResponse<List<BannerModel>>> getBanners() {
    return _apiService.getBanners();
  }

  Future<ApiResponse<List<CategoryModel>>> getCategories() {
    return _apiService.getCategories();
  }

  /// 返回分页资讯数据，data为 {total, pageNum, pageSize, pages, list}
  Future<ApiResponse<Map<String, dynamic>>> getArticles({
    required int pageNum,
    required int pageSize,
  }) {
    return _apiService.getArticles(pageNum: pageNum, pageSize: pageSize);
  }
}
