import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:witnessed_art/theme/emerald_wash_theme.dart';
import 'package:witnessed_art/features/home/bloc/home_bloc.dart';
import 'package:witnessed_art/features/home/bloc/home_event.dart';
import 'package:witnessed_art/features/home/bloc/home_state.dart';
import 'package:witnessed_art/features/home/data/repositories/home_repository.dart';
import 'package:witnessed_art/features/home/presentation/widgets/development_canvas.dart';
import 'package:witnessed_art/features/home/presentation/widgets/watercolor_background.dart';
import 'package:witnessed_art/features/save_slots/presentation/pages/gallery_page.dart';
import 'package:witnessed_art/features/save_slots/bloc/gallery_bloc.dart';
import 'package:witnessed_art/features/save_slots/bloc/gallery_event.dart';
import 'package:witnessed_art/features/settings/presentation/pages/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final repository = context.read<HomeRepository>();
    
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GalleryBloc(repository: repository),
        ),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: IndexedStack(
              index: _currentIndex,
              children: [
                _buildSpiritTab(),
                const GalleryPage(),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() => _currentIndex = index);
                if (index == 1) {
                  context.read<GalleryBloc>().add(LoadGallery());
                }
              },
              selectedItemColor: EmeraldWashTheme.emeraldCore,
              unselectedItemColor: EmeraldWashTheme.captionText,
              backgroundColor: Colors.white,
              elevation: 8,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Spirit'),
                BottomNavigationBarItem(icon: Icon(Icons.auto_awesome_mosaic_outlined), label: 'Gallery'),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSpiritTab() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Stack(
          children: [
            const WatercolorBackground(),
            SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      const Spacer(),
                      // Art Canvas
                      Center(
                        child: GestureDetector(
                          onLongPress: () {
                            _showResetConfirmation(context);
                          },
                          child: Container(
                            width: 320,
                            height: 320,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: EmeraldWashTheme.primaryText.withOpacity(0.06),
                                  blurRadius: 28,
                                ),
                              ],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: _buildGalleryContent(state),
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Interaction Area
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            if (state is HomeLoading)
                              const CircularProgressIndicator(
                                color: EmeraldWashTheme.emeraldCore,
                                strokeWidth: 2,
                              )
                            else ...[
                              ElevatedButton(
                                onPressed: state is HomeSuccess 
                                  ? () => context.read<HomeBloc>().add(TriggerProgress()) 
                                  : null,
                                child: const Text('Witness Development'),
                              ),
                              if (state is HomeSuccess && state.imageUrl.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                TextButton.icon(
                                  onPressed: () {
                                    context.read<HomeBloc>().add(SaveToGallery());
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Saved to Gallery')),
                                    );
                                  },
                                  icon: const Icon(Icons.bookmark_border, size: 20),
                                  label: const Text('Save to Gallery'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: EmeraldWashTheme.secondaryText,
                                  ),
                                ),
                              ],
                            ],
                            const SizedBox(height: 16),
                            _buildStatusText(context, state),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: IconButton(
                      icon: const Icon(Icons.settings_outlined, color: EmeraldWashTheme.primaryText),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsPage()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (confirmContext) => AlertDialog(
        backgroundColor: EmeraldWashTheme.aquaMist,
        title: const Text('Reset Run?'),
        content: const Text('This will wipe your current progress and start over with a new seed. This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(confirmContext),
            child: const Text('Cancel', style: TextStyle(color: EmeraldWashTheme.secondaryText)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(confirmContext);
              context.read<HomeBloc>().add(ResetRun());
            },
            child: const Text('Reset', style: TextStyle(color: EmeraldWashTheme.mutedCoral)),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryContent(HomeState state) {
    if (state is HomeSuccess) {
      return DevelopmentCanvas(
        imageUrl: state.imageUrl,
        beforeImageUrl: state.beforeImageUrl,
      );
    }
    return const Center(
      child: Text(
        'Art will appear here',
        style: TextStyle(color: EmeraldWashTheme.secondaryText),
      ),
    );
  }

  Widget _buildStatusText(BuildContext context, HomeState state) {
    if (state is HomeSuccess && state.nextAvailableAt != null) {
      return Text(
        'Next step available in 24h',
        style: Theme.of(context).textTheme.labelSmall,
      );
    }
    if (state is HomeError) {
      return Text(
        state.message,
        maxLines: 2,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: EmeraldWashTheme.mutedCoral),
      );
    }
    return Text(
      'Ready to begin',
      style: Theme.of(context).textTheme.labelSmall,
    );
  }
}
