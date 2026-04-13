import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/media_model.dart';
import '../../core/theme/app_theme.dart';

class HeroBanner extends StatelessWidget {
  final Media        media;
  final VoidCallback? onPlayTap;
  final VoidCallback? onInfoTap;

  const HeroBanner({
    super.key,
    required this.media,
    this.onPlayTap,
    this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.55,
      width:  double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackdrop(),
          _buildGradient(),
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildBackdrop() {
    final url = media.backdropUrl ?? media.posterUrl;
    if (url == null) {
      return Container(color: AppTheme.cardColor);
    }

    return CachedNetworkImage(
      imageUrl:    url,
      fit:         BoxFit.cover,
      placeholder: (_, __) => Container(color: AppTheme.cardColor),
      errorWidget: (_, __, ___) => Container(color: AppTheme.cardColor),
    );
  }

  Widget _buildGradient() {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin:  Alignment.topCenter,
          end:    Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.2),
            Colors.black.withOpacity(0.7),
            AppTheme.background,
          ],
          stops:  [0.0, 0.4, 0.75, 1.0],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Positioned(
      bottom: 16,
      left:   0,
      right:  0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding:  EdgeInsets.symmetric(
              horizontal: 12,
              vertical:    4,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.textSecondary,
                width: 0.8,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              media.isMovie ? '🎬  MOVIE' : '📺  SERIES',
              style:  TextStyle(
                color:         AppTheme.textSecondary,
                fontSize:      11,
                fontWeight:    FontWeight.w600,
                letterSpacing: 2,
              ),
            ),
          ),
           SizedBox(height: 12),

          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              media.displayTitle,
              textAlign:  TextAlign.center,
              maxLines:   2,
              overflow:   TextOverflow.ellipsis,
              style:  TextStyle(
                color:      AppTheme.textPrimary,
                fontSize:   28,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
                shadows: [
                  Shadow(
                    color:      Colors.black54,
                    blurRadius: 8,
                    offset:     Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
           SizedBox(height: 6),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Icon(Icons.star, color: Colors.amber, size: 14),
               SizedBox(width: 4),
              Text(
                media.ratingFormatted,
                style:  TextStyle(
                  color:      Colors.amber,
                  fontSize:   13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (media.year.isNotEmpty) ...[
                 SizedBox(width: 12),
                 Text(
                  '•',
                  style: TextStyle(color: AppTheme.textMuted),
                ),
                 SizedBox(width: 12),
                Text(
                  media.year,
                  style:  TextStyle(
                    color:    AppTheme.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ],
          ),
           SizedBox(height: 18),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _HeroButton(
                icon:    Icons.play_arrow,
                label:   'Play',
                primary: true,
                onTap:   onPlayTap,
              ),
               SizedBox(width: 12),

              _HeroButton(
                icon:    Icons.info_outline,
                label:   'More Info',
                primary: false,
                onTap:   onInfoTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroButton extends StatelessWidget {
  final IconData     icon;
  final String       label;
  final bool         primary;
  final VoidCallback? onTap;

  const _HeroButton({
    required this.icon,
    required this.label,
    required this.primary,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:  EdgeInsets.symmetric(
          horizontal: 22,
          vertical:   10,
        ),
        decoration: BoxDecoration(
          color: primary
              ? AppTheme.textPrimary
              : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: primary
                  ? AppTheme.background
                  : AppTheme.textPrimary,
              size: 20,
            ),
             SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: primary
                    ? AppTheme.background
                    : AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize:   15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}