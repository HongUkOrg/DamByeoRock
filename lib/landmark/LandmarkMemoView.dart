import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wall/landmark/LandmarkCubit.dart';
import 'package:wall/landmark/model/LandmarkModel.dart';
import 'package:wall/landmark/model/MemoModel.dart';
import 'package:wall/utils/Utils.dart';
import 'widgets/MemoWidgets.dart';

class LandmarkMemoView extends StatefulWidget {

  LandmarkMemoView(this.landmarkModel);

  // MARK: - Properties
  final LandmarkModel landmarkModel;

  @override
  _LandmarkMemoViewState createState() => _LandmarkMemoViewState();
}

class _LandmarkMemoViewState extends State<LandmarkMemoView> {

  @override
  Widget build(BuildContext context) {

    // MARK: - Properties
    final LandmarkCubitType cubit = BlocProvider.of<LandmarkCubit>(context);
    final GlobalKey<FormState> textFormKey = GlobalKey<FormState>(debugLabel: 'hi');
    final TextEditingController _textEditingController = TextEditingController();

    // Mark: - Dynamic Properties
    List<MemoModel> _memoList = [];
    var _memoViewType = MemoViewType.memo;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.note),
        onPressed: () {
          if (textFormKey.currentState.validate()){
            cubit.addMemo(text: _textEditingController.text);
            FocusScope.of(context).requestFocus(FocusNode());
            _textEditingController.clear();
          }
        },
      ),
      body: BlocConsumer<LandmarkCubit, LandmarkState>(
        listener: (context, state) {
          if (state is LandmarkUpdated) {
            Logger.D('${this.toString()} LandmarkUpdated');
            _memoList = state.memoList;
          }
          if (state is LandmarkMemoViewTypeUpdated) {
            _memoViewType = state.memoViewType;
          }
        },
        builder: (context, state) {
          if (state is LandmarkInitial) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          return SafeArea(
            child: Column(
              children: [
                SizedBox(height: 20),
                Container(
                  height: 100,
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Center(
                        child: Text(
                          '${widget.landmarkModel.name} 담벼락',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.lightGreen,
                          ),
                        ),
                      ),
                      Expanded(child: Container(),),
                      IconButton(
                        icon: Icon(Icons.list, color: Colors.black45,),
                        onPressed: () {
                          cubit.tapListModeButton();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.note_add, color: Colors.black45,),
                        onPressed: () {
                          cubit.tapMemoModeButton();
                        },
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: _memoViewType == MemoViewType.memo ? MemoCardView(_memoList) : MemoListView(_memoList),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 80),
                  height: 60,
                  child: Form(
                    key: textFormKey,
                    autovalidate: true,
                    child: TextFormField(
                      controller: _textEditingController,
                      validator: (text) {
                        return text.trim().isEmpty ?
                        '메모를 입력해주세요' : null;
                      },
                      decoration: InputDecoration(
                        hintText: '글 남기기',
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
