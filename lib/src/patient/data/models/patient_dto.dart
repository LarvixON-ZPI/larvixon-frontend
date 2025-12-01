// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PatientDTO {
  final String id;
  final String? pesel;
  final String? first_name;
  final String? last_name;
  final String? birth_date;
  final String? gender;
  final String? phone;
  final String? email;
  final String? address_line;
  final String? city;
  final String? postal_code;
  final String? country;

  const PatientDTO({
    required this.id,
    this.pesel,
    this.first_name,
    this.last_name,
    this.birth_date,
    this.gender,
    this.phone,
    this.email,
    this.address_line,
    this.city,
    this.postal_code,
    this.country,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'pesel': pesel,
      'first_name': first_name,
      'last_name': last_name,
      'birth_date': birth_date,
      'gender': gender,
      'phone': phone,
      'email': email,
      'address_line': address_line,
      'city': city,
      'postal_code': postal_code,
      'country': country,
    };
  }

  factory PatientDTO.fromMap(Map<String, dynamic> map) {
    return PatientDTO(
      id: map['id'] as String,
      pesel: map['pesel'] != null ? map['pesel'] as String : null,
      first_name: map['first_name'] != null
          ? map['first_name'] as String
          : null,
      last_name: map['last_name'] != null ? map['last_name'] as String : null,
      birth_date: map['birth_date'] != null
          ? map['birth_date'] as String
          : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      address_line: map['address_line'] != null
          ? map['address_line'] as String
          : null,
      city: map['city'] != null ? map['city'] as String : null,
      postal_code: map['postal_code'] != null
          ? map['postal_code'] as String
          : null,
      country: map['country'] != null ? map['country'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PatientDTO.fromJson(String source) =>
      PatientDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
