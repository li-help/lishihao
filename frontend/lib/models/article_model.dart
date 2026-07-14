class ArticleModel {
  final int id;
  final String title;
  final String summary;
  final String coverUrl;
  final String createTime;

  const ArticleModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.coverUrl,
    required this.createTime,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      coverUrl: json['coverUrl'] as String? ?? '',
      createTime: json['createTime'] as String? ?? '',
    );
  }

  static List<ArticleModel> get mockData => [
        const ArticleModel(
          id: 1,
          title: 'Flutter 3.24 新特性全面解析，带你快速上手最新版本',
          summary: 'Flutter 3.24 带来了许多令人兴奋的新功能，包括性能优化、新的Widget以及开发工具的改进。',
          coverUrl: 'https://picsum.photos/seed/article1/200/160',
          createTime: '2026-07-10',
        ),
        const ArticleModel(
          id: 2,
          title: 'Dart 语言进阶：深入理解异步编程与Stream',
          summary: '掌握Dart中的Future、async/await以及Stream的使用技巧，提升代码质量。',
          coverUrl: 'https://picsum.photos/seed/article2/200/160',
          createTime: '2026-07-09',
        ),
        const ArticleModel(
          id: 3,
          title: '移动端架构最佳实践：Clean Architecture在Flutter中的应用',
          summary: '探讨如何在大型Flutter项目中应用Clean Architecture，实现可维护的代码结构。',
          coverUrl: 'https://picsum.photos/seed/article3/200/160',
          createTime: '2026-07-08',
        ),
        const ArticleModel(
          id: 4,
          title: '跨平台开发趋势2026：Flutter vs React Native全面对比',
          summary: '从性能、生态、开发体验等多个维度对比两大跨平台框架的最新发展。',
          coverUrl: 'https://picsum.photos/seed/article4/200/160',
          createTime: '2026-07-07',
        ),
        const ArticleModel(
          id: 5,
          title: 'Flutter性能优化实战：从60fps到120fps的调优之路',
          summary: '通过实际案例分析Flutter应用性能瓶颈，分享实用的性能优化技巧。',
          coverUrl: 'https://picsum.photos/seed/article5/200/160',
          createTime: '2026-07-06',
        ),
      ];
}
