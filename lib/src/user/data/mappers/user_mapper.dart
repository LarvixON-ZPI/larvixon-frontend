import 'package:larvixon_frontend/src/common/base_mapper.dart';
import 'package:larvixon_frontend/src/user/data/models/user_dto.dart';
import 'package:larvixon_frontend/src/user/domain/entities/user.dart';

class UserMapper implements Mapper<UserProfileDTO, User> {
  @override
  User dtoToEntity(UserProfileDTO dto) {
    final profile = dto.profile;
    return User(
      email: dto.email!,
      username: dto.username!,
      firstName: dto.first_name,
      lastName: dto.last_name,
      bio: profile?.bio,
      phoneNumber: profile?.phone_number,
      organization: profile?.organization,
      profilePictureUrl: profile?.profile_picture,
      dateJoined: dto.date_joined != null
          ? DateTime.tryParse(dto.date_joined!)
          : null,
    );
  }

  @override
  UserProfileDTO entityToDto(User entity) {
    final profile = UserProfileDetailsDTO(
      bio: entity.bio,
      phone_number: entity.phoneNumber,
      organization: entity.organization,
    );
    return UserProfileDTO(
      email: entity.email,
      username: entity.username,
      first_name: entity.firstName,
      last_name: entity.lastName,
      profile: profile,
      date_joined: entity.dateJoined?.toIso8601String(),
    );
  }
}
