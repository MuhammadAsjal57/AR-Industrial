import 'package:ar_industrial/Services/shared_pref_services.dart';

class UserModel {
  static UserModel? _user;
  static UserModel? get userModel =>_user ;
  final String? email;
  final String? password;
  final String? firstName;
  final String? lastName;
  final String? uId;
  final String? imageUrl;
  UserModel( {
    this.imageUrl, 
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.uId,
  });

  factory UserModel.fromJson(Map<String, dynamic>? json) {
    return UserModel(
      email: json?['email'],
      password: json?['password'],
      firstName: json?['firstName'],
      lastName: json?['lastName'],
      uId: json?['uId'],
      imageUrl: json?['imageUrl']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'uId':uId,
      'imageUrl':imageUrl
    };
  }

  static Future<bool> init() async {
    // Assuming sharedpref.getuser() returns a Future<UserModel>
    _user = await SharedPref.getuser();
    if(_user!=null){
      return true;
    }else{
      return false;
    }
  }
}