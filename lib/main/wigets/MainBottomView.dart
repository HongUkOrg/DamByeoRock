import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wall/utils/ColorExtensions.dart';
import 'package:wall/utils/Utils.dart';

import '../MainCubit.dart';


class MainBottomView extends StatefulWidget {
  @override
  _MainBottomViewState createState() => _MainBottomViewState();
}

class _MainBottomViewState extends State<MainBottomView> {

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<MainCubit>(context);

    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {

      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => _navigateToLandmark(),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: DeviceHelper.screenWidth,
              height: 141,
              child: Container(
                  child: PageView(
                    children: getLandmark(),
                    controller: PageController(
                      viewportFraction: 0.8426,
                      initialPage: 0,
                    ),
                    onPageChanged: (page) {
                      cubit.landmarkChanged(page);
                    },
                  )
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _navigateToLandmark() async {
    final cubit = BlocProvider.of<MainCubit>(context);
    Navigator.pushNamed(context, '/landmark', arguments: cubit.currentLandmarkModel);
  }

  List<Widget> getLandmark() {
    final cubit = BlocProvider.of<MainCubit>(context);
    return cubit.landmarks
      .map((landmarkModel) {
        return SizedBox(
          width: 316,
          height: 141,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            color: Colors.white,
            child: Row(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(top: 21, left: 12),
                    child: Container(
                        width: 78,
                        height: 78,
                        child: Image.asset('assets/icGost.png'))
                ),
                Container(
                  padding: EdgeInsets.only(top: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          '${landmarkModel.name}',
                          style: const TextStyle(
                              color:  Colors.black,
                              fontWeight: FontWeight.w700,
                              fontFamily: "NotoSansKR",
                              fontStyle:  FontStyle.normal,
                              fontSize: 16.0
                          ),
                          textAlign: TextAlign.left
                      ),
                      SizedBox(height: 6,),
                      Row(
                        children: [
                          Text(
                              "300m",
                              style: const TextStyle(
                                  color:  Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Roboto",
                                  fontStyle:  FontStyle.normal,
                                  fontSize: 14.0
                              ),
                              textAlign: TextAlign.left
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 4, right: 4),
                            child: Opacity(
                              opacity : 0.4000000059604645,
                              child:   Container(
                                  width: 1,
                                  height: 12,
                                  decoration: BoxDecoration(
                                      color: Colors.black
                                  )
                              ),
                            ),
                          ),
                          Text(
                              "서울 서대문구 성산로 ",
                              style: const TextStyle(
                                  color:  Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "NotoSansKR",
                                  fontStyle:  FontStyle.normal,
                                  fontSize: 14.0
                              ),
                              textAlign: TextAlign.left
                          ),
                        ],
                      ),
                      SizedBox(height: 16,),
                      Container(
                          width: 178,
                          height: 38,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12)),
                              color: DamColors.lightPeriwinkle
                          ),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 12),
                          child: Text(
                              "나도 빼빼로 받고 싶다😭",
                              style: const TextStyle(
                                  color:  Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "NotoSansKR",
                                  fontStyle:  FontStyle.normal,
                                  fontSize: 14.0
                              ),
                              textAlign: TextAlign.left
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
    }).toList();
  }
}