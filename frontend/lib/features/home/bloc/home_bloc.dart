import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:witnessed_art/features/home/data/repositories/home_repository.dart';
import 'package:witnessed_art/core/services/notification_service.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;
  final NotificationService notificationService;

  HomeBloc({
    required this.repository,
    required this.notificationService,
  }) : super(HomeInitial()) {
    on<LoadInitialState>((event, emit) async {
      emit(HomeLoading());
      try {
        final userState = await repository.initUser("Asia/Tokyo");
        emit(HomeSuccess(
          imageUrl: userState.currentImageUrl ?? '',
          step: userState.step,
        ));
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    });

    on<TriggerProgress>((event, emit) async {
      try {
        final currentState = state as HomeSuccess;
        emit(HomeLoading());
        final response = await repository.triggerProgress();
        
        // Schedule notification for 24h later
        final nextAvailable = DateTime.now().add(const Duration(hours: 24));
        await notificationService.scheduleDailyReminder(scheduledTime: nextAvailable);

        emit(HomeSuccess(
          imageUrl: response.afterUrl,
          beforeImageUrl: response.beforeUrl,
          step: response.newStep,
          nextAvailableAt: nextAvailable,
        ));
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    });

    on<ResetRun>((event, emit) async {
      try {
        emit(HomeLoading());
        await repository.resetUser();
        add(LoadInitialState()); // Refresh
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    });

    on<SaveToGallery>((event, emit) async {
      try {
        await repository.saveImage();
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    });
  }
}
