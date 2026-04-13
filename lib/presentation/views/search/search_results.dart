import 'package:flutter/material.dart';
import '../../widgets/media_card.dart';
import '../../../data/models/media_model.dart';

class SearchResults extends StatelessWidget {
  final List<Media> results;
  final Function(Media) onTap;

  const SearchResults({
    super.key,
    required this.results,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.6,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: results.length,
      itemBuilder: (_, i) {
        final media = results[i];
        return GestureDetector(
          onTap: () => onTap(media),
          child: MediaCard(media: media),
        );
      },
    );
  }
}