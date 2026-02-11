import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:witnessed_art/theme/emerald_wash_theme.dart';
import 'package:witnessed_art/features/home/presentation/widgets/watercolor_background.dart';
import 'package:witnessed_art/features/settings/bloc/settings_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const WatercolorBackground(),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: EmeraldWashTheme.primaryText),
                  onPressed: () => Navigator.pop(context),
                ),
                expandedHeight: 120,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Inner Silence',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24),
                  ),
                  centerTitle: false,
                  titlePadding: const EdgeInsets.only(left: 64, bottom: 16),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Column(
                    children: [
                      _buildSection(
                        context,
                        title: 'Sanctuary',
                        children: [
                          BlocBuilder<SettingsBloc, SettingsState>(
                            builder: (context, state) {
                              return _buildSwitchTile(
                                context,
                                title: 'Daily Reminders',
                                subtitle: 'A gentle call when the spirit is ready',
                                value: state.notificationsEnabled,
                                onChanged: (value) {
                                  context.read<SettingsBloc>().add(ToggleNotifications(value));
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSection(
                        context,
                        title: 'About',
                        children: [
                          _buildSimpleTile(
                            context,
                            title: 'The Witness Protocol',
                            subtitle: 'Learn about the slow art movement',
                            onTap: () {},
                          ),
                          _buildSimpleTile(
                            context,
                            title: 'Support',
                            subtitle: 'Reach out to the creators',
                            onTap: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 48),
                      Text(
                        'Version 1.0.0',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: EmeraldWashTheme.captionText),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                  color: EmeraldWashTheme.emeraldCore.withOpacity(0.6),
                ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(BuildContext context,
      {required String title, required String subtitle, required bool value, required ValueChanged<bool> onChanged}) {
    return ListTile(
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.labelSmall),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: EmeraldWashTheme.emeraldCore,
      ),
    );
  }

  Widget _buildSimpleTile(BuildContext context, {required String title, required String subtitle, required VoidCallback onTap}) {
    return ListTile(
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.labelSmall),
      onTap: onTap,
      trailing: const Icon(Icons.chevron_right, size: 20, color: EmeraldWashTheme.captionText),
    );
  }
}
