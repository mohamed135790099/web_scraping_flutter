import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/firebase_service.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FirebaseService _firebaseService;
  StreamSubscription<List<UserModel>>? _usersSubscription;

  HomeBloc(this._firebaseService) : super(HomeInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<SearchUsers>(_onSearchUsers);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onLoadUsers(
    LoadUsers event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    await _usersSubscription?.cancel();

    _usersSubscription = _firebaseService.getUsers(event.currentUserId).listen(
      (users) {
        add(SearchUsers(query: event.searchQuery));
      },
      onError: (error) {
        emit(HomeFailure('Failed to load users: $error'));
      },
    );
  }

  Future<void> _onSearchUsers(
    SearchUsers event,
    Emitter<HomeState> emit,
  ) async {
    if (state is HomeLoading) return;

    final currentState = state;
    List<UserModel> users = [];

    if (currentState is HomeSuccess) {
      users = currentState.users;
    }

    if (event.query.isEmpty) {
      emit(HomeSuccess(users: users, searchQuery: ''));
    } else {
      final filteredUsers = users.where((user) {
        final query = event.query.toLowerCase();
        return user.displayName.toLowerCase().contains(query) ||
            user.email.toLowerCase().contains(query);
      }).toList();

      emit(HomeSuccess(users: filteredUsers, searchQuery: event.query));
    }
  }

  Future<void> _onClearSearch(
    ClearSearch event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is HomeSuccess) {
      emit(HomeSuccess(users: currentState.users, searchQuery: ''));
    }
  }

  @override
  Future<void> close() {
    _usersSubscription?.cancel();
    return super.close();
  }
}
