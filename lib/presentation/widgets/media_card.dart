import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/media_model.dart';
import '../../core/theme/app_theme.dart';

// ── Single Media Card ─────────────────────────────────────
class MediaCard extends StatelessWidget {
  final Media        media;
  final VoidCallback? onTap;
  final double       width;
  final double       height;
  final bool         showRating;

  const MediaCard({
    super.key,
    required this.media,
    this.onTap,
    this.width      = 120,
    this.height     = 180,
    this.showRating = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width:      width,
        height:     height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color:        AppTheme.cardColor,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildImage(),
            _buildGradient(),
            if (showRating) _buildRatingBadge(),
            _buildTypeTag(),
          ],
        ),
      ),
    );
  }

  // ── Poster Image ──────────────────────────────────────
  Widget _buildImage() {
    final url = media.posterUrl;
    if (url == null) return _placeholder();

    return CachedNetworkImage(
      imageUrl:     url,
      fit:          BoxFit.cover,
      placeholder:  (_, __) => _placeholder(),
      errorWidget:  (_, __, ___) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppTheme.cardColor,
      child: const Center(
        child: Icon(
          Icons.movie_outlined,
          color: AppTheme.textMuted,
          size:  32,
        ),
      ),
    );
  }

  // ── Bottom Gradient ───────────────────────────────────
  Widget _buildGradient() {
    return Positioned(
      bottom: 0,
      left:   0,
      right:  0,
      height: 60,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin:  Alignment.topCenter,
            end:    Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
      ),
    );
  }

  // ── Star Rating Badge ─────────────────────────────────
  Widget _buildRatingBadge() {
    return Positioned(
      top:   6,
      right: 6,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical:   2,
        ),
        decoration: BoxDecoration(
          color:        Colors.black.withOpacity(0.75),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 10),
            const SizedBox(width: 2),
            Text(
              media.ratingFormatted,
              style: const TextStyle(
                color:      AppTheme.textPrimary,
                fontSize:   10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Movie / TV Tag ────────────────────────────────────
  Widget _buildTypeTag() {
    return Positioned(
      top:  6,
      left: 6,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical:   2,
        ),
        decoration: BoxDecoration(
          color:        media.isMovie
              ? AppTheme.netflixRed.withOpacity(0.85)
              : Colors.blue.withOpacity(0.85),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Text(
          media.isMovie ? 'MOVIE' : 'TV',
          style: const TextStyle(
            color:      Colors.white,
            fontSize:   8,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

// ── Horizontal Media Row ──────────────────────────────────
class MediaRow extends StatelessWidget {
  final String         title;
  final List<Media>    items;
  final Function(Media) onMediaTap;
  final double         cardWidth;
  final double         cardHeight;
  final bool           showRating;

  const MediaRow({
    super.key,
    required this.title,
    required this.items,
    required this.onMediaTap,
    this.cardWidth  = 120,
    this.cardHeight = 180,
    this.showRating = false,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row Title
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
          child: Text(
            title,
            style: const TextStyle(
              color:      AppTheme.textPrimary,
              fontSize:   16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
        ),

        // Horizontal Scroll
        SizedBox(
          height: cardHeight,
          child: ListView.separated(
            scrollDirection:  Axis.horizontal,
            padding:          const EdgeInsets.symmetric(horizontal: 16),
            itemCount:        items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) => MediaCard(
              media:      items[i],
              width:      cardWidth,
              height:     cardHeight,
              showRating: showRating,
              onTap:      () => onMediaTap(items[i]),
            ),
          ),
        ),
      ],
    );
  }
}