part of 'user_bloc.dart';

enum UserStatus { initial, loading, success, error }

final class UserState extends Equatable {
  final User? user;
  final String? errorMessage;
  final UserStatus status;
  const UserState({
    this.user,
    this.errorMessage,
    this.status = UserStatus.initial,
  });

  @override
  List<Object?> get props => [user, errorMessage, status];

  UserState copyWith({User? user, String? errorMessage, UserStatus? status}) {
    if (status != null) {
      errorMessage = null;
    }
    return UserState(
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
    );
  }
}
