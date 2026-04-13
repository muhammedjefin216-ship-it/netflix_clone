import 'package:flutter/material.dart';
import '../../widgets/media_card.dart';
import '../../../data/models/media_model.dart';

class SearchTrending extends StatelessWidget {
  final List<Media> trending;
  final Function(Media) onTap;

  const SearchTrending({
    super.key,
    required this.trending,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (trending.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.6,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: trending.length,
      itemBuilder: (_, i) {
        final media = trending[i];
        return GestureDetector(
          onTap: () => onTap(media),
          child: MediaCard(media: media),
        );
      },
    );
  }
}
