import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../../widgets/hero_banner.dart';
import '../../widgets/media_card.dart';
import '../../widgets/error_view.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/media_model.dart';

class HomeView extends StatefulWidget {
  final Function(Media) onMediaTap;

  const HomeView({super.key, required this.onMediaTap});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().loadHomeData();
    });
  }

  void _onScroll() {
    final scrolled = _scrollController.offset > 10;
    if (scrolled != _isScrolled) {
      setState(() => _isScrolled = scrolled);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Consumer<HomeViewModel>(
        builder: (context, vm, _) {
          // Loading State
          if (vm.isLoading && !vm.hasData) {
            return _buildSkeleton();
          }

          // Error State
          if (vm.hasError && !vm.hasData) {
            return ErrorView(
              message: vm.errorMessage,
              onRetry: vm.refresh,
            );
          }

          // Success State
          return _buildContent(vm);
        },
      ),
    );
  }

  // ── App Bar ───────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _isScrolled
          ? AppTheme.background.withOpacity(0.97)
          : Colors.transparent,
      elevation: _isScrolled ? 4 : 0,
      title: const Text(
        'NETFLIX',
        style: TextStyle(
          color:         AppTheme.netflixRed,
          fontSize:      22,
          fontWeight:    FontWeight.w900,
          letterSpacing: 3,
        ),
      ),
      actions: [
        // Cast Icon
        IconButton(
          icon: const Icon(Icons.cast, color: AppTheme.textPrimary),
          onPressed: () {},
        ),
        // Profile Avatar
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () {},
            child: const CircleAvatar(
              radius:          16,
              backgroundColor: AppTheme.netflixRed,
              child: Icon(Icons.person, color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }

  // ── Main Content ──────────────────────────────────────
  Widget _buildContent(HomeViewModel vm) {
    return RefreshIndicator(
      color:           AppTheme.netflixRed,
      backgroundColor: AppTheme.surfaceColor,
      onRefresh:       vm.refresh,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Banner
                if (vm.featuredMedia != null)
                  HeroBanner(
                    media:     vm.featuredMedia!,
                    onPlayTap: () => widget.onMediaTap(vm.featuredMedia!),
                    onInfoTap: () => widget.onMediaTap(vm.featuredMedia!),
                  ),

                // Category Filter Tabs
                const SizedBox(height: 8),
                _CategoryTabs(),
                const SizedBox(height: 4),

                MediaRow(
                  title:      '🔥 Trending Now',
                  items:      vm.trending,
                  onMediaTap: widget.onMediaTap,
                  cardWidth:  130,
                  cardHeight: 195,
                ),
                MediaRow(
                  title:      '🎬 Popular Movies',
                  items:      vm.popularMovies,
                  onMediaTap: widget.onMediaTap,
                ),
                MediaRow(
                  title:      '⭐ Top Rated',
                  items:      vm.topRated,
                  onMediaTap: widget.onMediaTap,
                  showRating: true,
                ),
                MediaRow(
                  title:      '📺 Popular TV Shows',
                  items:      vm.popularTv,
                  onMediaTap: widget.onMediaTap,
                ),
                MediaRow(
                  title:      '🗓️ Coming Soon',
                  items:      vm.upcoming,
                  onMediaTap: widget.onMediaTap,
                ),

                const SizedBox(height: 90),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Skeleton Loader ───────────────────────────────────
  Widget _buildSkeleton() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero skeleton
          Container(
            height: MediaQuery.of(context).size.height * 0.55,
            color:  AppTheme.cardColor,
            child: const Center(
              child: CircularProgressIndicator(
                color: AppTheme.netflixRed,
              ),
            ),
          ),

          // Row skeletons
          ...List.generate(3, (_) {
            return Padding(
              padding: const EdgeInsets.only(top: 24, left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row title skeleton
                  Container(
                    width:  160,
                    height: 16,
                    decoration: BoxDecoration(
                      color:        AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Cards skeleton
                  SizedBox(
                    height: 180,
                    child: ListView.separated(
                      scrollDirection:  Axis.horizontal,
                      physics:          const NeverScrollableScrollPhysics(),
                      itemCount:        5,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (_, __) => Container(
                        width: 120,
                        decoration: BoxDecoration(
                          color:        AppTheme.cardColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ── Category Filter Tabs ──────────────────────────────────
class _CategoryTabs extends StatefulWidget {
  @override
  State<_CategoryTabs> createState() => _CategoryTabsState();
}

class _CategoryTabsState extends State<_CategoryTabs> {
  int _selected = 0;

  final List<String> _tabs = [
    'All',
    'Movies',
    'TV Shows',
    'My List',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection:  Axis.horizontal,
        padding:          const EdgeInsets.symmetric(horizontal: 16),
        itemCount:        _tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final isSelected = i == _selected;
          return GestureDetector(
            onTap: () => setState(() => _selected = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical:    6,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.textPrimary
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppTheme.textPrimary
                      : AppTheme.textMuted,
                  width: 0.8,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _tabs[i],
                style: TextStyle(
                  color: isSelected
                      ? AppTheme.background
                      : AppTheme.textPrimary,
                  fontSize:   13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}