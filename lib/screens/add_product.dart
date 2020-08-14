import 'dart:ffi';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rstikaadminapp/db/product.dart';
import 'package:uuid/uuid.dart';
import '../db/category.dart';
import '../db/brand.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:fluttertoast/fluttertoast.dart';

class AddProduct extends StatefulWidget {
  String email;

  AddProduct({Key key, this.email}) : super(key: key);
  
  @override
  _AddProductState createState() => _AddProductState(email);
}

class _AddProductState extends State<AddProduct> {
  CategoryService _categoryService = CategoryService();
  BrandService _brandService = BrandService();
  ProductService productService = ProductService();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email;
  _AddProductState(this.email);

  List<DropdownMenuItem<String>> categoriesDropDown =
      <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> brandsDropDown = <DropdownMenuItem<String>>[];
  String _currentCategory = "test";
  String _currentBrand;
  Color white = Colors.white;
  Color black = Colors.black;
  Color grey = Colors.grey;
  Color red = Colors.red;
  List<String> selectedSizes = <String>[];
  File _image1;
  bool isLoading = false;
  var selectedCategory;
  String productName;
  String price;
  FToast fToast;
  @override
  void initState() {
    // _getCategories();
    // _currentCategory = categoriesDropDown[0].value;
    fToast = FToast(context);

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: white,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.close),
          color: black,
        ),
        title: Text(
          "Add Food",
          style: TextStyle(color: black),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: isLoading
              ? CircularProgressIndicator()
              : Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OutlineButton(
                                borderSide: BorderSide(
                                    color: grey.withOpacity(0.5), width: 2.5),
                                onPressed: () {
                                  _selectImage(
                                      ImagePicker.pickImage(
                                          source: ImageSource.gallery),
                                      1);
                                },
                                child: _displayChild1()),
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'enter a product name with 10 characters at maximum',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: red, fontSize: 12),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        onChanged: (value){
                          productName = value;
                        },
                        decoration: InputDecoration(hintText: 'Product name'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'You must enter the product name';
                          } else if (value.length > 3) {
                            return 'Product name cant have more than 10 letters';
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('restaurants').document(email).collection('Menu').document(email + 'Menu').collection('Categories').snapshots(),
                  builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        const Text("Loading.....");
                      else {
                        List<DropdownMenuItem> currencyItems = [];
                        for (int i = 0; i < snapshot.data.documents.length; i++) {
                          DocumentSnapshot snap = snapshot.data.documents[i];
                          currencyItems.add(
                            DropdownMenuItem(
                              child: Text(
                                snap.documentID,
                                style: TextStyle(color: Colors.red),
                              ),
                              value: "${snap.documentID}",
                            ),
                          );
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(Icons.category,
                                size: 25.0, color: Colors.red),
                            SizedBox(width: 50.0),
                            DropdownButton(
                              items: currencyItems,
                              onChanged: (currencyValue) {
                                final snackBar = SnackBar(
                                  content: Text(
                                    'Selected Category is $currencyValue',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                );
                                Scaffold.of(context).showSnackBar(snackBar);
                                setState(() {
                                  selectedCategory = currencyValue;
                                });
                              },
                              value: selectedCategory,
                              isExpanded: false,
                              hint: new Text(
                                "Choose Category",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      }
                  }),
                    ),
// //              select category
//                     Row(
//                       children: <Widget>[
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             'Category: ',
//                             style: TextStyle(color: red),
//                           ),
//                         ),
//                         DropdownButton(
//                           items: categoriesDropDown,
//                           onChanged: changeSelectedCategory,
//                           value: _currentCategory,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             'Brand: ',
//                             style: TextStyle(color: red),
//                           ),
//                         ),
//                         DropdownButton(
//                           items: brandsDropDown,
//                           onChanged: changeSelectedBrand,
//                           value: _currentBrand,
//                         ),
//                       ],
//                     ),

// //
                    // Padding(
                    //   padding: const EdgeInsets.all(12.0),
                    //   child: TextFormField(
                    //     controller: quatityController,
                    //     keyboardType: TextInputType.number,
                    //     decoration: InputDecoration(
                    //       hintText: 'Quantity',
                    //     ),
                    //     validator: (value) {
                    //       if (value.isEmpty) {
                    //         return 'You must enter the product name';
                    //       }
                    //     },
                    //   ),
                    // ),

                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        onChanged: (value){
                          price = value;
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Price',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'You must enter the product name';
                          }
                        },
                      ),
                    ),
                    FlatButton(
                      color: red,
                      textColor: white,
                      child: Text('add product'),
                      onPressed: () {
                        uploadProduct();
                        _showToast();
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
        ),
      ),
    );
  }

 void uploadProduct() {
    var id = Uuid();
    String productId = id.v1();
    Firestore.instance.collection('restaurants').document(email).collection('Menu').document(email + 'Menu').collection('Categories').document(selectedCategory).collection(selectedCategory).document(productName).setData({
      'id': productId,
      'image': _image1,
      'name': productName,
      'price': price,
    });
  }

  void changeSelectedSize(String size) {
    if (selectedSizes.contains(size)) {
      setState(() {
        selectedSizes.remove(size);
      });
    } else {
      setState(() {
        selectedSizes.insert(0, size);
      });
    }
  }

  void _selectImage(Future<File> pickImage, int imageNumber) async {
    File tempImg = await pickImage;
    switch (imageNumber) {
      case 1:
        setState(() => _image1 = tempImg);
        break;
    }
  }

  Widget _displayChild1() {
    if (_image1 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
        child: new Icon(
          Icons.add,
          color: grey,
        ),
      );
    } else {
      return Image.file(
        _image1,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }

_showToast() {
    Widget toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
        ),
        child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
            Icon(Icons.check),
            SizedBox(
            width: 12.0,
            ),
            Text("Product is Added!"),
        ],
        ),
    );


    fToast.showToast(
        child: toast,
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(seconds: 2),
    );
}

  

}