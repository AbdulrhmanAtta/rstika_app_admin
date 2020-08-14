import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rstikaadminapp/screens/cartitem.dart';
import 'package:rstikaadminapp/screens/categoriesItem.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rstikaadminapp/screens/categories.dart';


class CategoriesList extends StatefulWidget {

   final String email;
  const CategoriesList({Key key, this.email}) : super(key: key);

  @override
  _CategoriesListState createState() => _CategoriesListState(email);
}

class _CategoriesListState extends State<CategoriesList> {
  String email;
  _CategoriesListState(this.email);
   String categoryController;
   GlobalKey<FormState> _categoryFormKey = GlobalKey();
  Firestore _firestore = Firestore.instance;
  FToast fToast;
  @override
  void initState() {
    // _getCategories();
    // _currentCategory = categoriesDropDown[0].value;
    fToast = FToast(context);

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
            Text("Category is Added!"),
        ],
        ),
    );


    fToast.showToast(
        child: toast,
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(seconds: 2),
    );
}

   Future getCategories() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('restaurants').document(email).collection('Menu').document(email + 'Menu').collection('Categories').getDocuments();
    print(qn.documents);
    return qn.documents;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.red[400],
        title: Text('Categories List'), 
      ),

      body: FutureBuilder(
        future: getCategories(),
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
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 2.0, 8.0),
                  child: CategoriesItem(
                    img: 'assets/table.jpg',
                    name: snapshot.data[index].data['name'],
                    removeIcon: (){_categoryAlert();},
                    ),
                );
              }),
            );
          }
        
      },),
      
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
            _firestore.collection('restaurants').document(email).collection('Menu').document(email + "Menu").collection('Categories').document(categoryController).updateData({'name': categoryController});
          }
          _showToast();
          Navigator.pop(context);
        }, child: Text('UPDATE')),
        FlatButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text('CANCEL')),

      ],
    );
    showDialog(context: context, builder: (_) => alert);
  }
}