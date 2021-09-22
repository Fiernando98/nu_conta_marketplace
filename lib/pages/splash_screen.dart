import 'package:flutter/material.dart';
import 'package:nu_conta_marketplace/pages/visualize/visualize_data_page.dart';
import 'package:nu_conta_marketplace/translates/translates.dart';
import 'package:nu_conta_marketplace/utilities/methods/public.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _loadData();
    super.initState();
  }

  Widget _bodyPage() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(Translates.of(context)!.welcome),
        const SizedBox(height: 15),
        const CircularProgressIndicator()
      ])
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: _bodyPage()));
  }

  Future<void> _loadData() async {
    await Future.delayed(Duration.zero);
    try {
      ///Do something
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const VisualizeDataPage()),
          (Route<dynamic> route) => false);
    } catch (error) {
      PublicMethods.snackMessage(
          message: error.toString(), context: context, isError: true);
    }
  }
}
