import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:web_scraping_flutter/advanced_bloc/features/login/presentation/cubit/anther_away_states.dart';

import '../../domain/usecase/login_usecase.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<UserLoginState> {
  final LoginUseCase _loginUseCase;
  LoginCubit(this._loginUseCase) : super(UserLoginState());
  
 Future<void> login(String email , String password) async{
   emit(state.copyWith(loginStatus: LoginStatus.loading));
   final result = await _loginUseCase.call(LoginUseCaseInput(email, password));
   result.fold(
         ifRight: (success){
           return emit(state.copyWith(
             loginStatus: LoginStatus.loading
           ));
         },
         ifLeft: (failure){
           return emit(state.copyWith(errorMessage:failure.message));
         },
   );
 }
}
