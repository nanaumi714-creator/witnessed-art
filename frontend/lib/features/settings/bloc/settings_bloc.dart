import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:witnessed_art/core/services/notification_service.dart';

// Events
abstract class SettingsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSettings extends SettingsEvent {}

class ToggleNotifications extends SettingsEvent {
  final bool enabled;
  ToggleNotifications(this.enabled);
  @override
  List<Object?> get props => [enabled];
}

// State
class SettingsState extends Equatable {
  final bool notificationsEnabled;
  final bool isLoading;

  const SettingsState({
    this.notificationsEnabled = true,
    this.isLoading = false,
  });

  SettingsState copyWith({
    bool? notificationsEnabled,
    bool? isLoading,
  }) {
    return SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [notificationsEnabled, isLoading];
}

// Bloc
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final NotificationService notificationService;

  SettingsBloc({required this.notificationService}) : super(const SettingsState()) {
    on<LoadSettings>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final prefs = await SharedPreferences.getInstance();
      final enabled = prefs.getBool('notifications_enabled') ?? true;
      emit(state.copyWith(notificationsEnabled: enabled, isLoading: false));
    });

    on<ToggleNotifications>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notifications_enabled', event.enabled);
      
      if (!event.enabled) {
        await notificationService.cancelAll();
      }
      
      emit(state.copyWith(notificationsEnabled: event.enabled));
    });
  }
}
