import 'package:flutter/material.dart';

abstract class FullWidthButton extends StatelessWidget {

  final double _width = double.infinity;

  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  Widget get _label => Text(text.toUpperCase());
  Widget get _progress;
  Widget get _button;

  FullWidthButton({ key, this.text, this.onPressed, this.isLoading }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width,
      child: _button,
    );
  }

}

class FullWidthRaisedButton extends FullWidthButton {

  @override
  Widget get _progress => SizedBox(
    height: 24,
    width: 24,
    child: CircularProgressIndicator(
      backgroundColor: Colors.white,
    ),
  );

  @override
  Widget get _button => RaisedButton(
    onPressed: onPressed,
    child: isLoading? _progress : _label,
  );

  FullWidthRaisedButton({ key, text, onPressed, isLoading = false }):
        super(key: key, text: text, onPressed: onPressed, isLoading: isLoading);

}

class FullWidthFlatButton extends FullWidthButton {

  @override
  Widget get _progress => SizedBox(
    height: 24,
    width: 24,
    child: CircularProgressIndicator(),
  );

  @override
  Widget get _button => FlatButton(
    onPressed: onPressed,
    child: isLoading? _progress : _label,
  );

  FullWidthFlatButton({ key, text, onPressed, isLoading = false }):
        super(key: key, text: text, onPressed: onPressed, isLoading: isLoading);

}