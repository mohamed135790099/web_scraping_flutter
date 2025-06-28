import 'package:dartz/dartz.dart';
import '../../../core/data/errors/failure/failure.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositiores_impl/login_repo.dart';
import '../remote_data_source/login_remote_datascoure.dart';
class LoginRepoImpl implements LoginRepo {
  final LoginRemoteDataSource _loginRemoteDataSource;
  LoginRepoImpl(this._loginRemoteDataSource);

  @override
  Future<Either<Failure,UserEntity>> authLogin(String email, String password) async{
    try{
    final response = await _loginRemoteDataSource.authLogin(email, password);
    if(response.id != null && response.apiToken.isNotEmpty){
      return Right(response);
    } else {
      return const Left(Failure( "An error occurred"));
    }
   }catch(e){
     return Left(Failure(e.toString()));
   }
  }
}