import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/api_response.dart';
import '../models/banner_model.dart';
import '../models/category_model.dart';
import '../models/article_model.dart';
import '../models/user_model.dart';

class ApiService {
  static ApiService? _instance;
  late final Dio _dio;

  ApiService._() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  factory ApiService() {
    _instance ??= ApiService._();
    return _instance!;
  }

  // ── 通用列表请求 ──────────────────────────────────────
  Future<ApiResponse<List<T>>> _handleListRequest<T>({
    required String path,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      final body = response.data as Map<String, dynamic>;
      final dataList = (body['data'] as List<dynamic>?)
              ?.map((e) => fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
      return ApiResponse(
        code: body['code'] as int? ?? 200,
        message: body['message'] as String? ?? 'success',
        data: dataList,
      );
    } on DioException catch (e) {
      return ApiResponse(
        code: e.response?.statusCode ?? -1,
        message: e.message ?? '网络请求失败',
      );
    } catch (e) {
      return ApiResponse(code: -1, message: e.toString());
    }
  }

  // ── Banner列表 ────────────────────────────────────────
  Future<ApiResponse<List<BannerModel>>> getBanners() {
    return _handleListRequest<BannerModel>(
      path: ApiConfig.banners,
      fromJson: (json) => BannerModel.fromJson(json),
    );
  }

  // ── 分类列表 ──────────────────────────────────────────
  Future<ApiResponse<List<CategoryModel>>> getCategories() {
    return _handleListRequest<CategoryModel>(
      path: ApiConfig.categories,
      fromJson: (json) => CategoryModel.fromJson(json),
    );
  }

  // ── 资讯列表（分页） ──────────────────────────────────
  Future<ApiResponse<Map<String, dynamic>>> getArticles({
    required int pageNum,
    required int pageSize,
  }) async {
    try {
      final response = await _dio.get(
        ApiConfig.articles,
        queryParameters: {'pageNum': pageNum, 'pageSize': pageSize},
      );
      final body = response.data as Map<String, dynamic>;
      final pageData = body['data'] as Map<String, dynamic>?;
      if (pageData != null) {
        final list = (pageData['list'] as List<dynamic>?)
                ?.map((e) => ArticleModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];
        return ApiResponse(
          code: body['code'] as int? ?? 200,
          message: body['message'] as String? ?? 'success',
          data: {
            'total': pageData['total'] ?? 0,
            'pageNum': pageData['pageNum'] ?? pageNum,
            'pageSize': pageData['pageSize'] ?? pageSize,
            'pages': pageData['pages'] ?? 0,
            'list': list,
          },
        );
      }
      return const ApiResponse(code: 0, message: '数据格式异常');
    } on DioException catch (e) {
      return ApiResponse(
        code: e.response?.statusCode ?? -1,
        message: e.message ?? '网络请求失败',
      );
    } catch (e) {
      return ApiResponse(code: -1, message: e.toString());
    }
  }

  // ── 用户信息 ──────────────────────────────────────────
  Future<ApiResponse<UserModel?>> getUserInfo(String userId) async {
    try {
      final response = await _dio.get(
        ApiConfig.userInfo,
        queryParameters: {'userId': userId},
      );
      final body = response.data as Map<String, dynamic>;
      final inner = body['data'];
      final user = inner != null && inner is Map<String, dynamic>
          ? UserModel.fromJson(inner)
          : null;
      return ApiResponse(
        code: body['code'] as int? ?? 200,
        message: body['message'] as String? ?? 'success',
        data: user,
      );
    } on DioException catch (e) {
      return ApiResponse(
        code: e.response?.statusCode ?? -1,
        message: e.message ?? '网络请求失败',
      );
    } catch (e) {
      return ApiResponse(code: -1, message: e.toString());
    }
  }
}
