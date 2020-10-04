import 'package:flutter/material.dart';

class LandmarkInputView extends StatelessWidget {
  const LandmarkInputView({
    Key key,
    @required this.textFormKey,
    @required TextEditingController textEditingController,
  }) : _textEditingController = textEditingController, super(key: key);

  final GlobalKey<FormState> textFormKey;
  final TextEditingController _textEditingController;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}