import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web_scraping_flutter/advanced_bloc/features/login/domain/entities/user_entity.dart';
import 'package:web_scraping_flutter/advanced_bloc/features/singup/persentation/bloc/signup_event.dart';

import '../../domain/sigup_usecase/dart/signup_usecase.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupUseCase signupUseCase;
  SignupBloc(this.signupUseCase) : super(const SignupState()) {
    on<ChangeFullNameEvent>(_onChangeFullName);
    on<ChangeEmailEvent>(_onChangeEmail);
    on<ChangeProfileImageEvent>(_onChangeProfileImage);
    on<ChangePasswordEvent>(_onChangePassword);
    on<ChangeConfirmPasswordEvent>(_onChangeConfirmPassword);
    on<SignupSubmittedEvent> (_onSignupSubmitted);
  }

  FutureOr<void> _onChangeFullName(ChangeFullNameEvent event, Emitter<SignupState> emit){
    emit(state.copyWith(
      fullName: event.fullName,
      fullNameError: _validateFullName(event.fullName),
    ));
  }

  FutureOr<void> _onChangeEmail(ChangeEmailEvent event, Emitter<SignupState> emit) {
    emit(state.copyWith(
      email: event.email,
      emailError: _validateEmail(event.email)
    ));
  }

  FutureOr<void> _onChangeProfileImage(ChangeProfileImageEvent event,Emitter<SignupState> emit){
    emit(state.copyWith(
      profileImage: event.profileImage,
      profileImageError: _validateProfileImage(event.profileImage)
    ));
  }

  FutureOr<void> _onChangePassword(ChangePasswordEvent event, Emitter<SignupState> emit) {
    emit(state.copyWith(
      password: event.password,
      passwordError: _validatePassword(event.password)
    ));
  }

  FutureOr<void> _onChangeConfirmPassword(ChangeConfirmPasswordEvent event, Emitter<SignupState> emit) {
    emit(state.copyWith(
      confirmPassword: event.confirmPassword,
      confirmPasswordError: _validateConfirmPassword(state.password, event.confirmPassword)
    ));
  }

  FutureOr<void> _onSignupSubmitted(SignupSubmittedEvent event ,Emitter<SignupState> emit){
    if (state.isValid) {
      emit(state.copyWith(status:SingUpStatus.loading));
      // Simulate a signup process
      signupUseCase.call(
        SignupUseCaseInput(
            state.fullName,
            state.email,
            state.profileImage!,
            state.password
        )
      );
    } else {
      emit(state.copyWith(status: SingUpStatus.failure));
    }
  }


  // Helper validation methods
  String? _validateFullName(String fullName) {
    if (fullName.isEmpty) return 'Full name is required';
    if (fullName.length < 3) return 'Name too short';

    return null;
  }

  String? _validateEmail(String email) {
    if (email.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) return 'Password is required';
    if (password.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? _validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) return 'Please confirm your password';
    if (password != confirmPassword) return 'Passwords do not match';
    return null;
  }

  String? _validateProfileImage(XFile? image) {
    if (image == null) return 'Profile image is required';
    return null;
  }




}
