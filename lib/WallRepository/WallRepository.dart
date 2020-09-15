import 'package:cloud_firestore/cloud_firestore.dart';

class WallRepository {

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<void> add() {
    fireStore
        .collection('wall')
        .add({
          'test1': 1,
          'test2': true,
          'test3': '아아아아아 ABCD',
          'date': new DateTime.now(),
        })
        .then((value) => print('Wall Added'))
        .catchError((error) => print('Error: failed to add... $error'));
  }
}