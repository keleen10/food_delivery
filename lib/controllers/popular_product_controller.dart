import 'package:flutter/material.dart';
import 'package:food_delivery/Data/repository/popular_product_repo.dart';
import 'package:food_delivery/controllers/cart_controller.dart';
import 'package:food_delivery/models/products_model.dart';
import 'package:food_delivery/util/app_constants.dart';
import 'package:food_delivery/util/colors.dart';
import 'package:get/get.dart';

class PopularProductController extends GetxController{
  final PopularProductRepo popularProductRepo;
  PopularProductController({required this.popularProductRepo});

  List<dynamic> _popularProductList = [];
  List<dynamic> get popularProductList => _popularProductList;
  late CartController _cart;

  bool _isLoaded = false;
  bool get isLoaded=> _isLoaded;

  int _quantity = 0;
  int get quantity=>_quantity;
  int _inCartItems = 0;
  int get inCartItems=>_inCartItems+_quantity;



  Future<void> getPopularProductList()async {
    Response response = await popularProductRepo.getPopularProductList();
    if(response.statusCode==200){

      //print('got products');
      _popularProductList=[];
      _popularProductList.addAll(Product.fromJson(response.body).products);
      //print(_popularProductList);
      _isLoaded = true;
      update();
    }else{

    }
  }

  void setQuantity(bool isIncrement){
    if(isIncrement){
      print('increment');
      _quantity = checkQuantity(_quantity+1);
    }else{
      _quantity = checkQuantity(_quantity-1);
    }
    update();
  }
  int checkQuantity(int quantity){
    if(quantity<0){
      Get.snackbar('Item count', 'You cannot reduce past 0!',
      backgroundColor: AppColors.mainColor,
        colorText: Colors.white
      );
      return 0;
    }else if(quantity>10){
      Get.snackbar('Item count', 'You cannot add more than 10!',
          backgroundColor: AppColors.mainColor,
          colorText: Colors.white
      );
      return 10;
    }else{
      return quantity;
    }
  }

  void initProduct(CartController cart){
    _quantity=0;
    _inCartItems=0;
    _cart = cart;
    //if exists
    //get from storage

  }

  void addItem(ProductModel product){
    if(_quantity>0){
      _cart.addItem(product, _quantity);
      _quantity=0;
      _cart.items.forEach((key, value) {
        print('The id is: '+value.id.toString()+' The quantity is: '+value.quantity.toString());
      });

    }else{
      Get.snackbar('Item count', 'Add an item first to the cart!',
          backgroundColor: AppColors.mainColor,
          colorText: Colors.white
      );

    }


  }
}