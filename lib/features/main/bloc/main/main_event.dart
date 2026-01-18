part of 'main_bloc.dart';

sealed class MainEvent extends Equatable {
  const MainEvent();

  @override
  List<Object> get props => [];
}

class MainLoadCoursesEvent extends MainEvent {
  final String userId;

  const MainLoadCoursesEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class SearchCoursesEvent extends MainEvent {
  final String query;

  const SearchCoursesEvent(this.query);

  @override
  List<Object> get props => [query];
}
