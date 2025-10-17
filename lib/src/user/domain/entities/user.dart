import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String email;
  final String username;
  final String? firstName;
  final String? lastName;
  final DateTime? dateJoined;
  final String? bio;
  final String? phoneNumber;
  final String? organization;
  final String? profilePictureUrl;

  const User({
    required this.email,
    required this.username,
    this.firstName,
    this.lastName,
    this.dateJoined,
    this.bio,
    this.phoneNumber,
    this.organization,
    this.profilePictureUrl,
  });

  User copyWith({
    String? email,
    String? username,
    String? firstName,
    String? lastName,
    DateTime? dateJoined,
    String? bio,
    String? phoneNumber,
    String? organization,
    String? profilePictureUrl,
  }) {
    return User(
      email: email ?? this.email,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateJoined: dateJoined ?? this.dateJoined,
      bio: bio ?? this.bio,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      organization: organization ?? this.organization,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
    );
  }

  @override
  List<Object?> get props => [
    email,
    username,
    firstName,
    lastName,
    dateJoined,
    bio,
    phoneNumber,
    organization,
    profilePictureUrl,
  ];
}
