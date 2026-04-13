import 'package:flutter/material.dart';
import 'package:netflix_clone/core/theme/app_theme.dart';

class PrivacyView extends StatelessWidget {
  const PrivacyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text('Privacy'),
        backgroundColor: AppTheme.background,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _PrivacySection(
            title: "Privacy Policy",
            content:
                "We respect your privacy. Your data is securely stored and never shared without your permission.",
          ),
          SizedBox(height: 20),
          _PrivacySection(
            title: "Data Collection",
            content:
                "We collect minimal data to improve your experience, such as watch history and preferences.",
          ),
          SizedBox(height: 20),
          _PrivacySection(
            title: "Security",
            content:
                "Your data is protected using industry-standard security practices.",
          ),
          SizedBox(height: 20),
          _PrivacySection(
            title: "User Control",
            content:
                "You can manage or delete your data anytime from your account settings.",
          ),
        ],
      ),
    );
  }
}

class _PrivacySection extends StatelessWidget {
  final String title;
  final String content;

  const _PrivacySection({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 13,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
