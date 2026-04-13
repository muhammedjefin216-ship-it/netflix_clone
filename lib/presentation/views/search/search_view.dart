import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../viewmodels/search_viewmodel.dart';
import '../../widgets/media_card.dart';
import '../../widgets/error_view.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/media_model.dart';

class SearchView extends StatefulWidget {
  final Function(Media) onMediaTap;

  const SearchView({super.key, required this.onMediaTap});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode             _focusNode  = FocusNode();
  Timer?                      _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchViewModel>().loadTrending();
    });
  }

  // ── Debounced Search (500ms) ──────────────────────────
  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<SearchViewModel>().search(value);
    });
  }

  void _onClear() {
    _controller.clear();
    _focusNode.unfocus();
    context.read<SearchViewModel>().clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        title: const Text(
          'Search',
          style: TextStyle(
            fontSize:   22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          _buildSearchBar(),

          // Results
          Expanded(
            child: Consumer<SearchViewModel>(
              builder: (context, vm, _) {
                // Loading
                if (vm.isLoading) {
                  return const LoadingView(message: 'Searching...');
                }

                // Error
                if (vm.hasError) {
                  return ErrorView(
                    message: vm.error,
                    icon:    Icons.search_off,
                  );
                }

                // Search Results
                if (vm.isSearching && vm.hasResults) {
                  return _buildResultsGrid(vm.results);
                }

                // No Results Found
                if (vm.isSearching && !vm.hasResults) {
                  return _buildNoResults(vm.query);
                }

                // Default — show Trending
                return _buildTrendingSection(vm.trending);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Search Bar ────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: TextField(
        controller:  _controller,
        focusNode:   _focusNode,
        onChanged:   _onSearchChanged,
        style: const TextStyle(color: AppTheme.textPrimary),
        decoration: InputDecoration(
          hintText:    'Search movies, TV shows...',
          prefixIcon:  const Icon(Icons.search, color: AppTheme.textMuted),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon:      const Icon(Icons.close, color: AppTheme.textMuted),
                  onPressed: _onClear,
                )
              : null,
          filled:    true,
          fillColor: AppTheme.surfaceColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:   BorderSide.none,
          ),
          hintStyle: const TextStyle(color: AppTheme.textMuted),
        ),
      ),
    );
  }

  // ── Search Results Grid ───────────────────────────────
  Widget _buildResultsGrid(List<Media> results) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Results count
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Text(
            '${results.length} results found',
            style: const TextStyle(
              color:    AppTheme.textMuted,
              fontSize: 13,
            ),
          ),
        ),

        // Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:   3,
              childAspectRatio: 0.6,
              crossAxisSpacing: 8,
              mainAxisSpacing:  8,
            ),
            itemCount:   results.length,
            itemBuilder: (_, i) {
              final media = results[i];
              return GestureDetector(
                onTap: () => widget.onMediaTap(media),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card
                    Expanded(
                      child: MediaCard(
                        media:  media,
                        width:  double.infinity,
                        height: double.infinity,
                        onTap:  () => widget.onMediaTap(media),
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Title
                    Text(
                      media.displayTitle,
                      maxLines:  1,
                      overflow:  TextOverflow.ellipsis,
                      style: const TextStyle(
                        color:    AppTheme.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── No Results ────────────────────────────────────────
  Widget _buildNoResults(String query) {
    return EmptyView(
      icon:     Icons.search_off_rounded,
      message:  'No results for "$query"',
      subtitle: 'Try different keywords or check your spelling',
    );
  }

  // ── Trending Section ──────────────────────────────────
  Widget _buildTrendingSection(List<Media> trending) {
    if (trending.isEmpty) {
      return const LoadingView(message: 'Loading trending...');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 4, 16, 12),
          child: Row(
            children: [
              Icon(
                Icons.local_fire_department,
                color: AppTheme.netflixRed,
                size:  20,
              ),
              SizedBox(width: 8),
              Text(
                'Trending',
                style: TextStyle(
                  color:      AppTheme.textPrimary,
                  fontSize:   18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // Trending Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:   3,
              childAspectRatio: 0.6,
              crossAxisSpacing: 8,
              mainAxisSpacing:  8,
            ),
            itemCount:   trending.length,
            itemBuilder: (_, i) {
              final media = trending[i];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: MediaCard(
                      media:  media,
                      width:  double.infinity,
                      height: double.infinity,
                      onTap:  () => widget.onMediaTap(media),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    media.displayTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color:    AppTheme.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}