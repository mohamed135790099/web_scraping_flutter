import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/data/errors/failure/failure.dart';
import '../../domain/entity/user_entity.dart';
import '../signup_remote_datascource/signup_remote_datasource.dart';

abstract class SignupRepository{
  Future<Either<Failure, UserEntity>> signup(SignupRequest signupRequest);
}
class SignupRepositoryImpl implements SignupRepository {
final SignupRemoteDatasource _signupRemoteDatasource;

  SignupRepositoryImpl(this._signupRemoteDatasource);

  @override
  Future<Either<Failure, UserEntity>> signup(SignupRequest signupRequest) async {
    try {
      final response = await _signupRemoteDatasource.signup(
        signupRequest.username,
        signupRequest.email,
        signupRequest.profileImage,
        signupRequest.password,
      );
      return Right(response);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}

class SignupRequest {
  final String username;
  final String email;
  XFile profileImage;
  final String password;

  SignupRequest({
    required this.username,
    required this.email,
    required this.profileImage,
    required this.password,
  });
}