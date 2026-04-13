import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/detail_viewmodel.dart';
import '../../widgets/error_view.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/media_model.dart';
import 'detail_content.dart';

class DetailView extends StatefulWidget {
  final int mediaId;
  final String mediaType;
  final Function(Media) onMediaTap;

  const DetailView({
    super.key,
    required this.mediaId,
    required this.mediaType,
    required this.onMediaTap,
  });

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DetailViewModel>().loadDetail(
        widget.mediaId,
        widget.mediaType,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Consumer<DetailViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (vm.hasError) {
            return ErrorView(
              message: vm.error,
              onRetry: () => vm.loadDetail(widget.mediaId, widget.mediaType),
            );
          }

          if (vm.detail == null) return SizedBox();

          return DetailContent(vm: vm, onMediaTap: widget.onMediaTap);
        },
      ),
    );
  }
}
