import 'package:flutter/material.dart';
import '../../viewmodels/detail_viewmodel.dart';
import '../../../data/models/media_deatail.dart';
import '../../../data/models/media_model.dart';
import '../../widgets/media_card.dart';
import '../../../core/theme/app_theme.dart';
import 'detail_widgets.dart';

class DetailSections extends StatelessWidget {
  final MediaDetail detail;
  final DetailViewModel vm;
  final Function(Media) onMediaTap;

  const DetailSections({
    super.key,
    required this.detail,
    required this.vm,
    required this.onMediaTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          detail.displayTitle,
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 10),

        Wrap(
          spacing: 8,
          children: [
            MetaChip(text: detail.year),
            MetaChip(text: detail.ratingFormatted),
          ],
        ),

        SizedBox(height: 16),

        Text(
          detail.overview ?? '',
          style: TextStyle(color: AppTheme.textSecondary),
        ),

        SizedBox(height: 20),

        if (detail.similar.isNotEmpty)
          MediaRow(
            title: "More Like This",
            items: detail.similar,
            onMediaTap: onMediaTap,
          ),
      ],
    );
  }
}
