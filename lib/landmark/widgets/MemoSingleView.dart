import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wall/landmark/model/MemoModel.dart';
import 'package:wall/utils/Utils.dart';

import '../LandmarkCubit.dart';

class MemoSingleView extends StatefulWidget {

  final MemoModel _memoModel;
  final _enableBorder;

  const MemoSingleView(this._memoModel, this._enableBorder);

  @override
  _MemoSingleViewState createState() => _MemoSingleViewState(Offset(_memoModel.left, _memoModel.top));
}

class _MemoSingleViewState extends State<MemoSingleView> {

  final _width = 130.0;
  final _height = 130.0;
  Offset _offset;
  bool _dismissed = false;

  _MemoSingleViewState(this._offset);

  @override
  Widget build(BuildContext context) {
    final LandmarkCubitType cubit = BlocProvider.of<LandmarkCubit>(context);

    if (_dismissed) {
      return Container();
    }
    return BlocBuilder<LandmarkCubit, LandmarkState>(
      builder: (context, state) {
        print("bleo state changed ${state.runtimeType}, ${state.scale} ");
        return Positioned(
          left: _offset.dx,
          top: _offset.dy,
          child: Draggable(
            onDraggableCanceled: (velocity, offset) {
              setState(() {
                // SizedBox.height = 20 + LandmarkHeaderView.height = 100
                print("bleo: offset ${offset}");
                _offset = Offset(
                    offset.dx / state.scale + state.offset.dx,
                    (offset.dy - (DeviceHelper.safeAreaInsets.top + 120)) / state.scale + state.offset.dy
                );
                // if (velocity.pixelsPerSecond.dx.abs() > 1000 ) _dismissed = true;
              });
            },
            childWhenDragging: Container(),
            feedback: MemoSingleContentsView(width: _width, height: _height, memoModel: widget._memoModel, scale: 1.0, enableBorder: widget._enableBorder),
            child: MemoSingleContentsView(width: _width, height: _height, memoModel: widget._memoModel, scale: 1.0, enableBorder: widget._enableBorder),
          ),
        );
      },
    );
  }
}

class MemoSingleContentsView extends StatelessWidget {
  const MemoSingleContentsView({
    Key key,
    @required double width,
    @required double height,
    @required MemoModel memoModel,
    double scale,
    bool enableBorder = false
  }) : _width = width, _height = height, _memoModel = memoModel, _scale = scale, _enableBorder = enableBorder, super(key: key);

  final double _width;
  final double _height;
  final MemoModel _memoModel;
  final bool _enableBorder;
  final double _scale;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: _scale,
      child: Container(
        width: _width,
        height: _height,
        decoration: _enableBorder ? BoxDecoration(color: Colors.blueAccent) : null,
        child: Card(
          color: _memoModel.color,
          child: Center(
            child: Text(_memoModel.memo,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.black87
              ),
            ),
          ),
        ),
      ),
    );
  }
}
