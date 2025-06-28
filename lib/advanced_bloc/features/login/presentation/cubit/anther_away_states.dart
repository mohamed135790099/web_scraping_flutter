import '../../domain/entities/user_entity.dart';

enum LoginStatus{
  initial,
  loading,
  loaded,
  error,
}

extension LoginStatusX on LoginStatus{
  bool get isInitial => this == LoginStatus.initial;
  bool get isLoading => this == LoginStatus.loading;
  bool get isLoaded => this == LoginStatus.loaded;
  bool get isError => this == LoginStatus.error;
}

class UserLoginState{
  LoginStatus loginStatus;
  UserEntity?  userEntity;
  String? errorMessage;
  UserLoginState({this.loginStatus = LoginStatus.initial, this.userEntity, this.errorMessage});

  UserLoginState copyWith({
    LoginStatus? loginStatus,
    UserEntity? userEntity,
    String? errorMessage,
  }) {
    return UserLoginState(
      loginStatus: loginStatus ?? this.loginStatus,
      userEntity: userEntity ?? this.userEntity,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
