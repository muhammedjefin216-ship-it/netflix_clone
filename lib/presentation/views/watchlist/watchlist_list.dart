import 'package:flutter/material.dart';
import '../../viewmodels/watchlist_viewmodel.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/media_model.dart';
import 'watchlist_tile.dart';

class WatchlistList extends StatelessWidget {
  final WatchlistViewModel vm;
  final Function(Media) onMediaTap;

  const WatchlistList({
    super.key,
    required this.vm,
    required this.onMediaTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:  EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Row(
            children: [
              Text(
                '${vm.count} titles',
                style:  TextStyle(color: AppTheme.textMuted),
              ),
               Spacer(),
               Text(
                'Swipe to remove',
                style: TextStyle(color: AppTheme.textMuted, fontSize: 11),
              ),
            ],
          ),
        ),
         Divider(),

        Expanded(
          child: ListView.builder(
            itemCount: vm.items.length,
            itemBuilder: (_, i) {
              final media = vm.items[i];
              return WatchlistTile(
                media: media,
                onTap: () => onMediaTap(media),
                onRemove: () => vm.remove(media.id),
              );
            },
          ),
        ),
      ],
    );
  }
}