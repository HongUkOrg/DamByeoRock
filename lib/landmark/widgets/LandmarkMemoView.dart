import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wall/landmark/LandmarkCubit.dart';
import 'package:wall/landmark/model/LandmarkModels.dart';
import 'package:wall/landmark/model/MemoModel.dart';
import 'package:wall/utils/Utils.dart';
import 'package:zoom_widget/zoom_widget.dart';

import 'LandmarkWidgets.dart';

class LandmarkMemoView extends StatelessWidget {
  const LandmarkMemoView({
    Key key,
    @required MemoViewType memoViewType,
    @required List<MemoModel> memoList,
  }) : _memoViewType = memoViewType, _memoList = memoList, super(key: key);

  final MemoViewType _memoViewType;
  final List<MemoModel> _memoList;

  @override
  Widget build(BuildContext context) {
    // MARK: - Properties
    final LandmarkCubitType cubit = BlocProvider.of<LandmarkCubit>(context);

    return BlocBuilder<LandmarkCubit, LandmarkState>(
      builder: (context, state) {
        if (state is LandmarkBeforeUpdated) {
          _memoList.add(MemoModel(memo: 'updating..', color: Colors.black, top: 1000, left: -500));
          return Container(
            child: Expanded(
              child: _memoViewType == MemoViewType.memo ? MemoCardView(_memoList) : MemoListView(_memoList),
            ),
          );
        }
        print("bleo: zoom height ${(DeviceHelper.screenHeight - DeviceHelper.safeAreaInsets.top - 180) * 3.0}");
        return Expanded(
          child: Zoom(
            zoomSensibility: 1.5,
            centerOnScale: false,
            opacityScrollBars: 0.2,
            width: DeviceHelper.screenWidth * 3.0,
            height: (DeviceHelper.screenHeight - DeviceHelper.safeAreaInsets.top - 180 - DeviceHelper.safeAreaInsets.bottom) * 3.0,
            onScaleUpdate: (scale, zoom) {
              cubit.scaleUpdated(scale);
            },
            onPositionUpdate: (offset) {
              cubit.offsetUpdated(offset);
            },
            child: _memoViewType == MemoViewType.memo ? MemoCardView(_memoList) : MemoListView(_memoList),
          ),
        );
      },
    );
  }
}