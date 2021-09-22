import 'package:flutter/material.dart';

class SomethingWrongPage extends StatelessWidget {
  final String errorText;
  final String tryAgainText;
  final VoidCallback onTapRetry;

  const SomethingWrongPage(
      {Key? key,
      required this.errorText,
      required this.tryAgainText,
      required this.onTapRetry})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.error, color: Colors.red[900], size: 40),
        const SizedBox(height: 5),
        Text(errorText),
        ElevatedButton(
            onPressed: onTapRetry,
            child: Row(
                mainAxisSize: MainAxisSize.min, children: [Text(tryAgainText)]))
      ])
    ]);
  }
}
