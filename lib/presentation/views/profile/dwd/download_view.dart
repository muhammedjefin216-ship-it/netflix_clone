import 'package:flutter/material.dart';
import 'package:netflix_clone/core/theme/app_theme.dart';
import 'package:netflix_clone/presentation/views/search/search_view.dart';

class DownloadsView extends StatelessWidget {
const DownloadsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text('Downloads'),
        backgroundColor: AppTheme.background,
      ),
      body: Column(
        children: [
         SizedBox(height: 20),

        

         SizedBox(height: 30),

          Expanded(child: _buildEmptyState()),

         SizedBox(height: 20),

          _buildFindButton(context),

         SizedBox(height: 30),
        ],
      ),
    );
  }



  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.download_for_offline_outlined,
            size: 80,
            color: AppTheme.textMuted,
          ),
        ),

       SizedBox(height: 20),

       Text(
          "No Downloads Yet",
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

       SizedBox(height: 10),

       Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            "Movies and TV shows that you download will appear here.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textMuted,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFindButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.textPrimary,
          foregroundColor: AppTheme.background,
          minimumSize: Size(double.infinity, 48),
        ),
        onPressed: () {
           Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchView(
          onMediaTap: (media) {
          },
        ),
      ),
    );
        },
        child: Text(
          "Find Something to Download",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}