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
  imageUrl: "assets/images/team/martyna.jpg",
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
  imageUrl: "assets/images/team/krzysztof.jpg",
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
  imageUrl: "assets/images/team/patryk.jpeg",
  roles: [MemberRole.frontend, MemberRole.ui, MemberRole.ux],
  links: [
    (platform: SocialMediaPlatform.github, url: "https://github.com/Wasloso"),
    (
      platform: SocialMediaPlatform.linkedin,
      url: "https://www.linkedin.com/in/wasloso/",
    ),
  ],
);
