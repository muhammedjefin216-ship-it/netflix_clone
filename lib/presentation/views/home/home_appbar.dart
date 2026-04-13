import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isScrolled;

  const HomeAppBar({super.key, required this.isScrolled});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: isScrolled
          ? AppTheme.background.withOpacity(0.97)
          : Colors.transparent,
      elevation: isScrolled ? 4 : 0,
      title: Text(
        'NETFLIX',
        style: TextStyle(
          color: AppTheme.netflixRed,
          fontSize: 22,
          fontWeight: FontWeight.w900,
          letterSpacing: 3,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.cast, color: AppTheme.textPrimary),
          onPressed: () {},
        ),
        Padding(
          padding: EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () {},
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.netflixRed,
              child: Icon(Icons.person, color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
