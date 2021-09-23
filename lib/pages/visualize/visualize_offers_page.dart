import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nu_conta_marketplace/main.dart';
import 'package:nu_conta_marketplace/pages/something_wrong_page.dart';
import 'package:nu_conta_marketplace/translates/translates.dart';
import 'package:nu_conta_marketplace/utilities/api_uris.dart';
import 'package:nu_conta_marketplace/utilities/methods/public.dart';
import 'package:nu_conta_marketplace/utilities/special_widgets/search_appbar.dart';

class VisualizeOffersPage extends StatefulWidget {
  const VisualizeOffersPage({Key? key}) : super(key: key);

  @override
  _VisualizeOffersPageState createState() => _VisualizeOffersPageState();
}

class _VisualizeOffersPageState extends State<VisualizeOffersPage> {
  Map<String, dynamic>? _jsonRequest;
  bool _someError = false;
  String _searchQuery = "";

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  AppBar _appBar() {
    return SearchAppBar(
        title: Text(Translates.of(context)!.offers),
        searchText: Translates.of(context)!.search,
        onTextChange: (newText) {
          setState(() => _searchQuery = newText);
        });
  }

  Widget _bodyPage() {
    if (_someError) {
      return SomethingWrongPage(
          errorText: Translates.of(context)!.errorSomethingWrong,
          tryAgainText: Translates.of(context)!.tryAgain,
          onTapRetry: _loadData);
    }

    if (_jsonRequest == null) {
      return const Center(child: CircularProgressIndicator());
    }

    List<dynamic> _listFilter =
        (_jsonRequest!["data"]!["viewer"]!["offers"]! as List<dynamic>)
            .toList();

    if (_searchQuery.isEmpty) {
      return Center(child: Text(Translates.of(context)!.noOffersAvailable));
    }

    _listFilter.removeWhere((final dynamic item) => ![
          item["product"]["name"].toString().toLowerCase()
        ].any((element) => element.contains(_searchQuery.toLowerCase())));

    return ListView.separated(
        itemBuilder: (_, index) =>
            ListTile(title: Text(_listFilter[index]["product"]["name"])),
        separatorBuilder: (_, index) => const Divider(height: 0, thickness: 1),
        itemCount: _listFilter.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: _bodyPage());
  }

  Future<void> _loadData() async {
    await Future.delayed(Duration.zero);
    setState(() => _someError = false);
    try {
      final Map<String, dynamic> _itemJSON = {
        "query":
            " { viewer { id name balance offers { id price product { id name description image } } } }"
      };
      http.Response _response = await http.post(Uri.parse(ApiUris.query),
          body: json.encode(_itemJSON),
          headers: {
            "Content-Type": "application/json",
            "Accept-Language": Translates.of(context)!.codeLanguage,
            'Authorization': 'Bearer $token'
          }).timeout(const Duration(seconds: 30),
          onTimeout: () =>
              throw Translates.of(context)!.weCouldNotConnectToTheServer);

      if (_response.statusCode == 200) {
        _jsonRequest = await json.decode(utf8.decode(_response.bodyBytes));
        setState(() {});
      } else {
        throw await json.decode(utf8.decode(_response.bodyBytes));
      }
    } catch (error) {
      PublicMethods.snackMessage(
          message: error.toString(), context: context, isError: true);
      setState(() => _someError = true);
    }
  }
}
