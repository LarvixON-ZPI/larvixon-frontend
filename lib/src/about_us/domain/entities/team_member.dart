// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

enum MemberRole {
  backend("Backend"),
  ai("AI"),
  ml("ML"),
  frontend("Frontend"),
  simulation("Simulation"),
  ui("UI"),
  ux("UX");

  final String displayName;

  const MemberRole(this.displayName);
}

class TeamMember extends Equatable {
  final String name;
  final String surname;
  final String? imageUrl;
  final List<MemberRole>? roles;
  const TeamMember({
    required this.name,
    required this.surname,
    this.imageUrl,
    this.roles,
  });

  String? get rolesString => roles?.map((r) => r.displayName).join(", ");

  @override
  List<Object?> get props => [name, surname, imageUrl, roles];
}
