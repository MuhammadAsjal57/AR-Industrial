import 'package:ar_industrial/core/utils/Image_constant.dart';

class ItemsModel {
  final int itemId;
  final String itemTitle;
  final String itemDescription;
  final String itemImage;

  ItemsModel({
    required this.itemId,
    required this.itemTitle,
    required this.itemDescription,
    required this.itemImage,
  });

  static List<ItemsModel> itemsModelList=[
    ItemsModel(itemId: 1, itemTitle: "Boiler Machine", itemDescription: "A boiler is a closed vessel in which water is heated to produce steam or hot water. The steam or hot water is then used for a variety of purposes, including heating buildings, generating electricity, and sterilizing equipment. Boilers convert water into steam or hot water, which can be used for a variety of purposes, including heating, steam production, and power generation. They are available in a range of designs to meet the specific needs of different industries.", itemImage: ImageConstant.BoilerImg),
  ];
  factory ItemsModel.fromJson(Map<String, dynamic> json) {
    return ItemsModel(
      itemId: json['itemId'] as int,
      itemTitle: json['itemTitle'] as String,
      itemDescription: json['itemDescription'] as String,
      itemImage: json['itemImage'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'itemTitle': itemTitle,
      'itemDescription': itemDescription,
      'itemImage': itemImage,
    };
  }
}
