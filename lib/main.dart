import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/media_repository.dart';
import 'presentation/viewmodels/home_viewmodel.dart';
import 'presentation/viewmodels/search_viewmodel.dart';
import 'presentation/viewmodels/detail_viewmodel.dart';
import 'presentation/viewmodels/watchlist_viewmodel.dart';
import 'presentation/views/splash/splash_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Status bar transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.background,
    ),
  );

  runApp(const NetflixCloneApp());
}

class NetflixCloneApp extends StatelessWidget {
  const NetflixCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ── Repository ──────────────────────────────────
        // Single instance shared across all ViewModels
        Provider<MediaRepository>(create: (_) => MediaRepository()),

        // ── ViewModels ──────────────────────────────────
        ChangeNotifierProxyProvider<MediaRepository, HomeViewModel>(
          create: (ctx) => HomeViewModel(ctx.read<MediaRepository>()),
          update: (_, repo, vm) => vm ?? HomeViewModel(repo),
        ),

        ChangeNotifierProxyProvider<MediaRepository, SearchViewModel>(
          create: (ctx) => SearchViewModel(ctx.read<MediaRepository>()),
          update: (_, repo, vm) => vm ?? SearchViewModel(repo),
        ),

        ChangeNotifierProxyProvider<MediaRepository, DetailViewModel>(
          create: (ctx) => DetailViewModel(ctx.read<MediaRepository>()),
          update: (_, repo, vm) => vm ?? DetailViewModel(repo),
        ),

        ChangeNotifierProvider<WatchlistViewModel>(
          create: (_) => WatchlistViewModel()..load(),
        ),
      ],
      child: MaterialApp(
        title: 'Netflix Clone',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const SplashView(),
      ),
    );
  }
}
