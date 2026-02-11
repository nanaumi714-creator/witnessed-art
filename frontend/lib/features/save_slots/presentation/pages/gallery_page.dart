import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:witnessed_art/theme/emerald_wash_theme.dart';
import 'package:witnessed_art/features/home/presentation/widgets/watercolor_background.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:witnessed_art/features/save_slots/bloc/gallery_bloc.dart';
import 'package:witnessed_art/features/save_slots/bloc/gallery_event.dart';
import 'package:witnessed_art/features/save_slots/bloc/gallery_state.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const WatercolorBackground(),
          BlocBuilder<GalleryBloc, GalleryState>(
            builder: (context, state) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    expandedHeight: 120,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        'Sacred Gallery',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24),
                      ),
                      centerTitle: false,
                      titlePadding: const EdgeInsets.only(left: 32, bottom: 16),
                    ),
                  ),
                  if (state is GalleryLoading)
                    const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: EmeraldWashTheme.emeraldCore)),
                    )
                  else if (state is GalleryError)
                    SliverFillRemaining(
                      child: Center(child: Text(state.message, style: const TextStyle(color: EmeraldWashTheme.mutedCoral))),
                    )
                  else if (state is GalleryLoaded)
                    SliverPadding(
                      padding: const EdgeInsets.all(24),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          childAspectRatio: 0.8,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final item = state.images[index];
                            return _buildGalleryItem(context, item);
                          },
                          childCount: state.images.length,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryItem(BuildContext context, dynamic item) {
    final DateTime savedAt = DateTime.parse(item['saved_at']);
    final String dateStr = DateFormat('MMM d, yyyy').format(savedAt);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.4)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: CachedNetworkImage(
              imageUrl: item['url'],
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: EmeraldWashTheme.surface),
              errorWidget: (context, url, error) => const Icon(Icons.error_outline),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Witnessed #${item['step']}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  dateStr,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

