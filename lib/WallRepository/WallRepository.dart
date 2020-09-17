import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wall/landmark/model/landmark.dart';

class WallRepository {

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<Set<LandmarkModel>> fetchLandmark() async {
    Set<LandmarkModel> landmarks = {};
    await fireStore.collection('landmark')
        .get()
        .then((QuerySnapshot querySnapshot) => {
          querySnapshot.docs.forEach((element) {
            print('value from firestore ${element.get('name')}');
            landmarks.add(LandmarkModel(element.get('name'), LatLng(element.get('lat'), element.get('lng'))));
          })
        });
    return landmarks;
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