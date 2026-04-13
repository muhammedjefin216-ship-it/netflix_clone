import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/watchlist_viewmodel.dart';
import '../../widgets/error_view.dart';
import '../../../data/models/media_model.dart';

import 'watchlist_appbar.dart';
import 'watchlist_list.dart';

class WatchlistView extends StatefulWidget {
  final Function(Media) onMediaTap;

  const WatchlistView({super.key, required this.onMediaTap});

  @override
  State<WatchlistView> createState() => _WatchlistViewState();
}

class _WatchlistViewState extends State<WatchlistView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WatchlistViewModel>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  WatchlistAppBar(),
      body: Consumer<WatchlistViewModel>(
        builder: (context, vm, _) {
          if (vm.isEmpty) {
            return  EmptyView(
              icon: Icons.bookmark_border_rounded,
              message: 'Your list is empty',
              subtitle: 'Add movies and shows\nto watch later',
            );
          }

          return WatchlistList(
            vm: vm,
            onMediaTap: widget.onMediaTap,
          );
        },
      ),
    );
  }
}