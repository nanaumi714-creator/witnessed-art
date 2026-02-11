import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:witnessed_art/theme/emerald_wash_theme.dart';
import 'package:witnessed_art/features/home/presentation/pages/home_page.dart';
import 'package:witnessed_art/features/home/bloc/home_bloc.dart';
import 'package:witnessed_art/features/home/bloc/home_event.dart';
import 'package:witnessed_art/features/home/data/repositories/home_repository.dart';
import 'package:witnessed_art/core/services/notification_service.dart';
import 'package:witnessed_art/features/settings/bloc/settings_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final notificationService = NotificationService();
  await notificationService.init();

  final repository = HomeRepository();
  runApp(WitnessedArtApp(
    repository: repository,
    notificationService: notificationService,
  ));
}

class WitnessedArtApp extends StatelessWidget {
  final HomeRepository repository;
  final NotificationService notificationService;

  const WitnessedArtApp({
    super.key,
    required this.repository,
    required this.notificationService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: repository),
        RepositoryProvider.value(value: notificationService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                SettingsBloc(notificationService: notificationService)
                  ..add(LoadSettings()),
          ),
          BlocProvider(
            create: (context) => HomeBloc(
              repository: repository,
              notificationService: notificationService,
            )..add(LoadInitialState()),
          ),
        ],
        child: MaterialApp(
          title: 'Witnessed Art',
          theme: EmeraldWashTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          home: const HomePage(),
        ),
      ),
    );
  }
}
