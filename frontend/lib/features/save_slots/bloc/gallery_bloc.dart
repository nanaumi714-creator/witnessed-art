import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:witnessed_art/features/home/data/repositories/home_repository.dart';
import 'gallery_event.dart';
import 'gallery_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final HomeRepository repository;

  GalleryBloc({required this.repository}) : super(GalleryInitial()) {
    on<LoadGallery>((event, emit) async {
      emit(GalleryLoading());
      try {
        final images = await repository.listSavedImages();
        emit(GalleryLoaded(images));
      } catch (e) {
        emit(GalleryError(e.toString()));
      }
    });
  }
}
