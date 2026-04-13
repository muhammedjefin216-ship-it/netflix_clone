import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/models/media_model.dart';

class WatchlistTile extends StatelessWidget {
  final Media media;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const WatchlistTile({
    super.key,
    required this.media,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('watchlist_${media.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding:  EdgeInsets.only(right: 20),
        color: Colors.red.shade900,
        child:  Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onRemove(),
      child: ListTile(
        onTap: onTap,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: media.posterUrl != null
              ? CachedNetworkImage(
                  imageUrl: media.posterUrl!,
                  width: 50,
                  fit: BoxFit.cover,
                )
              :  Icon(Icons.movie),
        ),
        title: Text(
          media.displayTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(media.year),
        trailing: IconButton(
          icon:  Icon(Icons.close),
          onPressed: onRemove,
        ),
      ),
    );
  }
}