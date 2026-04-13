import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'profile_header.dart';
import 'profile_stats.dart';
import 'profile_menu.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        title: Text(
          'My Netflix',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            ProfileHeader(),
            SizedBox(height: 28),
            ProfileStats(),
            SizedBox(height: 28),
            ProfileMenu(),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
