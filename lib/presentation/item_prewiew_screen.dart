import 'package:ar_industrial/Models/items_model.dart';
import 'package:ar_industrial/core/utils/size_utils.dart';
import 'package:ar_industrial/presentation/3d_model_screen.dart';
import 'package:ar_industrial/presentation/animation_screen.dart';
import 'package:ar_industrial/theme/app_style.dart';
import 'package:ar_industrial/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class ItemPreviewScreen extends StatelessWidget {
  final ItemsModel item;
  const ItemPreviewScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: getVerticalSize(300),           
              decoration: BoxDecoration(
                color: const Color.fromRGBO(130, 2, 2, 1),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(200, 50),bottomRight: Radius.elliptical(200, 50)),
              ),
              child: Container(
                padding: getPadding(top: 40,left: 20,right: 20,bottom: 20),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    radius: 0.8,
                    colors: [
                    Color.fromRGBO(0, 0, 0, 0.68),
                    Color.fromRGBO(0, 0, 0, 1),
                  ]),
                  color: Color.fromARGB(255, 236, 236, 236),
                 
                ),
                child: Center(child: Padding(
                  padding: getPadding(all: 20),
                  child: Hero(
                    tag: item.itemId,
                    child: Image.asset(item.itemImage)),
                )),
              ),
            ),
            Padding(
              padding: getPadding(all: 20),
              child: Text(item.itemTitle,style: AppStyle.txtMontserratSemiBold20Black,),
            ),
            SizedBox(
              height: getVerticalSize(250),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: getPadding(left: 20,right: 20),
                  child:
                    Text(item.itemDescription  ,style: AppStyle.txtMontserratRomanRegular14Black54,),
                    
                ),
              ),
            ),


            Padding(
              padding: getPadding(top: 20,right: 20,left: 20),
              child: CustomButton(title: "Animation",onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_)=>AnimationScreen()));
              },),
            ),
            Padding(
              padding: getPadding(right: 20,left: 20,top: 20),
              child: CustomButton(title: "View 3D model",onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_)=>Model3DScreen()));
              },),
            ),
          ],
        ),
      ),
    );
  }
}