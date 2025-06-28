import 'package:equatable/equatable.dart';

class UserEntity extends Equatable{
  final int id;
  final String organizationName;
  final String userAddress;
  final String userPhone;
  final String userEmail;
  final String userName;
  final String apiToken;
  final bool isAccountEnabled;

  const UserEntity({
    required this.id,
    required this.organizationName,
    required this.userAddress,
    required this.userPhone,
    required this.userEmail,
    required this.userName,
    required this.apiToken,
    required this.isAccountEnabled
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    organizationName,
    userAddress,
    userPhone,
    userEmail,
    userName,
    apiToken,
    isAccountEnabled
  ];

}