import 'dart:developer';

import 'package:ar_industrial/Models/items_model.dart';
import 'package:ar_industrial/Models/user_model.dart';
import 'package:ar_industrial/Services/shared_pref_services.dart';
import 'package:ar_industrial/core/utils/dialoge_constant.dart';
import 'package:ar_industrial/core/utils/size_utils.dart';
import 'package:ar_industrial/presentation/3d_model_screen.dart';
import 'package:ar_industrial/presentation/animation_screen.dart';
import 'package:ar_industrial/presentation/ar_model_screen.dart';
import 'package:ar_industrial/presentation/item_prewiew_screen.dart';
import 'package:ar_industrial/presentation/login_screen.dart';
import 'package:ar_industrial/presentation/training_screen,.dart';
import 'package:ar_industrial/theme/app_style.dart';
import 'package:ar_industrial/widgets/custom_button.dart';
import 'package:ar_industrial/widgets/custom_text_form_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    late TextEditingController _searchController;
  List<ItemsModel> _filteredItems = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController = TextEditingController();
    _filteredItems = ItemsModel.itemsModelList;
    
  }
   void _filterItems(String query) {
    setState(() {
      _filteredItems = ItemsModel.itemsModelList.where((item) {
        final title = item.itemTitle.toLowerCase();
        final searchLower = query.toLowerCase();
        return title.contains(searchLower);
      }).toList();
    });
  }
  _logout(){
    FirebaseAuth.instance.signOut().then((value) async{
      GoogleSignIn google = GoogleSignIn();
      await google.signOut();
      await SharedPref.setLogin(false);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>LoginScreen()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserModel.init(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
        return Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
          
            child: Container(
              
              decoration: BoxDecoration(
                color: const Color.fromRGBO(130, 2, 2, 1),
                borderRadius: BorderRadius.only(topRight: Radius.circular(getSize(8)),bottomRight: Radius.circular(getSize(8)))
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    radius: 0.8,
                    colors: [
                    Color.fromRGBO(0, 0, 0, 0.68),
                    Color.fromRGBO(0, 0, 0, 1),
                  ]),
                ),
                child: Padding(
                  padding: getPadding(all: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: getVerticalSize(70),),
                      Row(
                        children: [
                          SizedBox(
                            width: getHorizontalSize(57.1),
                            height: getVerticalSize(57.09),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(getSize(8)),
                              child: CachedNetworkImage(
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                imageUrl: UserModel.userModel!.imageUrl.toString(),
                                fit: BoxFit.contain,  
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                          Text(UserModel.userModel!.firstName!+" "+UserModel.userModel!.lastName!,style: AppStyle.txtMontserratRomanMedium14White,),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Divider(
                        color: Colors.white54,
                      ),
                       Padding(
                        padding:getPadding(all: 20),
                        child: CustomButton(onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (_)=>Model3DScreen()));
                        }, title: "3D Model"),
                      ),
                       Padding(
                        padding:getPadding(all: 20),
                        child: CustomButton(onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (_)=>AnimationScreen()));
                        }, title: "Animations"),
                      ),
                       Padding(
                        padding:getPadding(all: 20),
                        child: CustomButton(onTap: (){
                       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>ARModelScreen()));
                        }, title: "AR Simulation"),
                      ),
                      Padding(
                        padding:getPadding(all: 20),
                        child: CustomButton(onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (_)=>TrainingScreen()));
                        }, title: "Training"),
                      ),
                      Padding(
                        padding:getPadding(all: 20),
                        child: CustomButton(onTap: (){
                          _logout();
                        }, title: "Logout"),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          backgroundColor: Colors.white,
          body: Container(
            padding: getPadding(left: 20,right: 20,top: 40,),
            child: Column(
              children: [
                Align(alignment: Alignment.centerLeft, child: IconButton(onPressed: (){
               
                 _scaffoldKey.currentState!.openDrawer();
                }, icon:Icon(Icons.menu))),
                Image.asset("assets/images/logo.png",width: 120,),
                SizedBox(height: getVerticalSize(10),),
                CustomTextField(hintText: "search",textFormFieldType: TextFormFieldType.Searh,validator: (v){return null;},controller:_searchController ,onChanged: _filterItems,),
                Expanded(
                    child: _filteredItems.isEmpty
                        ? Center(child: Text("No items found"))
                        : GridView.count(
                            physics: BouncingScrollPhysics(),
                            crossAxisCount: 2,
                            childAspectRatio: 0.95,
                            children: List.generate(_filteredItems.length, (index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => ItemPreviewScreen(item: _filteredItems[index])));
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Card(
                                        color: Color.fromARGB(255, 236, 236, 236),
                                        child: Padding(
                                            padding: EdgeInsets.all(15),
                                            child: Hero(
                                                tag: _filteredItems[index].itemId,
                                                child: Image.asset(_filteredItems[index].itemImage)))),
                                    Text(_filteredItems[index].itemTitle,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))
                                  ],
                                ),
                              );
                            }),
                          ),
                  )
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}