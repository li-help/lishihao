class BannerModel {
  final int id;
  final String imageUrl;
  final String linkUrl;
  final int sortOrder;

  const BannerModel({
    required this.id,
    required this.imageUrl,
    required this.linkUrl,
    required this.sortOrder,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] as int? ?? 0,
      imageUrl: json['imageUrl'] as String? ?? '',
      linkUrl: json['linkUrl'] as String? ?? '',
      sortOrder: json['sortOrder'] as int? ?? 0,
    );
  }

  static List<BannerModel> get mockData => [
        const BannerModel(
          id: 1,
          imageUrl: 'https://picsum.photos/seed/banner1/800/400',
          linkUrl: '/promo/1',
          sortOrder: 1,
        ),
        const BannerModel(
          id: 2,
          imageUrl: 'https://picsum.photos/seed/banner2/800/400',
          linkUrl: '/promo/2',
          sortOrder: 2,
        ),
        const BannerModel(
          id: 3,
          imageUrl: 'https://picsum.photos/seed/banner3/800/400',
          linkUrl: '/promo/3',
          sortOrder: 3,
        ),
      ];
}
