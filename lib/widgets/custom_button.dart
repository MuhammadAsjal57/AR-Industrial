import 'package:ar_industrial/core/utils/color_constant.dart';
import 'package:ar_industrial/core/utils/size_utils.dart';
import 'package:ar_industrial/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  const CustomButton({super.key,required this.onTap,required this.title});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        textStyle: AppStyle.txtMontserratRomanBold14,
        padding: getPadding(top: 16,bottom: 16),
        fixedSize: Size.fromWidth(width),
        backgroundColor: ColorConstant.fromHex("#312C38"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(getSize(8)))
      ),
      onPressed: onTap, 
      child: Text(title));
  }
}