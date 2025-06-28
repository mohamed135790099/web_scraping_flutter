import 'package:dart_either/src/dart_either.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web_scraping_flutter/advanced_bloc/features/core/data/base_usecase/base_usecase.dart';
import 'package:web_scraping_flutter/advanced_bloc/features/core/data/errors/failure/failure.dart';
import 'package:web_scraping_flutter/advanced_bloc/features/singup/domain/entity/user_entity.dart';

import '../../../data/signup_repository/signup_repository.dart';

class SignupUseCase extends BaseUseCase<UserEntity,SignupUseCaseInput>{

  SignupRepository signupRepository;

  SignupUseCase(this.signupRepository);
  @override
  Future<Either<Failure, UserEntity>> call(SignupUseCaseInput parameters)async{
    return await signupRepository.signup(SignupRequest(
        username: parameters.userName, email: parameters.email,
        profileImage:parameters.profileImage, password:parameters.password));

  }
}

class SignupUseCaseInput{
  String userName;
  String email;
  XFile profileImage;
  String password;

  SignupUseCaseInput(this.userName, this.email,this.profileImage,this.password);
}