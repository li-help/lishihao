import 'package:flutter/foundation.dart';
import '../models/article_model.dart';
import '../repositories/home_repository.dart';

class ArticleProvider extends ChangeNotifier {
  final HomeRepository _homeRepository = HomeRepository();

  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  List<ArticleModel> _articles = [];

  int _pageNum = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  static const int _pageSize = 10;

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  List<ArticleModel> get articles => _articles;
  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  /// 首次加载 / 下拉刷新
  Future<void> loadArticles() async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    _pageNum = 1;
    _hasMore = true;
    notifyListeners();

    final response = await _homeRepository.getArticles(
      pageNum: _pageNum,
      pageSize: _pageSize,
    );

    if (response.isSuccess && response.data != null) {
      final pageData = response.data!;
      final list = (pageData['list'] as List<dynamic>?)
              ?.map((e) => e as ArticleModel)
              .toList() ??
          [];
      _articles = list;
      _hasMore = _articles.length >= _pageSize;
      _hasError = false;
    } else {
      _hasError = true;
      _errorMessage = response.message;
      _articles = ArticleModel.mockData;
      _hasMore = _articles.length >= _pageSize;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// 上拉加载更多
  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    _pageNum++;
    final response = await _homeRepository.getArticles(
      pageNum: _pageNum,
      pageSize: _pageSize,
    );

    if (response.isSuccess && response.data != null) {
      final pageData = response.data!;
      final list = (pageData['list'] as List<dynamic>?)
              ?.map((e) => e as ArticleModel)
              .toList() ??
          [];
      _articles = [..._articles, ...list];
      _hasMore = list.length >= _pageSize;
    } else {
      _hasMore = false;
      _pageNum--; // 回退页码
    }

    _isLoadingMore = false;
    notifyListeners();
  }

  /// 下拉刷新
  Future<void> refresh() async {
    return loadArticles();
  }
}
