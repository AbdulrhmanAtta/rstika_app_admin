import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rstikaadminapp/screens/cartitem.dart';
import 'package:rstikaadminapp/screens/update_produxt.dart';
import 'package:uuid/uuid.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductDetail extends StatefulWidget {
  final String email;
  var selectedCategory;
  ProductDetail({Key key, this.email, this.selectedCategory}) : super(key: key);

  @override
  _ProductsDetailState createState() => _ProductsDetailState(email, selectedCategory);
}

class _ProductsDetailState extends State<ProductDetail> {
  var selectedCategory;
  String email;
  FToast fToast;
  _ProductsDetailState(this.email, this.selectedCategory);

   void deleteProduct(productName) {
    var id = Uuid();
    String productId = id.v1();
    Firestore.instance.collection('restaurants').document(email).collection('Menu').document(email + 'Menu').collection('Categories').document(selectedCategory).collection(selectedCategory).document(productName).delete();
    }

  Future getProducts() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('restaurants').document(email).collection('Menu').document(email + 'Menu').collection('Categories').document(selectedCategory).collection(selectedCategory).getDocuments();
    return qn.documents;
  }

  _deleteToast() {
    Widget toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.redAccent,
        ),
        child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
            Icon(Icons.check),
            SizedBox(
            width: 12.0,
            ),
            Text("Product is Deleted!"),
        ],
        ),
    );


    fToast.showToast(
        child: toast,
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(seconds: 2),
    );
}
 
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast(context);
    print(selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        title: Text('Products List'),
      ),
      body: FutureBuilder(
        future: getProducts(),
        builder: (context, snapshot) {

          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: Text(
              'Loading....'
            ),);
          } else {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, index){
                return Padding(
                  padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0,0.0),
                  child: CartItem(
                    // img: snapshot.data[index].data['image'],
                    name: snapshot.data[index].data['name'],
                    price: snapshot.data[index].data['price'],
                    removeIcon: (){deleteProduct(snapshot.data[index].data['name']); 
                    _deleteToast();
                    Navigator.pop(context);
                    },
                    ),
                );
              }),
            );
          }
      },),
    );
  }
}

