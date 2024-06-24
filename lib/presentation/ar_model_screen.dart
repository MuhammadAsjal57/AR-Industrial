import 'package:ar_industrial/core/utils/size_utils.dart';
import 'package:ar_industrial/presentation/training_screen,.dart';
import 'package:ar_industrial/theme/app_style.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_button.dart';

class ARModelScreen extends StatefulWidget {
  const ARModelScreen({super.key});

  @override
  State<ARModelScreen> createState() => _ARModelScreenState();
}

class _ARModelScreenState extends State<ARModelScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("AR Model",style: AppStyle.txtMontserratSemiBold16,),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      ),
      body: Padding(
        
        padding: getPadding(top: 20,left: 20,right: 20,bottom: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("AR Model not implemented yet!"),
            SizedBox(height: getVerticalSize(100),),
            CustomButton(title: "Training",onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_)=>TrainingScreen()));
            },),
          ],
        ),
      ),
    );
  }
}