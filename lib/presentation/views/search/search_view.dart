import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../viewmodels/search_viewmodel.dart';
import '../../widgets/error_view.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/media_model.dart';

import 'search_bar.dart';
import 'search_results.dart';
import 'search_trending.dart';

class SearchView extends StatefulWidget {
  final Function(Media) onMediaTap;

  const SearchView({super.key, required this.onMediaTap});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchViewModel>().loadTrending();
    });
  }

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
        title: Text(
          'Search',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          SearchBarWidget(
            controller: _controller,
            focusNode: _focusNode,
            onChanged: _onSearchChanged,
            onClear: _onClear,
          ),

          Expanded(
            child: Consumer<SearchViewModel>(
              builder: (context, vm, _) {
                if (vm.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (vm.hasError) {
                  return ErrorView(
                    message: vm.error,
                    icon: Icons.search_off,
                  );
                }

                if (vm.isSearching && vm.hasResults) {
                  return SearchResults(
                    results: vm.results,
                    onTap: widget.onMediaTap,
                  );
                }

                if (vm.isSearching && !vm.hasResults) {
                  return Center(
                    child: Text(
                      'No results for "${vm.query}"',
                      style: const TextStyle(color: AppTheme.textMuted),
                    ),
                  );
                }

                return SearchTrending(
                  trending: vm.trending,
                  onTap: widget.onMediaTap,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}