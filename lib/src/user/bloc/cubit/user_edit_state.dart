part of 'user_edit_cubit.dart';

enum EditStatus { idle, uploadingPhoto, saving, success, error }

final class UserEditState extends Equatable {
  final String? bio;
  final String? organization;
  final String? phoneNumber;
  final String? errorMessage;
  final EditStatus status;
  final Failure? error;
  final Map<String, String> fieldErrors;
  const UserEditState({
    this.bio,
    this.organization,
    this.phoneNumber,
    this.errorMessage,
    this.status = EditStatus.idle,
    this.error,
    required this.fieldErrors,
  });

  UserEditState copyWith({
    String? bio,
    String? organization,
    String? phoneNumber,
    EditStatus? status,
    String? errorMessage,
    bool? hasChanges,
    Failure? error,
    Map<String, String>? fieldErrors,
  }) {
    return UserEditState(
      bio: bio ?? this.bio,
      organization: organization ?? this.organization,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      error: error ?? this.error,
      fieldErrors: fieldErrors ?? this.fieldErrors,
    );
  }

  @override
  List<Object?> get props => [
    bio,
    organization,
    phoneNumber,
    status,
    errorMessage,
    fieldErrors,
    error,
  ];
}
