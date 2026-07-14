import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/design_tokens.dart';
import '../models/article_model.dart';
import '../models/banner_model.dart';
import '../models/category_model.dart';
import '../providers/article_provider.dart';
import '../providers/banner_provider.dart';
import '../providers/category_provider.dart';
import '../widgets/cached_image.dart';
import '../widgets/empty_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PageController _bannerController;
  Timer? _bannerTimer;
  int _currentBannerIndex = 0;

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _bannerController = PageController();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Load data after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BannerProvider>().loadBanners();
      context.read<CategoryProvider>().loadCategories();
      context.read<ArticleProvider>().loadArticles();
    });
  }

  void _startAutoPlay(int bannerCount) {
    _bannerTimer?.cancel();
    if (bannerCount <= 1) return;
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;
      if (!_bannerController.hasClients) return;
      _currentBannerIndex = (_currentBannerIndex + 1) % bannerCount;
      _bannerController.animateToPage(
        _currentBannerIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= maxScroll * 0.8) {
      context.read<ArticleProvider>().loadMore();
    }
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.backgroundColor,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        color: DesignTokens.primaryColor,
        onRefresh: () async {
          await Future.wait([
            context.read<BannerProvider>().loadBanners(),
            context.read<CategoryProvider>().loadCategories(),
            context.read<ArticleProvider>().refresh(),
          ]);
        },
        child: ListView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            _buildBannerCarousel(),
            _buildCategoryGrid(),
            _buildArticleSection(),
          ],
        ),
      ),
    );
  }

  // ── 1. AppBar ───────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(DesignTokens.appBarHeight),
      child: AppBar(
        backgroundColor: DesignTokens.primaryColor,
        titleSpacing: DesignTokens.spacing16,
        title: Row(
          children: [
            const Icon(
              Icons.home,
              color: DesignTokens.whiteColor,
              size: DesignTokens.appBarIconSize,
            ),
            const SizedBox(width: DesignTokens.spacing8),
            const Text(
              '首页展示',
              style: DesignTokens.appBarTitleStyle,
            ),
          ],
        ),
        actions: [
          InkWell(
            onTap: () {},
            splashColor: Colors.white24,
            borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSmall),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacing12),
              child: Icon(
                Icons.search,
                color: DesignTokens.whiteColor,
                size: DesignTokens.appBarIconSize,
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            splashColor: Colors.white24,
            borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSmall),
            child: const Padding(
              padding: EdgeInsets.only(
                right: DesignTokens.spacing16,
                left: DesignTokens.spacing4,
              ),
              child: Icon(
                Icons.message_outlined,
                color: DesignTokens.whiteColor,
                size: DesignTokens.appBarIconSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── 2. Banner Carousel ─────────────────────────────────
  Widget _buildBannerCarousel() {
    return Selector<BannerProvider, List<BannerModel>>(
      selector: (context, provider) => provider.banners,
      builder: (context, banners, child) {
        if (banners.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(
              vertical: DesignTokens.spacing12,
              horizontal: DesignTokens.spacing16,
            ),
            child: SizedBox(
              height: 180,
              child: LoadingWidget(),
            ),
          );
        }

        // Start auto-play after first build with banners
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _startAutoPlay(banners.length);
        });

        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: DesignTokens.spacing12,
            horizontal: DesignTokens.spacing16,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 180,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    DesignTokens.borderRadiusMedium,
                  ),
                  child: PageView.builder(
                    controller: _bannerController,
                    onPageChanged: (index) {
                      _currentBannerIndex = index;
                    },
                    itemCount: banners.length,
                    itemBuilder: (context, index) {
                      return AppCachedImage(
                        imageUrl: banners[index].imageUrl,
                        width: double.infinity,
                        height: 180,
                      );
                    },
                  ),
                ),
              ),
              if (banners.length > 1) ...[
                const SizedBox(height: DesignTokens.spacing8),
                _buildDotIndicators(banners.length),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildDotIndicators(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == _currentBannerIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? DesignTokens.primaryColor
                : DesignTokens.inactiveDotColor,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  // ── 3. Category Grid ────────────────────────────────────
  Widget _buildCategoryGrid() {
    return Selector<CategoryProvider, List<CategoryModel>>(
      selector: (context, provider) => provider.categories,
      builder: (context, categories, child) {
        if (categories.isEmpty) {
          return const SizedBox(
            height: 120,
            child: LoadingWidget(),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: DesignTokens.spacing12,
            horizontal: DesignTokens.spacing16,
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: DesignTokens.spacing12,
              crossAxisSpacing: DesignTokens.spacing8,
              childAspectRatio: 0.85,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return _buildCategoryItem(categories[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildCategoryItem(CategoryModel category) {
    return InkWell(
      onTap: () {},
      splashColor: DesignTokens.primaryColor.withOpacity( 0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipOval(
            child: AppCachedImage(
              imageUrl: category.iconUrl,
              width: 32,
              height: 32,
            ),
          ),
          const SizedBox(height: DesignTokens.spacing4),
          Text(
            category.name,
            style: DesignTokens.hintStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ── 4 & 5. Article Section ──────────────────────────────
  Widget _buildArticleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildArticleHeader(),
        _buildArticleList(),
      ],
    );
  }

  Widget _buildArticleHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacing16,
        vertical: DesignTokens.spacing12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '推荐资讯',
            style: DesignTokens.sectionTitleStyle,
          ),
          InkWell(
            onTap: () {},
            splashColor: DesignTokens.primaryColor.withOpacity( 0.1),
            borderRadius:
                BorderRadius.circular(DesignTokens.borderRadiusSmall),
            child: const Padding(
              padding: EdgeInsets.all(DesignTokens.spacing4),
              child: Text(
                '更多',
                style: DesignTokens.linkTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleList() {
    return Selector<ArticleProvider, ArticleListState>(
      selector: (context, provider) => ArticleListState(
        isLoading: provider.isLoading,
        hasError: provider.hasError,
        errorMessage: provider.errorMessage,
        articles: provider.articles,
        hasMore: provider.hasMore,
        isLoadingMore: provider.isLoadingMore,
      ),
      builder: (context, state, child) {
        if (state.isLoading) {
          return const SizedBox(
            height: 200,
            child: LoadingWidget(),
          );
        }

        if (state.hasError && state.articles.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(DesignTokens.spacing16),
            child: AppErrorWidget(
              message: state.errorMessage,
              onRetry: () =>
                  context.read<ArticleProvider>().loadArticles(),
            ),
          );
        }

        if (state.articles.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: DesignTokens.spacing16),
            child: EmptyWidget(),
          );
        }

        return Column(
          children: [
            ...state.articles.map(
              (article) => _buildArticleCard(article),
            ),
            if (state.isLoadingMore)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: DesignTokens.spacing16),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: DesignTokens.primaryColor,
                  ),
                ),
              ),
            if (!state.hasMore && state.articles.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(DesignTokens.spacing16),
                child: Text(
                  '— 没有更多了 —',
                  style: DesignTokens.hintStyle,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildArticleCard(ArticleModel article) {
    return InkWell(
      onTap: () {},
      splashColor: DesignTokens.primaryColor.withOpacity( 0.1),
      child: Container(
        height: 110,
        margin: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacing16,
          vertical: DesignTokens.spacing4,
        ),
        padding: const EdgeInsets.all(DesignTokens.spacing8),
        decoration: BoxDecoration(
          color: DesignTokens.whiteColor,
          borderRadius: BorderRadius.circular(
            DesignTokens.borderRadiusSmall + 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity( 0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left image
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(DesignTokens.borderRadiusSmall),
              child: AppCachedImage(
                imageUrl: article.coverUrl,
                width: 100,
                height: 80,
              ),
            ),
            const SizedBox(width: DesignTokens.spacing12),
            // Right text area
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: DesignTokens.titleColor,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Text(
                    article.summary,
                    style: DesignTokens.hintStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: DesignTokens.spacing4),
                  Text(
                    article.createTime,
                    style: DesignTokens.hintStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helper class for Selector ─────────────────────────────
class ArticleListState {
  final bool isLoading;
  final bool hasError;
  final String errorMessage;
  final List<ArticleModel> articles;
  final bool hasMore;
  final bool isLoadingMore;

  const ArticleListState({
    required this.isLoading,
    required this.hasError,
    required this.errorMessage,
    required this.articles,
    required this.hasMore,
    required this.isLoadingMore,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ArticleListState &&
        other.isLoading == isLoading &&
        other.hasError == hasError &&
        other.errorMessage == errorMessage &&
        other.hasMore == hasMore &&
        other.isLoadingMore == isLoadingMore &&
        identical(other.articles, articles);
  }

  @override
  int get hashCode => Object.hash(
        isLoading,
        hasError,
        errorMessage,
        hasMore,
        isLoadingMore,
        articles.length,
      );
}
