part of 'main_bloc.dart';

sealed class MainEvent extends Equatable {
  const MainEvent();

  @override
  List<Object> get props => [];
}

class MainLoadCoursesEvent extends MainEvent {}

class SearchCoursesEvent extends MainEvent {
  final String query;

  const SearchCoursesEvent(this.query);

  @override
  List<Object> get props => [query];
}
