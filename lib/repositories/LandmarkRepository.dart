import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:wall/landmark/model/MemoModel.dart';
import 'package:wall/utils/Utils.dart';

abstract class LandmarkRepositoryType {
  Stream<List<MemoModel>> fetchMemo({String landmarkName});
  Future<bool> addMemo({String landmarkName, MemoModel memoModel});
}

class LandmarkRepository implements LandmarkRepositoryType {
  LandmarkRepository();

  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Stream<List<MemoModel>> fetchMemo({String landmarkName}) {
    Logger.D('fetch memo $landmarkName');

    return fireStore.collection('$landmarkName')
      .orderBy('date', descending: true)
      .limit(100)
      .snapshots()
      .map((QuerySnapshot querySnapshot) {
        Logger.D('fetchfetchfetch $landmarkName');
        List<MemoModel> memoModelList = [];
        querySnapshot.docs.forEach((element) {
          final memoModel = MemoModel(
            memo: element.get('memo'),
            color: Color(element.get('color')),
            top: element.get('top'),
            left: element.get('left'),
          );
          memoModelList.insert(0, memoModel);
        });
        return memoModelList;
    });
  }

  Future<bool> addMemo({String landmarkName, MemoModel memoModel}) async {
    bool result = true;
    await fireStore.collection(landmarkName)
        .add({'memo': memoModel.memo, 'date': DateTime.now(), 'color': memoModel.color.value, 'top': memoModel.top, 'left' : memoModel.left})
        .catchError((error) {
          result = false;
          print("Failed to add memo: $error");
        });
    return result;
  }
}