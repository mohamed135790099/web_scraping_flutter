
import 'package:image_picker/image_picker.dart';

import '../../domain/entity/user_entity.dart';

class UserModel extends UserEntity{
  const UserModel({
    super.id,
    required super.name,
    required super.email,
    super.password,
    super.profileImage,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email':email,
      'password': password,
      'profileImage':profileImage,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      profileImage: map['profileImage'] as XFile,
    );
  }
}