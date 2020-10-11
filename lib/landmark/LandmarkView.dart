import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wall/landmark/LandmarkCubit.dart';
import 'package:wall/landmark/model/LandmarkModel.dart';
import 'package:wall/landmark/model/MemoModel.dart';
import 'package:wall/utils/Utils.dart';
import 'model/LandmarkModels.dart';
import 'widgets/LandmarkWidgets.dart';

class LandmarkView extends StatefulWidget {
  @override
  _LandmarkViewState createState() => _LandmarkViewState();
}

class _LandmarkViewState extends State<LandmarkView> {



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
                LandmarkHeaderView(landmarkName: cubit.landmarkModel.name),
                LandmarkMemoView(memoViewType: _memoViewType, memoList: _memoList),
                LandmarkInputView(textFormKey: textFormKey, textEditingController: _textEditingController)
              ],
            ),
          );
        },
      ),
    );
  }


  @override
  void deactivate() {
    final LandmarkCubitType cubit = BlocProvider.of<LandmarkCubit>(context);
    cubit.disconnectWithLandmark();
    super.deactivate();
  }
}