import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/watchlist_viewmodel.dart';
import '../../../core/theme/app_theme.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        title: const Text(
          'My Netflix',
          style: TextStyle(
            fontSize:   22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildProfileHeader(context),
            const SizedBox(height: 28),
            _buildStatsRow(context),
            const SizedBox(height: 28),
            _buildMenuSection(context),
            const SizedBox(height: 20),
            _buildSettingsSection(context),
            const SizedBox(height: 30),
            _buildSignOutButton(context),
            const SizedBox(height: 16),
            _buildAppVersion(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ── Profile Header ────────────────────────────────────
  Widget _buildProfileHeader(BuildContext context) {
    return Column(
      children: [
        // Avatar
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width:  90,
              height: 90,
              decoration: BoxDecoration(
                color:        AppTheme.netflixRed,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color:      AppTheme.netflixRed.withOpacity(0.4),
                    blurRadius: 16,
                    offset:     const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size:  52,
              ),
            ),

            // Edit badge
            Container(
              width:  26,
              height: 26,
              decoration: BoxDecoration(
                color:  AppTheme.surfaceColor,
                shape:  BoxShape.circle,
                border: Border.all(
                  color: AppTheme.background,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.edit,
                color: AppTheme.textSecondary,
                size:  13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Name
        const Text(
          'Guest User',
          style: TextStyle(
            color:      AppTheme.textPrimary,
            fontSize:   22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),

        // Email
        const Text(
          'guest@netflix.com',
          style: TextStyle(
            color:    AppTheme.textMuted,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 12),

        // Manage Profiles Button
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side:    const BorderSide(color: AppTheme.textMuted, width: 0.8),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical:    6,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          onPressed: () {},
          child: const Text(
            'Manage Profiles',
            style: TextStyle(
              color:    AppTheme.textSecondary,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  // ── Stats Row ─────────────────────────────────────────
  Widget _buildStatsRow(BuildContext context) {
    return Consumer<WatchlistViewModel>(
      builder: (_, vm, __) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(
            vertical:   16,
            horizontal:  8,
          ),
          decoration: BoxDecoration(
            color:        AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatItem(
                value: '${vm.count}',
                label: 'My List',
                icon:  Icons.bookmark,
              ),
              _VerticalDivider(),
              const _StatItem(
                value: '0',
                label: 'Downloads',
                icon:  Icons.download_done,
              ),
              _VerticalDivider(),
              const _StatItem(
                value: '0',
                label: 'Watched',
                icon:  Icons.check_circle_outline,
              ),
            ],
          ),
        );
      },
    );
  }

  // ── My Stuff Menu ─────────────────────────────────────
  Widget _buildMenuSection(BuildContext context) {
    return _MenuGroup(
      title: 'MY STUFF',
      items: [
        _MenuItem(
          icon:     Icons.notifications_outlined,
          title:    'Notifications',
          subtitle: 'Manage your alerts',
          onTap:    () {},
        ),
        _MenuItem(
          icon:     Icons.download_outlined,
          title:    'Downloads',
          subtitle: 'Smart Downloads is on',
          onTap:    () {},
        ),
        _MenuItem(
          icon:     Icons.bookmark_outline,
          title:    'My List',
          subtitle: 'Movies and shows you saved',
          onTap:    () {},
        ),
        _MenuItem(
          icon:     Icons.history,
          title:    'Continue Watching',
          subtitle: 'Pick up where you left off',
          onTap:    () {},
        ),
      ],
    );
  }

  // ── Settings Menu ─────────────────────────────────────
  Widget _buildSettingsSection(BuildContext context) {
    return _MenuGroup(
      title: 'SETTINGS',
      items: [
        _MenuItem(
          icon:     Icons.account_circle_outlined,
          title:    'Account',
          subtitle: 'Membership & billing',
          onTap:    () {},
        ),
        _MenuItem(
          icon:     Icons.help_outline,
          title:    'Help',
          subtitle: 'Help Center & contact us',
          onTap:    () {},
        ),
        _MenuItem(
          icon:     Icons.privacy_tip_outlined,
          title:    'Privacy',
          subtitle: 'Privacy settings & policy',
          onTap:    () {},
        ),
        _MenuItem(
          icon:     Icons.settings_outlined,
          title:    'App Settings',
          subtitle: 'Playback, data usage & more',
          onTap:    () {},
        ),
      ],
    );
  }

  // ── Sign Out Button ───────────────────────────────────
  Widget _buildSignOutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: AppTheme.textMuted,
            width: 0.8,
          ),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        onPressed: () => _showSignOutDialog(context),
        child: const Text(
          'Sign Out',
          style: TextStyle(
            color:    AppTheme.textSecondary,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  // ── App Version ───────────────────────────────────────
  Widget _buildAppVersion() {
    return const Text(
      'Netflix Clone v1.0.0',
      style: TextStyle(
        color:    AppTheme.textMuted,
        fontSize: 11,
      ),
    );
  }

  // ── Sign Out Dialog ───────────────────────────────────
  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text(
          'Sign Out',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: const Text(
          'Are you sure you want to sign out?',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Sign Out',
              style: TextStyle(color: AppTheme.netflixRed),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stat Item ─────────────────────────────────────────────
class _StatItem extends StatelessWidget {
  final String  value;
  final String  label;
  final IconData icon;

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.netflixRed, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color:      AppTheme.textPrimary,
            fontSize:   20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color:    AppTheme.textMuted,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

// ── Vertical Divider ──────────────────────────────────────
class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width:  0.5,
      height: 50,
      color:  AppTheme.dividerColor,
    );
  }
}

// ── Menu Group ────────────────────────────────────────────
class _MenuGroup extends StatelessWidget {
  final String       title;
  final List<_MenuItem> items;

  const _MenuGroup({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Group Title
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Text(
            title,
            style: const TextStyle(
              color:         AppTheme.textMuted,
              fontSize:      11,
              fontWeight:    FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
        ),

        // Items
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color:        AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final isLast = entry.key == items.length - 1;
              return Column(
                children: [
                  entry.value,
                  if (!isLast)
                    const Divider(
                      height:  0,
                      indent:  54,
                      color:   AppTheme.dividerColor,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// ── Menu Item ─────────────────────────────────────────────
class _MenuItem extends StatelessWidget {
  final IconData     icon;
  final String       title;
  final String?      subtitle;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap:           onTap,
      contentPadding:  const EdgeInsets.symmetric(
        horizontal: 16,
        vertical:    4,
      ),
      leading: Container(
        width:  36,
        height: 36,
        decoration: BoxDecoration(
          color:        AppTheme.cardColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppTheme.textSecondary, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color:      AppTheme.textPrimary,
          fontSize:   14,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: const TextStyle(
                color:    AppTheme.textMuted,
                fontSize: 11,
              ),
            )
          : null,
      trailing: const Icon(
        Icons.chevron_right,
        color: AppTheme.textMuted,
        size:  20,
      ),
      dense: true,
    );
  }
}