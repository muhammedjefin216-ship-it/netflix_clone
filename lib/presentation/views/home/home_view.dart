import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../../widgets/error_view.dart';
import '../../../data/models/media_model.dart';
import 'home_appbar.dart';
import 'home_content.dart';

class HomeView extends StatefulWidget {
  final Function(Media) onMediaTap;

  const HomeView({super.key, required this.onMediaTap});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  int _selectedCategory = 0;

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
      appBar: HomeAppBar(isScrolled: _isScrolled),
      body: Consumer<HomeViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading && !vm.hasData) {
            return  Center(child: CircularProgressIndicator());
          }

          if (vm.hasError && !vm.hasData) {
            return ErrorView(
              message: vm.errorMessage,
              onRetry: vm.refresh,
            );
          }

          return HomeContent(
            vm: vm,
            scrollController: _scrollController,
            selectedCategory: _selectedCategory,
            onCategoryChanged: (index) {
              setState(() => _selectedCategory = index);
            },
            onMediaTap: widget.onMediaTap,
          );
        },
      ),
    );
  }
}