part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

final class UserProfileClearRequested extends UserEvent {}

final class UserProfileDataRequested extends UserEvent {}

final class UserProfileDataUpdateRequested extends UserEvent {
  final User user;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? bio;
  final String? organization;
  final String? phoneNumber;
  final String? email;

  const UserProfileDataUpdateRequested({
    required this.user,
    this.firstName,
    this.lastName,
    this.username,
    this.bio,
    this.organization,
    this.phoneNumber,
    this.email,
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    username,
    bio,
    organization,
    phoneNumber,
    email,
  ];
}
