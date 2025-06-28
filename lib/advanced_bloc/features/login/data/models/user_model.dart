import '../../domain/entities/user_entity.dart';

class UserModel  extends UserEntity {
  const UserModel({
    required super.id,
    required super.organizationName,
    required super.userAddress,
    required super.userPhone,
    required super.userEmail,
    required super.userName,
    required super.apiToken,
    required super.isAccountEnabled,
  });


  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      organizationName: json['organization_name'] ?? '',
      userAddress: json['user_address'] ?? '',
      userPhone: json['user_phone'] ?? '',
      userEmail: json['user_email'] ?? '',
      userName: json['user_name'] ?? '',
      apiToken: json['api_token'] ?? '',
      isAccountEnabled: json['is_account_enabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_name': organizationName,
      'user_address': userAddress,
      'user_phone': userPhone,
      'user_email': userEmail,
      'user_name': userName,
      'api_token': apiToken,
      'is_account_enabled': isAccountEnabled,
    };
  }
}


