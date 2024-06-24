import 'package:ar_industrial/core/utils/color_constant.dart';
import 'package:ar_industrial/core/utils/size_utils.dart';
import 'package:ar_industrial/theme/app_style.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {

  final TextInputType? keyboardType;
  final String hintText;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final int? maxLines;
  final bool? obscureText;
  final Widget? suffixIcon;
  final TextFormFieldType? textFormFieldType;
  final TextFormFieldValidateOn? validateOn;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  final TextEditingController? controller;
  final TextFormFieldVarient? varient;
  final bool? readOnly;
  final bool? enable;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final TextFormFieldFontStyle? fontStyle;
  const CustomTextField(
      {Key? key,
      required this.hintText,
      this.varient,
      this.prefixIcon,
      this.maxLines,
      this.controller,
      this.focusNode,
      this.keyboardType,
      this.readOnly,
      this.onTap,
      this.autovalidateMode,
      this.validator,
      this.validateOn,
      this.fontStyle,
      this.suffixIcon,
      this.obscureText,
      this.enable, this.textFormFieldType, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      focusNode: focusNode,
      controller: controller,
      onChanged:onChanged ,
      cursorColor: ColorConstant.white,
      style:_setStyle(),
      onTapOutside: (event) {FocusManager.instance.primaryFocus?.unfocus();},
      decoration: _setDecoration(),
      validator:validator?? (value)=>_setValidation(value),
    );
  }
  _setStyle(){
    switch(textFormFieldType){
      case TextFormFieldType.Searh:
       return AppStyle.txtMontserratRomanMedium14Black;
      default:
        return AppStyle.txtMontserratRomanMedium14;
    }
  }
  _setDecoration(){
    switch(textFormFieldType){
      case TextFormFieldType.Searh:
       return  InputDecoration(   
        prefixIcon: Image.asset("assets/images/logo.png",width: 15,),   
        suffixIcon: Icon(Icons.search),
        label: Text(hintText),
        labelStyle: AppStyle.txtMontserratRomanMedium14Black,
        enabledBorder:OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black45),
          borderRadius: BorderRadius.circular(getSize(8)),) ,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: ColorConstant.black),
          borderRadius: BorderRadius.circular(getSize(8)),),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color:Colors.black54,width: 2),
          borderRadius: BorderRadius.circular(getSize(8)),),
        // errorBorder:OutlineInputBorder(
        //   borderSide: BorderSide(color: Colors.red,width: 1.5),
        //   borderRadius: BorderRadius.circular(getSize(8)),),
        // focusedErrorBorder:OutlineInputBorder(
        //   borderSide: BorderSide(color: Colors.red,width: 2),
        //   borderRadius: BorderRadius.circular(getSize(8)),),
        errorStyle: AppStyle.txtMontserratRomanRegular10
      );
      default:
      return  InputDecoration(
        label: Text(hintText),
        labelStyle: AppStyle.txtMontserratRomanMedium14,
        enabledBorder:OutlineInputBorder(
          borderSide: BorderSide(color: ColorConstant.lightWhiteGrey),
          borderRadius: BorderRadius.circular(getSize(8)),) ,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: ColorConstant.white),
          borderRadius: BorderRadius.circular(getSize(8)),),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorConstant.white,width: 2),
          borderRadius: BorderRadius.circular(getSize(8)),),
        errorBorder:OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red,width: 1.5),
          borderRadius: BorderRadius.circular(getSize(8)),),
        focusedErrorBorder:OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red,width: 2),
          borderRadius: BorderRadius.circular(getSize(8)),),
        errorStyle: AppStyle.txtMontserratRomanRegular10
      );
      
    }
  }
  _setFontStyle() {
    switch (fontStyle) {
      case TextFormFieldFontStyle.MontserratRomanBold16Teal:
        TextStyle(
          color: ColorConstant.white,
          fontSize: getFontSize(
            16,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w700,
        );
        break;
      default:
        return TextStyle(
            color: ColorConstant.white,
            fontSize: getFontSize(
              14,
            ),
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            height: getVerticalSize(1.5));
    }
  }
  
  _setValidation(String? value) {
    switch (validateOn) {
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
      case TextFormFieldValidateOn.password:
      if (value == null || value.isEmpty) {
        return 'Please enter your password';
      } else if (value.length < 8) {
        return 'Password must be at least 8 characters';
      } 
      break;
      default:
        if (value!.isEmpty) {
          return "This Field is Required ";
        }
    }
  }
}



enum TextFormFieldVarient {
  TXTFieldWithSuffix,
  TXTFieldWithprefix,
  Desc,
}

enum TextFormFieldValidateOn {
  Phoneno,
  Email,
  password
}
enum TextFormFieldType {
  Searh,
  Black,
  White,
}
enum TextFormFieldFontStyle { PoppinsMedium14, MontserratRomanBold16Teal }
