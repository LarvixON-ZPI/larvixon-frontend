// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class UserProfileDTO {
  final String? email;
  final String? username;
  final String? first_name;
  final String? last_name;
  final String? date_joined;
  final UserProfileDetailsDTO? profile;

  UserProfileDTO({
    this.email,
    this.username,
    this.first_name,
    this.last_name,
    this.date_joined,
    this.profile,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'username': username,
      'first_name': first_name,
      'last_name': last_name,
      'date_joined': date_joined,
      'profile': profile?.toJson(),
    };
  }

  factory UserProfileDTO.fromMap(Map<String, dynamic> map) {
    for (var k in map.keys) {
      print('$k: ${map[k]}, type: ${map[k].runtimeType}');
    }
    return UserProfileDTO(
      email: map["email"] as String?,
      first_name: map["first_name"] as String?,
      last_name: map["last_name"] as String?,
      username: map["username"] as String?,
      date_joined: map["date_joined"] as String?,
      profile: map["profile"] != null
          ? UserProfileDetailsDTO.fromMap(
              map["profile"] as Map<String, dynamic>,
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfileDTO.fromJson(String source) {
    return UserProfileDTO.fromMap(json.decode(source));
  }
}

class UserProfileDetailsDTO {
  final String? bio;
  final String? phone_number;
  final String? organization;

  UserProfileDetailsDTO({this.bio, this.phone_number, this.organization});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bio': bio,
      'phone_number': phone_number,
      'organization': organization,
    };
  }

  factory UserProfileDetailsDTO.fromMap(Map<String, dynamic> map) {
    return UserProfileDetailsDTO(
      bio: map['bio'] as String?,
      phone_number: map['phone_number'] as String?,
      organization: map['organization'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfileDetailsDTO.fromJson(String source) =>
      UserProfileDetailsDTO.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}
