import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rstikaadminapp/db/authServices.dart';
import 'package:rstikaadminapp/screens/add_product.dart';
import 'package:rstikaadminapp/screens/categories.dart';
import 'package:rstikaadminapp/screens/login.dart';
import 'package:rstikaadminapp/screens/orders.dart';
import 'package:rstikaadminapp/screens/products.dart';
import '../db/category.dart';
import '../db/brand.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Admin extends StatefulWidget {
  
  String email;
  Admin({Key key, this.email}) : super(key: key);

  @override
  _AdminState createState() => _AdminState(email);
}

class _AdminState extends State<Admin> {
  MaterialColor active = Colors.red;
  MaterialColor notActive = Colors.grey;
  String categoryController;
  TextEditingController brandController = TextEditingController();
  GlobalKey<FormState> _categoryFormKey = GlobalKey();
  Firestore _firestore = Firestore.instance;
  String email;
  _AdminState(this.email);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Admin Dashboard', style: TextStyle(color: Colors.black),),
          elevation: 0.0,
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: (){
                AuthService().signOut();
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(),));
              },
              icon: 
            Icon(
              Icons.exit_to_app),
              color: Colors.black,
            ),
          ],
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Add product"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddProduct(email: email,),));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.change_history),
              title: Text("Products list"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProductsList(email: email)));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add_circle),
              title: Text("Add category"),
              onTap: () {
                _categoryAlert();
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.category),
              title: Text("Category list"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CategoriesList(email: email)));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.library_books),
              title: Text("Orders"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Orders(email: email)));
              },
            ),
            Divider(),
          ],
        )
    );
  }


  void _categoryAlert() {
    var alert = new AlertDialog(
      content: Form(
        key: _categoryFormKey,
        child: TextFormField(
          onChanged: (value) {
            categoryController = value;
          },
          validator: (value){
            if(value.isEmpty){
              return 'category cannot be empty';
            }
          },
          decoration: InputDecoration(
            hintText: "add category"
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(onPressed: (){
          if(categoryController != null){
            _firestore.collection('restaurants').document(email).collection('Menu').document(email + "Menu").collection('Categories').document(categoryController).setData({'name': categoryController});
          }
          Fluttertoast.showToast(msg: 'category created');
          Navigator.pop(context);
        }, child: Text('ADD')),
        FlatButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text('CANCEL')),

      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }

 }