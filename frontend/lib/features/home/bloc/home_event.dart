import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadInitialState extends HomeEvent {}

class TriggerProgress extends HomeEvent {}

class ResetRun extends HomeEvent {}

class SaveToGallery extends HomeEvent {}

