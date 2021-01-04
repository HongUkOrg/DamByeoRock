import 'package:flutter/material.dart';
import 'package:wall/utils/ColorExtensions.dart';

class MainMyRoomView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 26, horizontal: 20),
          child: SizedBox(
            width: 48,
            height: 48,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: DamColors.black20,
                    spreadRadius: 0,
                    blurRadius: 20,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ]
              ),
              child: Icon(
                Icons.house
              ),
            ),
          ),
        ),
      ),
    );
  }
}
