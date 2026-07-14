import 'package:flutter/foundation.dart';
import '../models/banner_model.dart';
import '../repositories/home_repository.dart';

class BannerProvider extends ChangeNotifier {
  final HomeRepository _homeRepository = HomeRepository();

  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  List<BannerModel> _banners = [];

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  List<BannerModel> get banners => _banners;

  Future<void> loadBanners() async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();

    final response = await _homeRepository.getBanners();

    if (response.isSuccess && response.data != null) {
      _banners = response.data!;
      _hasError = false;
    } else {
      _hasError = true;
      _errorMessage = response.message;
      // Fallback to mock data on error
      _banners = BannerModel.mockData;
    }

    _isLoading = false;
    notifyListeners();
  }
}
