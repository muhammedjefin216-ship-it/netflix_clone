import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class CategoryTabs extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

   CategoryTabs({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  final List<String> tabs =  [
    'All',
    'Movies',
    'TV Shows',
    'My List',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding:  EdgeInsets.symmetric(horizontal: 16),
        itemCount: tabs.length,
        separatorBuilder: (_, __) =>  SizedBox(width: 8),
        itemBuilder: (_, i) {
          final isSelected = i == selectedIndex;
          return GestureDetector(
            onTap: () => onTap(i),
            child: AnimatedContainer(
              duration:  Duration(milliseconds: 200),
              padding:  EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.textPrimary
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppTheme.textPrimary
                      : AppTheme.textMuted,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                tabs[i],
                style: TextStyle(
                  color: isSelected
                      ? AppTheme.background
                      : AppTheme.textPrimary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}