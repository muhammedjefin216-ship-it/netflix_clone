import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/detail_viewmodel.dart';
import '../../viewmodels/watchlist_viewmodel.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/media_deatail.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailAppBar extends StatelessWidget {
  final MediaDetail detail;
  final DetailViewModel vm;

  const DetailAppBar({super.key, required this.detail, required this.vm});

  @override
  Widget build(BuildContext context) {
    final url = detail.backdropUrl ?? detail.posterUrl;

    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppTheme.background,
      leading: IconButton(
        icon: CircleAvatar(
          backgroundColor: Colors.black54,
          child: Icon(Icons.arrow_back, color: Colors.white, size: 18),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        Consumer<WatchlistViewModel>(
          builder: (_, wl, __) {
            final inList = wl.isInList(detail.id);
            return IconButton(
              icon: Icon(
                inList ? Icons.bookmark : Icons.bookmark_border,
                color: inList ? AppTheme.netflixRed : Colors.white,
              ),
              onPressed: () => wl.toggle(detail),
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: url != null
            ? CachedNetworkImage(imageUrl: url, fit: BoxFit.cover)
            : Container(color: AppTheme.cardColor),
      ),
    );
  }
}
