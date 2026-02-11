import 'package:equatable/equatable.dart';

abstract class GalleryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GalleryInitial extends GalleryState {}

class GalleryLoading extends GalleryState {}

class GalleryLoaded extends GalleryState {
  final List<dynamic> images;

  GalleryLoaded(this.images);

  @override
  List<Object?> get props => [images];
}

class GalleryError extends GalleryState {
  final String message;

  GalleryError(this.message);

  @override
  List<Object?> get props => [message];
}
