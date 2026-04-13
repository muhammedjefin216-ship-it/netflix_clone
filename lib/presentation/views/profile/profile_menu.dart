import 'package:flutter/material.dart';
import 'package:netflix_clone/presentation/views/profile/account/account%20_screen.dart';
import 'package:netflix_clone/presentation/views/profile/dwd/download_view.dart';
import 'package:netflix_clone/presentation/views/profile/help/help_screen.dart';
import 'package:netflix_clone/presentation/views/profile/privacy/privacy_view.dart';
import 'package:netflix_clone/presentation/views/watchlist/watchlist_view.dart';
import 'profile_widgets.dart';

class ProfileMenu extends StatelessWidget {
const ProfileMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MenuGroup(
          title: 'My Library',
          items: [
            MenuItem(title: 'Downloads', icon: Icons.download,
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>DownloadsView()));
            },
            ),
            MenuItem(title: 'My List', icon: Icons.bookmark,
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>WatchlistView(onMediaTap:(media){}, )
              ),
              
              );
            },
            ),
          ],
        ),
       SizedBox(height: 20),
        MenuGroup(
          title: 'Settings',
          items: [
            MenuItem(title: 'Account', icon: Icons.person,
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>AccountView()));
            },
            ),
            MenuItem(title: 'Help', icon: Icons.help,
            onTap: (){
               Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => HelpView()),
    );
            },
            ),
            MenuItem(title: 'Privacy', icon: Icons.privacy_tip,
            onTap: (){
               Navigator.push(
      context,
      MaterialPageRoute(builder: (_) =>  PrivacyView()),
    );
            },
            ),
          ],
        ),
      ],
    );
  }
}