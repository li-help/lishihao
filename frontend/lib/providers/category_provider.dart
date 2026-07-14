import 'package:flutter/foundation.dart';
import '../models/category_model.dart';
import '../repositories/home_repository.dart';

class CategoryProvider extends ChangeNotifier {
  final HomeRepository _homeRepository = HomeRepository();

  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  List<CategoryModel> _categories = [];

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  List<CategoryModel> get categories => _categories;

  Future<void> loadCategories() async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();

    final response = await _homeRepository.getCategories();

    if (response.isSuccess && response.data != null) {
      _categories = response.data!;
      _hasError = false;
    } else {
      _hasError = true;
      _errorMessage = response.message;
      _categories = CategoryModel.mockData;
    }

    _isLoading = false;
    notifyListeners();
  }
}
