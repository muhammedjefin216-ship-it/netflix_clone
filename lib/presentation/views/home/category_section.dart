import 'package:flutter/material.dart';
import '../../widgets/media_card.dart';
import '../../../data/models/media_model.dart';
import '../../../core/theme/app_theme.dart';

class CategorySection extends StatelessWidget {
  final String title;
  final List<Media> items;
  final Function(Media) onMediaTap;

  const CategorySection({
    super.key,
    required this.title,
    required this.items,
    required this.onMediaTap,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          'No items in $title',
          style: TextStyle(color: AppTheme.textMuted),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16, bottom: 12),
          child: Text(
            title,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            separatorBuilder: (_, __) => SizedBox(width: 12),
            itemBuilder: (_, index) {
              return GestureDetector(
                onTap: () => onMediaTap(items[index]),
                child: MediaCard(media: items[index], width: 140, height: 210),
              );
            },
          ),
        ),
      ],
    );
  }
}
