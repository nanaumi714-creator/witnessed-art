import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final String imageUrl;
  final String? beforeImageUrl;
  final int step;
  final DateTime? nextAvailableAt;

  HomeSuccess({
    required this.imageUrl,
    this.beforeImageUrl,
    required this.step,
    this.nextAvailableAt,
  });

  @override
  List<Object?> get props => [imageUrl, beforeImageUrl, step, nextAvailableAt];
}


class HomeError extends HomeState {
  final String message;

  HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
