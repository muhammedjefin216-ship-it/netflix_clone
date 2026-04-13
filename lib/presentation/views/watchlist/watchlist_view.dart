import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../viewmodels/watchlist_viewmodel.dart';
import '../../widgets/error_view.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/media_model.dart';

class WatchlistView extends StatefulWidget {
  final Function(Media) onMediaTap;

  const WatchlistView({super.key, required this.onMediaTap});

  @override
  State<WatchlistView> createState() => _WatchlistViewState();
}

class _WatchlistViewState extends State<WatchlistView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WatchlistViewModel>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Consumer<WatchlistViewModel>(
        builder: (context, vm, _) {
          if (vm.isEmpty) {
            return  EmptyView(
              icon:     Icons.bookmark_border_rounded,
              message:  'Your list is empty',
              subtitle: 'Add movies and shows\nto watch later',
            );
          }

          return _buildList(vm);
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.background,
      title:  Text(
        'My List',
        style: TextStyle(
          fontSize:   22,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Consumer<WatchlistViewModel>(
          builder: (context, vm, _) {
            if (vm.isEmpty) return  SizedBox();
            return TextButton(
              onPressed: () => _showClearDialog(context, vm),
              child:  Text(
                'Clear All',
                style: TextStyle(
                  color:    AppTheme.netflixRed,
                  fontSize: 13,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildList(WatchlistViewModel vm) {
    return Column(
      children: [
        Padding(
          padding:  EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Row(
            children: [
              Text(
                '${vm.count} ${vm.count == 1 ? 'title' : 'titles'}',
                style:  TextStyle(
                  color:    AppTheme.textMuted,
                  fontSize: 13,
                ),
              ),
               Spacer(),
               Text(
                'Swipe left to remove',
                style: TextStyle(
                  color:    AppTheme.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
         Divider(height: 1, color: AppTheme.dividerColor),

        Expanded(
          child: ListView.separated(
            padding:           EdgeInsets.symmetric(vertical: 8),
            itemCount:        vm.items.length,
            separatorBuilder: (_, __) =>  Divider(
              height:  0,
              indent:  106,
              color:   AppTheme.dividerColor,
            ),
            itemBuilder: (_, i) {
              final media = vm.items[i];
              return _WatchlistTile(
                media:    media,
                onTap:    () => widget.onMediaTap(media),
                onRemove: () => vm.remove(media.id),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showClearDialog(BuildContext context, WatchlistViewModel vm) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title:  Text(
          'Clear My List',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content:  Text(
          'Are you sure you want to remove all titles from your list?',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:  Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              vm.clearAll();
              Navigator.pop(context);
            },
            child:  Text(
              'Clear All',
              style: TextStyle(color: AppTheme.netflixRed),
            ),
          ),
        ],
      ),
    );
  }
}

class _WatchlistTile extends StatelessWidget {
  final Media        media;
  final VoidCallback onTap;
  final VoidCallback onRemove;

   _WatchlistTile({
    required this.media,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key:       Key('watchlist_${media.id}'),
      direction: DismissDirection.endToStart,

      background: Container(
        alignment: Alignment.centerRight,
        padding:    EdgeInsets.only(right: 20),
        color:     Colors.red.shade900,
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline, color: Colors.white, size: 26),
            SizedBox(height: 4),
            Text(
              'Remove',
              style: TextStyle(
                color:    Colors.white,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (_) => onRemove(),

      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding:  EdgeInsets.symmetric(
            horizontal: 16,
            vertical:    10,
          ),
          child: Row(
            children: [
              _buildPoster(),
               SizedBox(width: 14),

              Expanded(child: _buildInfo()),

              IconButton(
                icon:  Icon(
                  Icons.remove_circle_outline,
                  color: AppTheme.textMuted,
                  size:  22,
                ),
                onPressed: onRemove,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPoster() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        width:  75,
        height: 110,
        child: media.posterUrl != null
            ? CachedNetworkImage(
                imageUrl:    media.posterUrl!,
                fit:         BoxFit.cover,
                placeholder: (_, __) =>
                    Container(color: AppTheme.cardColor),
                errorWidget: (_, __, ___) =>
                    Container(color: AppTheme.cardColor),
              )
            : Container(
                color: AppTheme.cardColor,
                child:  Icon(
                  Icons.movie,
                  color: AppTheme.textMuted,
                ),
              ),
      ),
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          media.displayTitle,
          maxLines:  2,
          overflow:  TextOverflow.ellipsis,
          style:  TextStyle(
            color:      AppTheme.textPrimary,
            fontSize:   15,
            fontWeight: FontWeight.w600,
            height:     1.3,
          ),
        ),
         SizedBox(height: 8),

        Row(
          children: [
            Container(
              padding:  EdgeInsets.symmetric(
                horizontal: 7,
                vertical:    2,
              ),
              decoration: BoxDecoration(
                color: media.isMovie
                    ? AppTheme.netflixRed.withOpacity(0.2)
                    : Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(3),
                border: Border.all(
                  color: media.isMovie
                      ? AppTheme.netflixRed.withOpacity(0.5)
                      : Colors.blue.withOpacity(0.5),
                  width: 0.5,
                ),
              ),
              child: Text(
                media.isMovie ? 'MOVIE' : 'TV',
                style: TextStyle(
                  color: media.isMovie
                      ? AppTheme.netflixRed
                      : Colors.blue,
                  fontSize:      10,
                  fontWeight:    FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            if (media.year.isNotEmpty) ...[
               SizedBox(width: 8),
              Text(
                media.year,
                style:  TextStyle(
                  color:    AppTheme.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
         SizedBox(height: 8),

        Row(
          children: [
             Icon(Icons.star, color: Colors.amber, size: 13),
             SizedBox(width: 4),
            Text(
              media.ratingFormatted,
              style:  TextStyle(
                color:      AppTheme.textSecondary,
                fontSize:   12,
                fontWeight: FontWeight.w500,
              ),
            ),
             SizedBox(width: 12),

            Text(
              '(${media.voteCount} votes)',
              style:  TextStyle(
                color:    AppTheme.textMuted,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }
}