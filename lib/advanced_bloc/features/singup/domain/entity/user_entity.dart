import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

class UserEntity extends Equatable{
  final String? id;
  final String name;
  final String email;
  final String? password;
  final XFile? profileImage;

  const UserEntity({
    this.id,
    required this.name,
    required this.email,
    this.password,
    this.profileImage,
  });

  @override
  String toString() {
    return 'UserEntity{id: $id, name: $name, email: $email}';
  }

  @override
  List<Object?> get props =>[
    id,
    name,
    email,
    password,
    profileImage,
  ];

}