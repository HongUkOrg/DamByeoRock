import 'package:flutter/material.dart';
import 'package:wall/utils/ColorExtensions.dart';

class MainHeaderView extends StatelessWidget {
  const MainHeaderView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 33,),
        Center(
          child: Text(
            '서대문구 신촌동',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: DamColors.charcoalGrey
            ),
          ),
        ),
      ],
    );
  }
}