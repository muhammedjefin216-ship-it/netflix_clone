import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ErrorView extends StatelessWidget {
  final String      message;
  final VoidCallback? onRetry;
  final IconData    icon;

  const ErrorView({
    super.key,
    required this.message,
    this.onRetry,
    this.icon = Icons.wifi_off_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:  EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppTheme.textMuted, size: 72),
             SizedBox(height: 20),

             Text(
              'Oops!',
              style: TextStyle(
                color:      AppTheme.textPrimary,
                fontSize:   22,
                fontWeight: FontWeight.bold,
              ),
            ),
             SizedBox(height: 8),

            Text(
              message,
              textAlign: TextAlign.center,
              style:  TextStyle(
                color:    AppTheme.textSecondary,
                fontSize: 14,
                height:   1.5,
              ),
            ),

            if (onRetry != null) ...[
               SizedBox(height: 28),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.netflixRed,
                  foregroundColor: Colors.white,
                  padding:  EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical:   12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                icon:      Icon(Icons.refresh, size: 18),
                label:     Text(
                  'Try Again',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize:   15,
                  ),
                ),
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class LoadingView extends StatelessWidget {
  final String? message;

  const LoadingView({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           CircularProgressIndicator(
            color:       AppTheme.netflixRed,
            strokeWidth: 2.5,
          ),
          if (message != null) ...[
             SizedBox(height: 16),
            Text(
              message!,
              style:  TextStyle(
                color:    AppTheme.textMuted,
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class EmptyView extends StatelessWidget {
  final String   message;
  final String?  subtitle;
  final IconData icon;

   EmptyView({
    super.key,
    required this.message,
    this.subtitle,
    this.icon = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:  EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppTheme.textMuted, size: 72),
             SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style:  TextStyle(
                color:      AppTheme.textPrimary,
                fontSize:   18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (subtitle != null) ...[
               SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style:  TextStyle(
                  color:    AppTheme.textMuted,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}