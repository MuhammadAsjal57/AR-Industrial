import 'package:ar_industrial/Models/user_model.dart';
import 'package:ar_industrial/Services/shared_pref_services.dart';
import 'package:ar_industrial/core/utils/Image_constant.dart';
import 'package:ar_industrial/core/utils/dialoge_constant.dart';
import 'package:ar_industrial/core/utils/size_utils.dart';
import 'package:ar_industrial/presentation/home_screen.dart';
import 'package:ar_industrial/theme/app_style.dart';
import 'package:ar_industrial/widgets/custom_button.dart';
import 'package:ar_industrial/widgets/custom_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey=GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  _signUp()async{
    if(_formKey.currentState!.validate()){
     
      DialogConstant.showLoading(context);
       try {
          UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );
          
           UserModel user=UserModel(email: emailController.text, password: passwordController.text, firstName:firstNameController.text, lastName: lastNameController.text,uId:userCredential.user!.uid ,imageUrl: "https://firebasestorage.googleapis.com/v0/b/ittar-a19ea.appspot.com/o/user.png?alt=media&token=df0d68e1-f6d0-4929-a4e1-560f81ad2dec");
          // Save additional user data to Firestore
          await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set(user.toJson()).then((value)async {   
              await SharedPref.setuser(user);
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
              print('User signed up: ${userCredential.user!.email}');
           });

          // Navigate to home page or do something after successful signup
         
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            print('The password provided is too weak.');
            Navigator.pop(context);
            DialogConstant.showSnackBar2(context,'The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            print('The account already exists for that email.');
            Navigator.pop(context);
            DialogConstant.showSnackBar2(context,'The account already exists for that email.');
          } else {
            print('Error: ${e.message}');
            Navigator.pop(context);
            DialogConstant.showSnackBar2(context,'Error: ${e.message}');
          }
        }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SizedBox(
          child: Container(
            color: const Color.fromRGBO(130, 2, 2, 1),
            child: Container(
              height: size.height,
              padding: getPadding(all: 20),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                    radius: 0.8,
                    colors: [
                    Color.fromRGBO(0, 0, 0, 0.68),
                    Color.fromRGBO(0, 0, 0, 1),
                  ]),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: getVerticalSize(20),),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(onPressed: (){
                        Navigator.pop(context);
                      }, icon: Image.asset(ImageConstant.backArrowImg,width: 20,height: 30,))),
                    SizedBox(height: getVerticalSize(30),),
                  
                    Center(child: Image.asset(ImageConstant.SignUpImg,width: getSize(100),)),
                    SizedBox(height: getVerticalSize(20),),
                    Text("It's quick and easy",style:AppStyle.txtMontserratRomanSemiBold14,),
                    SizedBox(height: getVerticalSize(20),),
                    Center(
                      child: Container(
                        padding: getPadding(all: 20),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(60, 0, 0, 0)
                        ),
                        child: Column(
                          
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: getVerticalSize(20),),
                            CustomTextField(controller: firstNameController, hintText: "First Name",),
                            SizedBox(height: getVerticalSize(20),),
                            CustomTextField(controller: lastNameController,hintText: "Last Name",),
                            SizedBox(height: getVerticalSize(20),),
                            CustomTextField(controller: emailController,hintText: "Email",validateOn: TextFormFieldValidateOn.Email,),
                            SizedBox(height: getVerticalSize(20),),
                            CustomTextField(controller: passwordController, hintText: "Password",validateOn: TextFormFieldValidateOn.password,),
                            SizedBox(height: getVerticalSize(50),),
                            CustomButton(title: "SIGN UP",onTap: () {
                              _signUp();
                            },),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}