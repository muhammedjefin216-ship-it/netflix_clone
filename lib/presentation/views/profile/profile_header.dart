import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppTheme.netflixRed,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.person, color: Colors.white, size: 52),
            ),
             Icon(Icons.edit, size: 16, color: Colors.white),
          ],
        ),
         SizedBox(height: 12),
         Text(
          'Guest User',
          style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
         Text(
          'guest@netflix.com',
          style: TextStyle(color: AppTheme.textMuted),
        ),
      ],
    );
  }
}