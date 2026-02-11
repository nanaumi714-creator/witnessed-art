import 'package:equatable/equatable.dart';

abstract class GalleryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadGallery extends GalleryEvent {}
