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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
     SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.background,
    ),
  );

  runApp( NetflixCloneApp());
}

class NetflixCloneApp extends StatelessWidget {
  const NetflixCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => MediaRepository(),
        ),

        ChangeNotifierProvider(
          create: (context) =>
              HomeViewModel(context.read<MediaRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              SearchViewModel(context.read<MediaRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              DetailViewModel(context.read<MediaRepository>()),
        ),

        ChangeNotifierProvider(
          create: (_) => WatchlistViewModel()..load(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Netflix Clone',
        theme: AppTheme.darkTheme,

        home:  SplashView(),
      ),
    );
  }
}