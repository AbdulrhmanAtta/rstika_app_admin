import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rstikaadminapp/screens/cartitem.dart';
import 'package:rstikaadminapp/screens/orderItem.dart';
import 'package:rstikaadminapp/screens/update_produxt.dart';
import 'package:uuid/uuid.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Orders extends StatefulWidget {
  final String email;
  
  Orders({Key key, this.email}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState(email);
}

class _OrdersState extends State<Orders> {
  String email;
  FToast fToast;
  _OrdersState(this.email);

  //  void deleteProduct(productName) {
  //   var id = Uuid();
  //   String productId = id.v1();
  //   Firestore.instance.collection('restaurants').document(email).collection('Menu').document(email + 'Menu').collection('Categories').document(selectedCategory).collection(selectedCategory).document(productName).delete();
  //   }

  Future getOrders() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('restaurants').document(email).collection('Orders').document(email + 'Orders').collection('Orders').getDocuments();
    print(qn.documents);
    return qn.documents;
  }

 
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        title: Text('Orders List'),
      ),
      body: FutureBuilder(
        future: getOrders(),
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
                return OrderItem(
                  img: "assets/orders2.png",
                  name: snapshot.data[index].data['number of People'],
                  date: snapshot.data[index].data['date'].toDate(),
                  price: snapshot.data[index].data['totalPrice'],
                  );
              }),
            );
          }
      },),
    );
  }
}

