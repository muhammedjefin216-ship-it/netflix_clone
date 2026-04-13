import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home/home_view.dart';
import 'search/search_view.dart';
import 'detail/detail_view.dart';
import 'watchlist/watchlist_view.dart';
import 'profile/profile_view.dart';
import '../viewmodels/detail_viewmodel.dart';
import '../viewmodels/watchlist_viewmodel.dart';
import '../../data/models/media_model.dart';
import '../../data/repositories/media_repository.dart';
import '../../core/theme/app_theme.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  void _openDetail(BuildContext context, Media media) {
    final repo = context.read<MediaRepository>();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (_) => DetailViewModel(repo),
          child: DetailView(
            mediaId:   media.id,
            mediaType: media.mediaType,
            onMediaTap: (m) => _openDetail(context, m),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeView(
            onMediaTap: (m) => _openDetail(context, m),
          ),

          SearchView(
            onMediaTap: (m) => _openDetail(context, m),
          ),

          WatchlistView(
            onMediaTap: (m) => _openDetail(context, m),
          ),

           ProfileView(),
        ],
      ),

      bottomNavigationBar: Container(
        decoration:  BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppTheme.dividerColor,
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex:          _currentIndex,
          onTap:                 (i) => setState(() => _currentIndex = i),
          backgroundColor:       AppTheme.background,
          selectedItemColor:     AppTheme.textPrimary,
          unselectedItemColor:   AppTheme.textMuted,
          showSelectedLabels:    true,
          showUnselectedLabels:  true,
          selectedFontSize:      11,
          unselectedFontSize:    11,
          type: BottomNavigationBarType.fixed,
          items: [
             BottomNavigationBarItem(
              icon:       Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label:      'Home',
            ),

             BottomNavigationBarItem(
              icon:       Icon(Icons.search),
              activeIcon: Icon(Icons.search),
              label:      'Search',
            ),

            BottomNavigationBarItem(
              icon: Consumer<WatchlistViewModel>(
                builder: (_, vm, __) => Badge(
                  isLabelVisible: vm.count > 0,
                  label:          Text('${vm.count}'),
                  child:  Icon(Icons.bookmark_outline),
                ),
              ),
              activeIcon: Consumer<WatchlistViewModel>(
                builder: (_, vm, __) => Badge(
                  isLabelVisible: vm.count > 0,
                  label:          Text('${vm.count}'),
                  child:  Icon(Icons.bookmark),
                ),
              ),
              label: 'My List',
            ),

             BottomNavigationBarItem(
              icon:       Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label:      'My Netflix',
            ),
          ],
        ),
      ),
    );
  }
}