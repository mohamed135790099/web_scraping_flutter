import 'package:dartz/dartz.dart';

import '../../../core/data/errors/failure/failure.dart';
import '../entities/user_entity.dart';

abstract class LoginRepo {
  Future<Either<Failure,UserEntity>> authLogin(String email, String password);
}