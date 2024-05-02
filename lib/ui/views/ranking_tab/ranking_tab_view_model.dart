import 'package:flutter/material.dart';
import 'package:tic_tac_toe/core/enums/view_state.dart';
import 'package:tic_tac_toe/core/models/user.dart';
import 'package:tic_tac_toe/core/property.dart';
import 'package:tic_tac_toe/core/repositories/user_repository.dart';

class RankingTabViewModel extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  late Property<List<User>> users = Property([], notifyListeners);
  late Property<ViewState> state = Property(ViewState.loading, notifyListeners);
  late Property<ViewState> loadMoreState =
      Property(ViewState.loading, notifyListeners);
  String? next;

  Future<void> getUsers() async {
    try {
      state.value = ViewState.loading;
      final response = await _userRepository.getUsers();
      users.value = response.results;
      next = response.next;
      state.value = ViewState.idle;
    } catch (e) {
      state.value = ViewState.error;
    }
  }

  Future<void> loadMoreUsers() async {
    try {
      if (next == null) {
        return;
      }
      loadMoreState.value = ViewState.loading;
      UserResponse res = await _userRepository.loadMore(next!);
      next = res.next;
      users.value = [...users.value, ...res.results];
      loadMoreState.value = ViewState.idle;
    } catch (e) {
      throw e.toString();
    } finally {
      loadMoreState.value = ViewState.idle;
    }
  }
}
