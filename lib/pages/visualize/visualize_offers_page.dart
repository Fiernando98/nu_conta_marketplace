import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nu_conta_marketplace/main.dart';
import 'package:nu_conta_marketplace/pages/something_wrong_page.dart';
import 'package:nu_conta_marketplace/pages/visualize/visualize_offer_page.dart';
import 'package:nu_conta_marketplace/translates/translates.dart';
import 'package:nu_conta_marketplace/utilities/api_uris.dart';
import 'package:nu_conta_marketplace/utilities/methods/public.dart';
import 'package:nu_conta_marketplace/utilities/special_widgets/offer_item.dart';
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
        hintTextStyle: const TextStyle(color: Colors.white),
        searchTextStyle: const TextStyle(color: Colors.white),
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

    if (_listFilter.isEmpty) {
      return Center(child: Text(Translates.of(context)!.noOffersAvailable));
    }

    _listFilter.removeWhere((final dynamic item) => ![
          item["product"]["name"].toString().toLowerCase()
        ].any((element) => element.contains(_searchQuery.toLowerCase())));

    return ListView.separated(
        itemBuilder: (_, index) => OfferItem(
            title: _listFilter[index]["product"]["name"],
            price: double.parse("${_listFilter[index]["price"]}"),
            imagePath: _listFilter[index]["product"]["image"],
            onTap: () async => _showOffer(_listFilter[index])),
        separatorBuilder: (_, index) =>
            const Divider(height: 0, thickness: 1, indent: 100),
        itemCount: _listFilter.length);
  }

  Widget? _bottomUserInformation() {
    if (_jsonRequest != null) {
      return Card(
          elevation: 10,
          margin: const EdgeInsets.all(0),
          child: Padding(
              padding: const EdgeInsets.all(5),
              child: Row(children: [
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                            "${_jsonRequest!["data"]!["viewer"]!["name"]}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)))),
                Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.green[800],
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                        "\$${_jsonRequest!["data"]!["viewer"]!["balance"]}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white)))
              ])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        body: _bodyPage(),
        bottomNavigationBar: _bottomUserInformation());
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
      _jsonRequest = null;
      _someError = true;
      setState(() {});
    }
  }

  Future<void> _showOffer(final Map<String, dynamic> offer) async {
    try {
      final double? newBalance = await Navigator.of(context).push(
          MaterialPageRoute(
              builder: (_) => VisualizeOfferPage(
                  offer: offer,
                  currentBalance: double.parse(
                      "${_jsonRequest!["data"]!["viewer"]!["balance"]}"))));

      if (newBalance != null) {
        setState(
            () => _jsonRequest!["data"]!["viewer"]!["balance"] = newBalance);
      }
    } catch (error) {
      PublicMethods.snackMessage(
          message: error.toString(), context: context, isError: true);
    }
  }
}
