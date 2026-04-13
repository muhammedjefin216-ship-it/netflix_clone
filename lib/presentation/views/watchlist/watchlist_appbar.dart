import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/watchlist_viewmodel.dart';
import '../../../core/theme/app_theme.dart';

class WatchlistAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WatchlistAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.background,
      title: Text(
        'My List',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      actions: [
        Consumer<WatchlistViewModel>(
          builder: (context, vm, _) {
            if (vm.isEmpty) return SizedBox();

            return TextButton(
              onPressed: () => _showClearDialog(context, vm),
              child: Text(
                'Clear All',
                style: TextStyle(color: AppTheme.netflixRed),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showClearDialog(BuildContext context, WatchlistViewModel vm) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: Text('Clear My List'),
        content: Text('Remove all items?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              vm.clearAll();
              Navigator.pop(context);
            },
            child: Text(
              'Clear All',
              style: TextStyle(color: AppTheme.netflixRed),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
