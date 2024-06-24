import 'package:ar_industrial/Models/user_model.dart';
import 'package:ar_industrial/Services/shared_pref_services.dart';
import 'package:ar_industrial/core/utils/dialoge_constant.dart';
import 'package:ar_industrial/core/utils/Image_constant.dart';
import 'package:ar_industrial/core/utils/color_constant.dart';
import 'package:ar_industrial/core/utils/size_utils.dart';

import 'package:ar_industrial/presentation/home_screen.dart';
import 'package:ar_industrial/presentation/registration_screen.dart';
import 'package:ar_industrial/theme/app_style.dart';
import 'package:ar_industrial/widgets/custom_button.dart';
import 'package:ar_industrial/widgets/custom_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  final _formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          color: const Color.fromRGBO(130, 2, 2, 1),
          child: Container(
            height: size.height,  
            decoration: BoxDecoration(
              gradient: RadialGradient(
                radius: 0.8,
                colors: [
                Color.fromRGBO(0, 0, 0, 0.68),
                Color.fromRGBO(0, 0, 0, 1),
              ]),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: getPadding(all: 20),
                    width: double.maxFinite,
                    height: getVerticalSize(320),
                    decoration: const BoxDecoration(
                      color: const Color.fromRGBO(130, 2, 2, 1),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(200, 50),bottomRight: Radius.elliptical(200, 50))
                    ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(ImageConstant.complexityGif,width: getVerticalSize(180),fit: BoxFit.contain,),
                      ClipOval(
                        child: Container(
                          width: getHorizontalSize(200),
                          height: getVerticalSize(30),
                          decoration: BoxDecoration(
                            
                            color: Color.fromARGB(59, 0, 0, 0),
                            
                          ),
                        ),
                      ),
                      SizedBox(height: getVerticalSize(20),),
                      Text("JOIN ITTAR",style: AppStyle.txtMontserratSemiBold16,),
                    ],
                  ),
                  ),
            
                  Padding(
                    padding: getPadding( all: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(height: getVerticalSize(10),),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("WELCOME!!",style: AppStyle.txtMontserratExtraBold25,)),
                          SizedBox(height: getVerticalSize(20),),
                          CustomTextField(
                            controller: emailController,
                            hintText: "Email",
                            validateOn: TextFormFieldValidateOn.Email,
                            ),
                          SizedBox(height: getVerticalSize(20),),
                          CustomTextField( controller: passwordController,hintText: "Password",),
                          SizedBox(height: getVerticalSize(20),),
                          CustomButton(title: "LOGIN",onTap: () {
                            _login(context);
                          },),
                          SizedBox(height: getVerticalSize(20),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don’t have a account?",style: AppStyle.txtMontserratRomanSemiBold12,),
                              TextButton(onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (_)=>RegistrationScreen())), child: Text("SIGN UP",))
                            ],
                          ),

                          SizedBox(height: getVerticalSize(10),),
                          Text("OR",style: AppStyle.txtMontserratRomanSemiBold12,),
                          SizedBox(height: getVerticalSize(20),),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorConstant.fromHex("#F7EFE7"),
                              padding: getPadding(top: 8,bottom: 8,left: 10,right: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(getSize(8)))
                            ),
                            onPressed: (){
                              _signUpWithGoogle(context);
                            }, icon:Image.asset(ImageConstant.googleLogoImg,width: getHorizontalSize(30),), label:Text("Continue with google",style: AppStyle.txtMontserratRomanSemiBold11Black,))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _setValidation(String? value) {
    switch (TextFormFieldValidateOn.Email) {
      case TextFormFieldValidateOn.Phoneno:
        String pattern = r'^(?:[+0][1-9])?[0-9]{10,12}$';
        RegExp regex = new RegExp(pattern);
        if (value!.isEmpty) {
          return "This Field is Required ";
        } else if (!regex.hasMatch(value)) {
          return 'Enter Valid Phone Number';
        }
        break;
      case TextFormFieldValidateOn.Email:
        String pattern = r'\S+@\S+\.\S+';
        RegExp regex = new RegExp(pattern);
        if (value!.isEmpty) {
          return "This Field is Required ";
        } else if (!regex.hasMatch(value)) {
          return 'Enter Valid Email';
        }
        break;
      default:
        if (value!.isEmpty) {
          return "This Field is Required ";
        }
    }
  }
 
  Future<void> _signUpWithGoogle(BuildContext context) async {
    DialogConstant.showLoading(context);
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential userCredential = await _auth.signInWithCredential(credential);
        final User? user = userCredential.user;
        final String uid = user!.uid;
        UserModel userModel=UserModel(email: user.email, firstName:user.displayName.toString().split(" ").first, lastName: user.displayName.toString().split(" ").last,uId:userCredential.user!.uid,imageUrl: userCredential.user!.photoURL );
        // Store user data in Firestore
        await FirebaseFirestore.instance.collection('users').doc(uid).set(userModel.toJson()).then((value)async {
          // You can access the user information using userCredential.user
        // Navigate to home page or do something after successful signup
        await SharedPref.setuser(userModel);
        await SharedPref.setLogin(true);
        Navigator.pop(context);
        DialogConstant.showSnackBar(context);
        Future.delayed(Duration(seconds: 1), () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
            });
        print('User signed up with Google: ${userCredential.user!.displayName}');
        });
        
      } else {
        // Handle if the user cancels sign-in process
        
        Navigator.pop(context);
        DialogConstant.showSnackBar2(context,"Google sign in cancelled");
        print('Google sign in cancelled');
      }
    } catch (error) {
      Navigator.pop(context);
      DialogConstant.showSnackBar2(context,'Error signing in with Google: $error');
      print('Error signing in with Google: $error');
    }
  }
  Future<void> _login(BuildContext context) async {
    if(_formKey.currentState!.validate()){
    DialogConstant.showLoading(context);
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
          // Save additional user data to Firestore
          DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).get() ;
          if(userData.exists){
            UserModel userModel=UserModel(email: userData['email'],firstName: userData['firstName'],lastName: userData['lastName'],uId: userCredential.user!.uid,imageUrl: userData['imageUrl']);
            await SharedPref.setLogin(true);
            await SharedPref.setuser(userModel);
            Navigator.pop(context);
            DialogConstant.showSnackBar(context);
            Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          });
          print('User signed up: ${userCredential.user!.email}');
          }
           

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        Navigator.pop(context);
        DialogConstant.showSnackBar2(context,'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        Navigator.pop(context);
        DialogConstant.showSnackBar2(context,'Wrong password provided for that user.');
      } else {
        print('Error: ${e.message}');
        Navigator.pop(context);
        DialogConstant.showSnackBar2(context,'Error: ${e.message}');
      }
    }
    }
  }
}