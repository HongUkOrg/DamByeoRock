import 'package:flutter/material.dart';

class MainHeaderView extends StatelessWidget {
  const MainHeaderView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(25),
      ),
      height: 50,
      child: Center(
        child: Text(
          '담벼락 세계에 오신걸 환영합니다!',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.lightGreen
          ),
        ),
      ),
    );
  }
}