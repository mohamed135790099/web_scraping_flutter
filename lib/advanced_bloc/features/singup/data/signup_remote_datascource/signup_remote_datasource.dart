import 'package:image_picker/image_picker.dart';

import '../../../../../core/models/user_model.dart';
import '../../../core/data/remote/dio_helper.dart';


abstract class SignupRemoteDatasource {
 Future<UserModel> signup(String name,String email,XFile profileImage,String password);
}
class SignupRemoteDatasourceImpl extends SignupRemoteDatasource {
  final DioHelper _dioHelper;
  SignupRemoteDatasourceImpl(this._dioHelper);
  @override
  Future<UserModel> signup(String name, String email, XFile profileImage, String password)async{
    try{
      final response = await _dioHelper.post(
        endPoint: '/signup',
        isFormData: true,
        data: {
          'name': name,
          'email': email,
          'profileImage': profileImage.path, // Assuming the API accepts a file path
          'password': password
        },
      );
      if (response.statusCode == 200) {
        return UserModel.fromMap(response.data);
      } else {
        throw Exception("Failed to sign up: ${response.data['message']}");
      }
    }catch(e){
      throw Exception("Failed to sign up");
    }
  }
}