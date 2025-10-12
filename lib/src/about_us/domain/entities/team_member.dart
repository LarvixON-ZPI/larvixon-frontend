// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:larvixon_frontend/src/about_us/domain/entities/social_media_link.dart';

enum MemberRole {
  backend,
  ai,
  ml,
  frontend,
  simulation,
  ui,
  ux;

  @override
  String toString() => switch (this) {
    MemberRole.backend => "Backend",
    MemberRole.ai => "AI",
    MemberRole.ml => "ML",
    MemberRole.frontend => "Frontend",
    MemberRole.simulation => "Simulation",
    MemberRole.ui => "UI",
    MemberRole.ux => "UX",
  };
}

class TeamMember extends Equatable {
  final String name;
  final String surname;
  final String? imageUrl;
  final List<MemberRole>? roles;
  final String? mail;
  final List<SocialMediaLink>? links;

  const TeamMember({
    required this.name,
    required this.surname,
    this.imageUrl,
    this.roles,
    this.mail,
    this.links,
  });

  String? get rolesString => roles?.map((r) => r.toString()).join(", ");

  @override
  List<Object?> get props => [name, surname, imageUrl, roles];
}

const TeamMember jantar = TeamMember(
  name: "Mikołaj",
  surname: "Kubś",
  roles: [MemberRole.backend, MemberRole.frontend, MemberRole.simulation],
  imageUrl:
      "https://media.licdn.com/dms/image/v2/D4D03AQG6oFUiS0OdKg/profile-displayphoto-shrink_800_800/profile-displayphoto-shrink_800_800/0/1688760300402?e=1762992000&v=beta&t=SSEU3vqUAOiimvZcrGUnlUPIkqAYaPQ5ol4oByILCjU",
  links: [
    (
      platform: SocialMediaPlatform.github,
      url: "https://github.com/lmProgramming",
    ),

    (
      platform: SocialMediaPlatform.linkedin,
      url: "https://www.linkedin.com/in/mikolaj-kubs/",
    ),
  ],
);
const TeamMember margarynka = TeamMember(
  name: "Martyna",
  surname: "Łopianiak",
  roles: [MemberRole.backend],
  imageUrl:
      "https://media.licdn.com/dms/image/v2/D4D03AQFJ8sg0F35iZw/profile-displayphoto-shrink_800_800/profile-displayphoto-shrink_800_800/0/1707508655674?e=1762992000&v=beta&t=XYV4eGXpETomOMPcqJH_8aZsdjuiTYk8HLZsNFvWyOE",
  links: [
    (platform: SocialMediaPlatform.github, url: "https://github.com/charmosaa"),
    (
      platform: SocialMediaPlatform.linkedin,
      url: "https://www.linkedin.com/in/martyna-%C5%82opianiak-90b3572b4/",
    ),
  ],
);
const TeamMember krzysztof = TeamMember(
  name: "Krzysztof",
  surname: "Kulka",
  imageUrl:
      "https://media.licdn.com/dms/image/v2/D4D03AQH6dZ0tBa0bxA/profile-displayphoto-shrink_800_800/profile-displayphoto-shrink_800_800/0/1704545256993?e=1762992000&v=beta&t=8L1x210-aMT0LX8GHzOWzfrzJnrGCn3CvhqCyl-iWN4",
  roles: [MemberRole.ml],
  links: [
    (
      platform: SocialMediaPlatform.github,
      url: "https://github.com/coolka1234",
    ),
    (
      platform: SocialMediaPlatform.linkedin,
      url: "https://www.linkedin.com/in/krzysztof-kulka-773169266/",
    ),
  ],
);
const TeamMember patryk = TeamMember(
  name: "Patryk",
  surname: "Łuszczek",
  imageUrl:
      "https://scontent.fktw4-1.fna.fbcdn.net/v/t39.30808-6/311482015_1845762285763020_9214169842881339684_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=7rBSKwjCpNIQ7kNvwGRaIl_&_nc_oc=AdnckvoKNxjrAIA2nl24i5vE23uv6_DowmhhgqfS3l0vinXSK0fzb4JcKLmCp5Zegm4&_nc_zt=23&_nc_ht=scontent.fktw4-1.fna&_nc_gid=11RiVA5wXejOWHgg1nJhrQ&oh=00_AfccF6T23H6Y42DWs11fsg1KnrMNAzFdYLd76UvDVkCAGA&oe=68F1669B",
  roles: [MemberRole.frontend, MemberRole.ui, MemberRole.ux],
  links: [
    (platform: SocialMediaPlatform.github, url: "https://github.com/Wasloso"),
    (
      platform: SocialMediaPlatform.linkedin,
      url: "https://www.linkedin.com/in/wasloso/",
    ),
  ],
);
