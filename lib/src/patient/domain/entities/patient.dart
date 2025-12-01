// ignore_for_file: public_member_api_docs
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';

enum Gender {
  male,
  female,
  other;

  String translate(BuildContext context) => switch (this) {
    Gender.male => context.translate.male,
    Gender.female => context.translate.female,
    Gender.other => context.translate.other,
  };

  static Gender? fromString(String? value) {
    if (value == null) return null;
    return switch (value.toLowerCase()) {
      'male' => Gender.male,
      'female' => Gender.female,
      'other' => Gender.other,
      _ => null,
    };
  }
}

class Patient extends Equatable {
  final String id;
  final String? pesel;
  final String? firstName;
  final String? lastName;
  final DateTime? birthDate;
  final Gender? gender;
  final String? phone;
  final String? email;
  final String? address;
  final String? city;
  final String? postalCode;
  final String? country;
  const Patient({
    required this.id,
    this.pesel,
    this.firstName,
    this.lastName,
    this.birthDate,
    this.gender,
    this.phone,
    this.email,
    this.address,
    this.city,
    this.postalCode,
    this.country,
  });
  const Patient.empty()
    : id = "-1",
      firstName = null,
      lastName = null,
      pesel = null,
      birthDate = null,
      gender = null,
      phone = null,
      email = null,
      address = null,
      city = null,
      postalCode = null,
      country = null;

  @override
  List<Object> get props => [id];
}
