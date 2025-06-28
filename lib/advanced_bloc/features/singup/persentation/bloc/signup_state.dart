part of 'signup_bloc.dart';


enum SingUpStatus{
  initial,
  loading,
  success,
  failure
}

extension SingUpStatusExtension on SingUpStatus {
  bool get isInitial => this == SingUpStatus.initial;
  bool get isLoading => this == SingUpStatus.loading;
  bool get isSuccess => this == SingUpStatus.success;
  bool get isFailure => this == SingUpStatus.failure;
}
class SignupState {
  final String fullName;
  final String email;
  final String password;
  final String confirmPassword;
  final XFile? profileImage;
  final SingUpStatus? status;
  final UserEntity? userEntity;

  // Validation errors
  final String? fullNameError;
  final String? emailError;
  final String? passwordError;
  final String? confirmPasswordError;
  final String? profileImageError;


  const SignupState({
    this.fullName = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.profileImage,
    this.status = SingUpStatus.initial,
    this.userEntity,
    this.fullNameError,
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
    this.profileImageError,
  });

  SignupState copyWith({
    String? fullName,
    String? email,
    String? password,
    String? confirmPassword,
    XFile? profileImage,
    SingUpStatus? status,
    UserEntity? userEntity,
    String? fullNameError,
    String? emailError,
    String? passwordError,
    String? confirmPasswordError,
    String? profileImageError,
  }) {
    return SignupState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      profileImage: profileImage ?? this.profileImage,
      status: status ?? this.status,
      userEntity: userEntity ?? this.userEntity,
      fullNameError: fullNameError,
      emailError: emailError,
      passwordError: passwordError,
      confirmPasswordError: confirmPasswordError,
      profileImageError: profileImageError,
    );
  }

  @override
  List<Object?> get props => [
    fullName,
    email,
    password,
    confirmPassword,
    profileImage,
    status,
    userEntity,
    fullNameError,
    emailError,
    passwordError,
    confirmPasswordError,
    profileImageError
  ];

  bool get isValid {
    return fullNameError == null &&
        emailError == null &&
        passwordError == null &&
        confirmPasswordError == null &&
        profileImageError == null &&
        fullName.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty;
  }
}

