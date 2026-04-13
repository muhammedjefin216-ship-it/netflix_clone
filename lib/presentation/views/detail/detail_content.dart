import 'package:flutter/material.dart';
import '../../viewmodels/detail_viewmodel.dart';
import '../../../data/models/media_model.dart';
import 'detail_appbar.dart';
import 'detail_sections.dart';

class DetailContent extends StatelessWidget {
  final DetailViewModel vm;
  final Function(Media) onMediaTap;

  const DetailContent({super.key, required this.vm, required this.onMediaTap});

  @override
  Widget build(BuildContext context) {
    final detail = vm.detail!;

    return CustomScrollView(
      slivers: [
        DetailAppBar(detail: detail, vm: vm),

        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: DetailSections(
              detail: detail,
              vm: vm,
              onMediaTap: onMediaTap,
            ),
          ),
        ),
      ],
    );
  }
}
