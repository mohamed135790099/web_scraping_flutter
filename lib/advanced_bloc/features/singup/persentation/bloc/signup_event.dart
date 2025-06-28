

import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

sealed class SignupEvent{
  const SignupEvent();
}

class ChangeFullNameEvent extends SignupEvent {
  final String fullName;

  const ChangeFullNameEvent(this.fullName);
}

class ChangeEmailEvent extends SignupEvent {
  final String email;

  const ChangeEmailEvent(this.email);

  @override
  List<Object> get props => [email];
}

class ChangeProfileImageEvent extends SignupEvent {
  final XFile profileImage;

  const ChangeProfileImageEvent(this.profileImage);

  @override
  List<Object> get props => [profileImage];
}

class ChangePasswordEvent extends SignupEvent{
  final String password;

  const ChangePasswordEvent(this.password);
}

class ChangeConfirmPasswordEvent extends SignupEvent {
  final String confirmPassword;

  const ChangeConfirmPasswordEvent(this.confirmPassword);
}


class SignupSubmittedEvent extends SignupEvent {
   const SignupSubmittedEvent();
}