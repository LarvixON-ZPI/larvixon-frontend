import 'dart:convert';

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

  factory User.fromJson(Map<String, dynamic> data) {
    var details = data['profile'];
    return User(
      email: data['email'],
      username: data['username'],
      firstName: data['first_name'],
      lastName: data['last_name'],
      dateJoined: DateTime.tryParse(data['date_joined']),
      bio: details['bio'],
      phoneNumber: details['phone_number'],
      organization: details['organization'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'date_joined': dateJoined?.toIso8601String(),
      'profile': {
        'bio': bio,
        'phone_number': phoneNumber,
        'organization': organization,
      },
    };
  }

  @override
  String toString() {
    return 'User{email: $email, username: $username, firstName: $firstName, lastName: $lastName, dateJoined: $dateJoined, bio: $bio, phoneNumber: $phoneNumber, organization: $organization}';
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
