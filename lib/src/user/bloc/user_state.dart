part of 'user_bloc.dart';

enum UserStatus { initial, loading, success, error }

final class UserState extends Equatable {
  final User user;
  final String? errorMessage;
  final UserStatus status;
  final bool isUpdating;
  const UserState({
    this.user = const User.empty(),
    this.errorMessage,
    this.status = UserStatus.initial,
    this.isUpdating = false,
  });

  @override
  List<Object?> get props => [user, errorMessage, status, isUpdating];

  UserState copyWith({
    User? user,
    String? errorMessage,
    UserStatus? status,
    bool? isUpdating,
  }) {
    if (status != UserStatus.error) {
      errorMessage = null;
    }
    return UserState(
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }
}
