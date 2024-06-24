import 'package:ar_industrial/core/utils/color_constant.dart';
import 'package:ar_industrial/presentation/ar_model_screen.dart';
import 'package:ar_industrial/theme/app_style.dart';
import 'package:babylonjs_viewer/babylonjs_viewer.dart';
import 'package:flutter/material.dart';

class Model3DScreen extends StatelessWidget {
  const Model3DScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton:  Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            backgroundColor: ColorConstant.fromHex("#312C38"),
            foregroundColor: Colors.white,
            onPressed: (){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>ARModelScreen()));
            },
            label: Text("View AR Model"),
          ),
        ]
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("3D Model",style: AppStyle.txtMontserratSemiBold16,),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      ),
      body: BabylonJSViewer(
        
        src: 'assets/boiler.glb',
        
      ),
      //  body: Center(
      //   child:const ModelViewer(
      //     backgroundColor: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
          
      //     src: 'assets/boiler.glb',
      //     alt: 'A 3D model of an astronaut',
      //     ar: true,
       
      //     disableZoom: false,
      //   ),
      // ),
    );
  }
}