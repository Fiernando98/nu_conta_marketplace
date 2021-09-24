import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';

class DialogLoadingData extends StatefulWidget {
  final String text;
  final Function functionSync;
  final BuildContext dialogContext;

  const DialogLoadingData(
      {Key? key,
      required this.text,
      required this.functionSync,
      required this.dialogContext})
      : super(key: key);

  @override
  _DialogLoadingDataState createState() => _DialogLoadingDataState();
}

class _DialogLoadingDataState extends State<DialogLoadingData> {
  @override
  void initState() {
    _loadFunction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
        content:
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Text(widget.text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
      const SizedBox(
          height: 40,
          width: 40,
          child: Center(child: CupertinoActivityIndicator(radius: 15)))
    ]));
  }

  Future<void> _loadFunction() async {
    await Future.delayed(Duration.zero);
    try {
      await widget.functionSync();
    } catch (error) {
      throw error.toString();
    }
    if (Navigator.of(widget.dialogContext).canPop()) {
      Navigator.of(widget.dialogContext).pop();
    }
  }
}
