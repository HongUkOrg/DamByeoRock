import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wall/utils/Utils.dart';

class LandmarkRepository {
  LandmarkRepository();

  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<List<String>> fetchMemo({String landmarkName}) async {
    Logger.logD('fetch memo $landmarkName');

    List<String> memoList = [];
    await fireStore.collection('$landmarkName')
      .orderBy('date', descending: true)
      .limit(10)
      .get()
      .then((QuerySnapshot querySnapshot) => {
        querySnapshot.docs.forEach((element) {
          memoList.add(element.get('memo'));
        })
      });
    return memoList;
  }

  Future<bool> addMemo({String landmarkName, String memo}) async {
    bool result = true;
    await fireStore.collection(landmarkName)
        .add({'memo': memo, 'date': DateTime.now()})
        .catchError((error) {
          result = false;
          print("Failed to add memo: $error");
        });
    return result;
  }
}