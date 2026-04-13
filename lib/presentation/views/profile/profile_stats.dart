import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/watchlist_viewmodel.dart';
import '../../../core/theme/app_theme.dart';
import 'profile_widgets.dart';

class ProfileStats extends StatelessWidget {
  const ProfileStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WatchlistViewModel>(
      builder: (_, vm, __) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StatItem(value: '${vm.count}', label: 'My List'),
              VerticalDividerWidget(),
              StatItem(value: '0', label: 'Downloads'),
              VerticalDividerWidget(),
              StatItem(value: '0', label: 'Watched'),
            ],
          ),
        );
      },
    );
  }
}
