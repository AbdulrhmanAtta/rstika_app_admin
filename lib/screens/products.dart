import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rstikaadminapp/screens/cartitem.dart';
import 'package:rstikaadminapp/screens/productsDetails.dart';
class ProductsList extends StatefulWidget {
  final String email;

  const ProductsList({Key key, this.email}) : super(key: key);

  @override
  _ProductsListState createState() => _ProductsListState(email);
}

class _ProductsListState extends State<ProductsList> {
  var selectedCategory;
  String email;
  _ProductsListState(this.email);

  Future getProducts() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('restaurants').document(email).collection('Menu').document(email + 'Menu').collection('Categories').document(selectedCategory).collection(selectedCategory).getDocuments();
    return qn.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        title: Text('Choose Category')
      ),
      body: Center(
        child: Padding(
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
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.category,
                                    size: 25.0, color: Colors.red),

                         SizedBox(width: 20,),
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
                            
                          ),
                          
                           Row(
                             children: [
                               Expanded(
                                                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(15.0,0,0,0),
                                  child: RaisedButton(
                                    color: Colors.red[400],
                                    onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetail(email: email, selectedCategory: selectedCategory,),));
                                  },
                                  child: Text('Select', style: TextStyle(color: Colors.white),),
                                  ),
                          ),
                               ),
                             ],
                           )
                        ],
                      );
                      
                    }
                }),
                  ),
      )
      
    );
  }
}