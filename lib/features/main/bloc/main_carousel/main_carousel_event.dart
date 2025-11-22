part of 'main_carousel_bloc.dart';

sealed class MainCarouselEvent extends Equatable {
  const MainCarouselEvent();

  @override
  List<Object> get props => [];
}

final class MainCarouselLoadEvent extends MainCarouselEvent {}
