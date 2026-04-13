import 'package:flutter/material.dart';
import 'package:netflix_clone/core/theme/app_theme.dart';

class HelpView extends StatelessWidget {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text('Help'), backgroundColor: AppTheme.background),
      body: ListView(
        children: [
          _HelpItem(
            icon: Icons.help_outline,
            title: "Help Center",
            subtitle: "Find answers to common questions",
          ),
          _HelpItem(
            icon: Icons.chat_bubble_outline,
            title: "Contact Support",
            subtitle: "Chat with our support team",
          ),
          _HelpItem(
            icon: Icons.bug_report_outlined,
            title: "Report a Problem",
            subtitle: "Tell us what's not working",
          ),
          _HelpItem(
            icon: Icons.info_outline,
            title: "About App",
            subtitle: "Version, developers, info",
          ),
        ],
      ),
    );
  }
}

class _HelpItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _HelpItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.textSecondary),
      title: Text(title, style: TextStyle(color: AppTheme.textPrimary)),
      subtitle: Text(subtitle, style: TextStyle(color: AppTheme.textMuted)),
      trailing: Icon(Icons.chevron_right, color: AppTheme.textMuted),
      onTap: () {},
    );
  }
}
