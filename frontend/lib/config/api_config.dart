class ApiConfig {
  ApiConfig._();

  // 修改为你的服务器公网IP或域名
  static const String baseUrl = 'http://123.56.160.50/api';

  // ── 首页接口 ───────────────────────────────────────────
  static const String banners = '/home/banner';
  static const String categories = '/home/category';
  static const String articles = '/home/list';
  static const String userInfo = '/user/info';
}
