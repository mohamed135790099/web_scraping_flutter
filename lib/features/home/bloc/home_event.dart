part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadUsers extends HomeEvent {
  final String currentUserId;
  final String searchQuery;

  const LoadUsers({
    required this.currentUserId,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [currentUserId, searchQuery];
}

class SearchUsers extends HomeEvent {
  final String query;

  const SearchUsers({required this.query});

  @override
  List<Object?> get props => [query];
}

class ClearSearch extends HomeEvent {}
