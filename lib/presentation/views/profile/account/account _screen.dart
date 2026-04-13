import 'package:flutter/material.dart';
import 'package:netflix_clone/core/theme/app_theme.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title:  Text('Account'),
        backgroundColor: AppTheme.background,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
             SizedBox(height: 20),

            _buildProfileCard(),

             SizedBox(height: 24),

            _buildSection(
              title: "MEMBERSHIP",
              children:  [
                _AccountTile(
                  icon: Icons.credit_card,
                  title: "Premium Plan",
                  subtitle: "4K + HDR • ₹649/month",
                ),
                _AccountTile(
                  icon: Icons.calendar_today,
                  title: "Next Billing Date",
                  subtitle: "May 10, 2026",
                ),
              ],
            ),

             SizedBox(height: 16),

            _buildSection(
              title: "SETTINGS",
              children:  [
                _AccountTile(
                  icon: Icons.lock_outline,
                  title: "Change Password",
                ),
                _AccountTile(
                  icon: Icons.language,
                  title: "Language",
                  subtitle: "English",
                ),
                _AccountTile(
                  icon: Icons.devices,
                  title: "Manage Devices",
                ),
              ],
            ),

             SizedBox(height: 16),

            _buildSection(
              title: "SUPPORT",
              children:  [
                _AccountTile(
                  icon: Icons.help_outline,
                  title: "Help Center",
                ),
                _AccountTile(
                  icon: Icons.feedback_outlined,
                  title: "Send Feedback",
                ),
              ],
            ),

             SizedBox(height: 24),

            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize:  Size(double.infinity, 48),
                  side:  BorderSide(color: AppTheme.textMuted),
                ),
                onPressed: () {
                  _showLogoutDialog(context);
                },
                child:  Text(
                  "Sign Out",
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
              ),
            ),

             SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      margin:  EdgeInsets.symmetric(horizontal: 16),
      padding:  EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.netflixRed,
              borderRadius: BorderRadius.circular(8),
            ),
            child:  Icon(Icons.person, color: Colors.white, size: 32),
          ),
           SizedBox(width: 14),
           Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Guest User",
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "guest@netflix.com",
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:  EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: Text(
            title,
            style:  TextStyle(
              color: AppTheme.textMuted,
              fontSize: 12,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          margin:  EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title:  Text("Sign Out",
            style: TextStyle(color: AppTheme.textPrimary)),
        content:  Text(
          "Are you sure you want to sign out?",
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:  Text("Cancel",
                style: TextStyle(color: AppTheme.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:  Text("Sign Out",
                style: TextStyle(color: AppTheme.netflixRed)),
          ),
        ],
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;

  const _AccountTile({
    required this.icon,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.textSecondary),
      title: Text(
        title,
        style:  TextStyle(color: AppTheme.textPrimary),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style:  TextStyle(
                color: AppTheme.textMuted,
                fontSize: 12,
              ),
            )
          : null,
      trailing:  Icon(Icons.chevron_right,
          color: AppTheme.textMuted),
    );
  }
}