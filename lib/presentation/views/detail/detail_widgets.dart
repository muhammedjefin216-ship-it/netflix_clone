import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class MetaChip extends StatelessWidget {
  final String text;

  const MetaChip({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
      ),
    );
  }
}
