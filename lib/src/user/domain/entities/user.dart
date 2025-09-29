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

  const User({
    required this.email,
    required this.username,
    this.firstName,
    this.lastName,
    this.dateJoined,
    this.bio,
    this.phoneNumber,
    this.organization,
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
  ];
}
