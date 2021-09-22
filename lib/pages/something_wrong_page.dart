import 'package:flutter/material.dart';
import 'package:nu_conta_marketplace/translates/translates.dart';

class SomethingWrongPage extends StatelessWidget {
  final String? errorText;
  final VoidCallback onTapRetry;

  const SomethingWrongPage({Key? key, this.errorText, required this.onTapRetry})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.error, color: Colors.red[900], size: 40),
        const SizedBox(height: 5),
        Text(errorText ?? Translates.of(context)!.errorSomethingWrong),
        ElevatedButton(
            onPressed: onTapRetry,
            child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [Text(Translates.of(context)!.tryAgain)]))
      ])
    ]);
  }
}
