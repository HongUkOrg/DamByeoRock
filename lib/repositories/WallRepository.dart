import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wall/landmark/model/LandmarkModel.dart';
import 'package:wall/utils/Utils.dart';

class WallRepository {

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Stream<Set<LandmarkModel>> fetchLandmark() {
    Stream<QuerySnapshot> stream = fireStore.collection('landmark').snapshots();
    return stream
        .map((querySnapshot) =>
          querySnapshot.docs.map((docs) =>
              LandmarkModel(
                  name: docs.get('name'),
                  latLng: LatLng(docs.get('lat'), docs.get('lng'))
              )
          ).toSet()
        )
        .handleError((error) => print('bleo: error!! $error'));
  }

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