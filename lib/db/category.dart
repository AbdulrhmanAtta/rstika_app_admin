import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CategoryService {
  Firestore _firestore = Firestore.instance;
  String ref = 'Categories';

  void createCategory(String name) {
    var id = Uuid();
    String categoryId = id.v1();

    _firestore.collection('restaurants').document('8lzn6doxxePJrP0AqxJK').collection('Menu').document('9wRH1jBiqa6TkMkSu1VE').collection(ref).document(name).setData({});
  }

  Future<List<DocumentSnapshot>> getCategories() =>
      _firestore.collection('restaurants').document('8lzn6doxxePJrP0AqxJK').collection('Menu').document('9wRH1jBiqa6TkMkSu1VE').collection(ref).getDocuments().then((snaps) {
        print(snaps.documents.length);
        return snaps.documents;
      });


  Future<List<DocumentSnapshot>> getSuggestions(String suggestion) =>
      _firestore.collection('restaurants').document('8lzn6doxxePJrP0AqxJK').collection('Menu').document('9wRH1jBiqa6TkMkSu1VE').collection(ref).where('category', isEqualTo: suggestion).getDocuments().then((snap){
        return snap.documents;
      });

}