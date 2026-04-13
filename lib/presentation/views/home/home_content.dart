import 'package:flutter/material.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../../widgets/hero_banner.dart';
import '../../widgets/media_card.dart';
import '../../../data/models/media_model.dart';
import '../watchlist/watchlist_view.dart';
import 'category_tabs.dart';
import 'category_section.dart';

class HomeContent extends StatelessWidget {
  final HomeViewModel vm;
  final ScrollController scrollController;
  final int selectedCategory;
  final Function(int) onCategoryChanged;
  final Function(Media) onMediaTap;

const HomeContent({
    super.key,
    required this.vm,
    required this.scrollController,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.onMediaTap,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: vm.refresh,
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (vm.featuredMedia != null)
                  HeroBanner(
                    media: vm.featuredMedia!,
                    onPlayTap: () => onMediaTap(vm.featuredMedia!),
                    onInfoTap: () => onMediaTap(vm.featuredMedia!),
                  ),

               SizedBox(height: 8),

                CategoryTabs(
                  selectedIndex: selectedCategory,
                  onTap: (index) {
                    if (index == 3) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WatchlistView(
                            onMediaTap: onMediaTap,
                          ),
                        ),
                      );
                    } else {
                      onCategoryChanged(index);
                    }
                  },
                ),

               SizedBox(height: 16),

                _buildContent(),

               SizedBox(height: 90),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (selectedCategory) {
      case 0:
        return Column(
          children: [
            MediaRow(
              title: '🔥 Trending Now',
              items: vm.trending,
              onMediaTap: onMediaTap,
            ),
            MediaRow(
              title: '🎬 Popular Movies',
              items: vm.popularMovies,
              onMediaTap: onMediaTap,
            ),
          ],
        );

      case 1:
        return CategorySection(
          title: '🎬 Movies',
          items: vm.popularMovies,
          onMediaTap: onMediaTap,
        );

      case 2:
        return CategorySection(
          title: '📺 TV Shows',
          items: vm.popularTv,
          onMediaTap: onMediaTap,
        );

      default:
        return SizedBox();
    }
  }
}