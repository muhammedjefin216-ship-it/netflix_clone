import 'package:flutter/material.dart';
import 'package:netflix_clone/data/models/media_deatail.dart';
import 'package:netflix_clone/presentation/views/trailor_screen.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../viewmodels/detail_viewmodel.dart';
import '../../viewmodels/watchlist_viewmodel.dart';
import '../../widgets/media_card.dart';
import '../../widgets/error_view.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/media_model.dart';

class DetailView extends StatefulWidget {
  final int mediaId;
  final String mediaType;
  final Function(Media) onMediaTap;

  const DetailView({
    super.key,
    required this.mediaId,
    required this.mediaType,
    required this.onMediaTap,
  });

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DetailViewModel>().loadDetail(
        widget.mediaId,
        widget.mediaType,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Consumer<DetailViewModel>(
        builder: (context, vm, _) {
          // Loading
          if (vm.isLoading) {
            return const LoadingView(message: 'Loading details...');
          }

          // Error
          if (vm.hasError) {
            return ErrorView(
              message: vm.error,
              onRetry: () => vm.loadDetail(widget.mediaId, widget.mediaType),
            );
          }

          // No Data
          if (vm.detail == null) return const SizedBox();

          return _buildContent(vm);
        },
      ),
    );
  }

  // ── Main Content ──────────────────────────────────────
  Widget _buildContent(DetailViewModel vm) {
    final detail = vm.detail!;

    return CustomScrollView(
      slivers: [
        // Collapsible Header
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          backgroundColor: AppTheme.background,
          leading: IconButton(
            icon: const CircleAvatar(
              backgroundColor: Colors.black54,
              child: Icon(Icons.arrow_back, color: Colors.white, size: 18),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            Consumer<WatchlistViewModel>(
              builder: (_, wl, __) {
                final inList = wl.isInList(detail.id);
                return IconButton(
                  icon: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: Icon(
                      inList ? Icons.bookmark : Icons.bookmark_border,
                      color: inList ? AppTheme.netflixRed : Colors.white,
                      size: 18,
                    ),
                  ),
                  onPressed: () => wl.toggle(detail),
                );
              },
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: _buildBackdrop(detail, vm),
          ),
        ),

        // Scrollable Body
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleSection(detail),
                const SizedBox(height: 10),
                _buildMetaRow(detail),
                const SizedBox(height: 18),
                _buildActionButtons(detail),
                const SizedBox(height: 20),
                _buildOverview(detail),
                if (detail.genres.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildGenres(detail),
                ],
                if (detail.cast.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _buildCastSection(detail),
                ],
                if (detail.videos.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _buildTrailerSection(detail, vm),
                ],
                if (detail.similar.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildSimilarSection(detail),
                ],
                const SizedBox(height: 90),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Backdrop ──────────────────────────────────────────
  Widget _buildBackdrop(MediaDetail detail, DetailViewModel vm) {
    final url = detail.backdropUrl ?? detail.posterUrl;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Backdrop Image
        if (url != null)
          CachedNetworkImage(imageUrl: url, fit: BoxFit.cover)
        else
          Container(color: AppTheme.cardColor),

        // Gradient
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, AppTheme.background],
              stops: const [0.5, 1.0],
            ),
          ),
        ),

        // Play Trailer Button
        if (vm.trailer != null)
          Center(
            child: GestureDetector(
              onTap: () {
                if (vm.trailer == null) return;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TrailerScreen(videoKey: vm.trailer!.key),
                  ),
                );
              },
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.black,
                  size: 38,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ── Title Section ─────────────────────────────────────
  Widget _buildTitleSection(MediaDetail detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          detail.displayTitle,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 26,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        if (detail.tagline != null && detail.tagline!.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            '"${detail.tagline}"',
            style: const TextStyle(
              color: AppTheme.textMuted,
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  // ── Meta Info Row ─────────────────────────────────────
  Widget _buildMetaRow(MediaDetail detail) {
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: [
        // Year
        if (detail.year.isNotEmpty) _MetaChip(text: detail.year),

        // Runtime or Seasons
        if (detail.runtimeFormatted.isNotEmpty)
          _MetaChip(text: detail.runtimeFormatted),
        if (detail.numberOfSeasons != null)
          _MetaChip(
            text:
                '${detail.numberOfSeasons} '
                'Season${detail.numberOfSeasons! > 1 ? 's' : ''}',
          ),

        // Rating
        _MetaChip(
          text: '⭐  ${detail.ratingFormatted}',
          color: Colors.amber.withOpacity(0.15),
        ),

        // Status
        if (detail.status != null)
          _MetaChip(
            text: detail.status!,
            color: detail.status == 'Released' || detail.status == 'Ended'
                ? Colors.green.withOpacity(0.15)
                : AppTheme.netflixRed.withOpacity(0.15),
          ),
      ],
    );
  }

  // ── Action Buttons ────────────────────────────────────
  Widget _buildActionButtons(MediaDetail detail) {
    return Consumer<WatchlistViewModel>(
      builder: (_, wl, __) {
        final inList = wl.isInList(detail.id);

        return Column(
          children: [
            // Play Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.textPrimary,
                  foregroundColor: AppTheme.background,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                icon: const Icon(Icons.play_arrow, size: 24),
                label: const Text(
                  'Play',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                onPressed: () {},
              ),
            ),
            const SizedBox(height: 10),

            // Download Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.surfaceColor,
                  foregroundColor: AppTheme.textPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                icon: const Icon(Icons.download_outlined, size: 24),
                label: const Text(
                  'Download',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                onPressed: () {},
              ),
            ),
            const SizedBox(height: 18),

            // Icon Action Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // My List
                _IconAction(
                  icon: inList ? Icons.check : Icons.add,
                  label: inList ? 'Added' : 'My List',
                  color: inList ? AppTheme.netflixRed : null,
                  onTap: () => wl.toggle(detail),
                ),

                // Rate
                const _IconAction(icon: Icons.thumb_up_outlined, label: 'Rate'),

                // Share
                const _IconAction(icon: Icons.share_outlined, label: 'Share'),
              ],
            ),
          ],
        );
      },
    );
  }

  // ── Overview ──────────────────────────────────────────
  Widget _buildOverview(MediaDetail detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Overview',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          detail.overview ?? 'No description available.',
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 14,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  // ── Genres ────────────────────────────────────────────
  Widget _buildGenres(MediaDetail detail) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: detail.genres.map((g) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.dividerColor),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            g.name,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
        );
      }).toList(),
    );
  }

  // ── Cast Section ──────────────────────────────────────
  Widget _buildCastSection(MediaDetail detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cast',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: detail.cast.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (_, i) {
              final cast = detail.cast[i];
              return SizedBox(
                width: 72,
                child: Column(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: AppTheme.cardColor,
                      backgroundImage: cast.profileUrl != null
                          ? CachedNetworkImageProvider(cast.profileUrl!)
                          : null,
                      child: cast.profileUrl == null
                          ? const Icon(
                              Icons.person,
                              color: AppTheme.textMuted,
                              size: 28,
                            )
                          : null,
                    ),
                    const SizedBox(height: 6),

                    // Name
                    Text(
                      cast.name,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 10,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Trailer Section ───────────────────────────────────
  Widget _buildTrailerSection(MediaDetail detail, DetailViewModel vm) {
    if (vm.trailer == null) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Trailer',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            if (vm.trailer == null) return;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TrailerScreen(videoKey: vm.trailer!.key),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Thumbnail
                CachedNetworkImage(
                  imageUrl: vm.trailer!.youtubeThumbnail,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  placeholder: (_, __) =>
                      Container(height: 200, color: AppTheme.cardColor),
                  errorWidget: (_, __, ___) =>
                      Container(height: 200, color: AppTheme.cardColor),
                ),

                // Dark overlay
                Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.black.withOpacity(0.4),
                ),

                // Play Icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.black,
                    size: 34,
                  ),
                ),

                // Trailer title
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 12,
                  child: Text(
                    vm.trailer!.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      shadows: [Shadow(color: Colors.black, blurRadius: 6)],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Similar Content ───────────────────────────────────
  Widget _buildSimilarSection(MediaDetail detail) {
    return MediaRow(
      title: 'More Like This',
      items: detail.similar,
      onMediaTap: widget.onMediaTap,
      cardWidth: 120,
      cardHeight: 180,
    );
  }
}

// ── Meta Chip ─────────────────────────────────────────────
class _MetaChip extends StatelessWidget {
  final String text;
  final Color? color;

  const _MetaChip({required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color ?? AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
      ),
    );
  }
}

// ── Icon Action ───────────────────────────────────────────
class _IconAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback? onTap;

  const _IconAction({
    required this.icon,
    required this.label,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color ?? AppTheme.textPrimary, size: 26),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: color ?? AppTheme.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
