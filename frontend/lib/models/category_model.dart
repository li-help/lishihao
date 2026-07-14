class CategoryModel {
  final int id;
  final String name;
  final String iconUrl;
  final String route;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.iconUrl,
    required this.route,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      iconUrl: json['iconUrl'] as String? ?? '',
      route: json['route'] as String? ?? '',
    );
  }

  static List<CategoryModel> get mockData => [
        const CategoryModel(
          id: 1,
          name: '热门推荐',
          iconUrl: 'https://picsum.photos/seed/cat1/96/96',
          route: '/hot',
        ),
        const CategoryModel(
          id: 2,
          name: '最新资讯',
          iconUrl: 'https://picsum.photos/seed/cat2/96/96',
          route: '/news',
        ),
        const CategoryModel(
          id: 3,
          name: '技术文章',
          iconUrl: 'https://picsum.photos/seed/cat3/96/96',
          route: '/tech',
        ),
        const CategoryModel(
          id: 4,
          name: '实用教程',
          iconUrl: 'https://picsum.photos/seed/cat4/96/96',
          route: '/tutorial',
        ),
        const CategoryModel(
          id: 5,
          name: '产品动态',
          iconUrl: 'https://picsum.photos/seed/cat5/96/96',
          route: '/product',
        ),
        const CategoryModel(
          id: 6,
          name: '行业趋势',
          iconUrl: 'https://picsum.photos/seed/cat6/96/96',
          route: '/trend',
        ),
        const CategoryModel(
          id: 7,
          name: '活动专区',
          iconUrl: 'https://picsum.photos/seed/cat7/96/96',
          route: '/event',
        ),
        const CategoryModel(
          id: 8,
          name: '更多',
          iconUrl: 'https://picsum.photos/seed/cat8/96/96',
          route: '/more',
        ),
      ];
}
