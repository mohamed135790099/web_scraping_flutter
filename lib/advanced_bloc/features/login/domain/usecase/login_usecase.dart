import 'package:dart_either/src/dart_either.dart';
import 'package:web_scraping_flutter/advanced_bloc/features/core/data/errors/failure/failure.dart';
import 'package:web_scraping_flutter/advanced_bloc/features/login/data/repositories/login_repo_impl.dart';
import 'package:web_scraping_flutter/advanced_bloc/features/login/domain/entities/user_entity.dart';

import '../../../core/data/base_usecase/base_usecase.dart';

class LoginUseCase extends BaseUseCase<UserEntity,LoginUseCaseInput>{
  final LoginRepoImpl _loginRepo;
  LoginUseCase(this._loginRepo);
  @override
  Future<Either<Failure,UserEntity>> call(LoginUseCaseInput parameters)async {

    return await _loginRepo.authLogin(parameters.email, parameters.password);
  }
}

class LoginUseCaseInput{
  String email;
  String password;
  LoginUseCaseInput(this.email,this.password);
}