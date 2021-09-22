import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nu_conta_marketplace/main.dart';
import 'package:nu_conta_marketplace/translates/translates.dart';
import 'package:nu_conta_marketplace/utilities/api_uris.dart';
import 'package:nu_conta_marketplace/utilities/methods/public.dart';

class VisualizeDataPage extends StatefulWidget {
  const VisualizeDataPage({Key? key}) : super(key: key);

  @override
  _VisualizeDataPageState createState() => _VisualizeDataPageState();
}

class _VisualizeDataPageState extends State<VisualizeDataPage> {
  bool _someError = false;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  AppBar _appBar() {
    return AppBar(title: Text(Translates.of(context)!.welcome));
  }

  Widget _bodyPage() {
    if (_someError) {
      return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.error, color: Colors.red[900]),
          const SizedBox(height: 10),
          Text("Errorrrrrrr")
        ])
      ]);
    }
    return const Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: _bodyPage());
  }

  Future<void> _loadData() async {
    await Future.delayed(Duration.zero);
    try {
      http.Response _response = await http
          .get(Uri.parse(ApiUris.query), headers: {
        "Content-Type": "application/json",
        "Accept-Language": Translates.of(context)!.codeLanguage,
        'Authorization': 'bearer $token'
      }).timeout(const Duration(seconds: 30),
              onTimeout: () =>
                  throw Translates.of(context)!.weCouldNotConnectToTheServer);

      if (_response.statusCode == 200) {
        PublicMethods.snackMessage(message: ":D", context: context);
      } else {
        throw await json.decode(utf8.decode(_response.bodyBytes));
      }
      PublicMethods.snackMessage(
          message: "${_response.statusCode}", context: context);
    } catch (error) {
      PublicMethods.snackMessage(
          message: error.toString(), context: context, isError: true);
      setState(() => _someError = true);
    }
  }
}
