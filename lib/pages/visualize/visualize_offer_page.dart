import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nu_conta_marketplace/dialogs/dialog_loading_data.dart';
import 'package:nu_conta_marketplace/main.dart';
import 'package:nu_conta_marketplace/pages/visualize/visualize_single_image_page.dart';
import 'package:nu_conta_marketplace/translates/translates.dart';
import 'package:nu_conta_marketplace/utilities/api_uris.dart';
import 'package:nu_conta_marketplace/utilities/methods/public.dart';
import 'package:nu_conta_marketplace/utilities/special_widgets/image_load_network.dart';

class VisualizeOfferPage extends StatefulWidget {
  final Map<String, dynamic> offer;
  final double currentBalance;

  const VisualizeOfferPage(
      {Key? key, required this.offer, required this.currentBalance})
      : super(key: key);

  @override
  _VisualizeOfferPageState createState() => _VisualizeOfferPageState();
}

class _VisualizeOfferPageState extends State<VisualizeOfferPage> {
  AppBar _appBar() {
    return AppBar(title: Text(Translates.of(context)!.checkThisOffer));
  }

  Widget _bodyPage() {
    return ListView(padding: const EdgeInsets.only(bottom: 70), children: [
      Padding(
          padding: const EdgeInsets.all(10),
          child: Text(widget.offer["product"]["name"],
              style:
                  const TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
      AspectRatio(
          aspectRatio: 4 / 3,
          child: InkWell(
              onTap: (widget.offer["product"]["image"] != null)
                  ? () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => VisualizeSingleImagePage(
                          imagePath: widget.offer["product"]["image"])))
                  : null,
              child: ImageLoadNetwork(
                  imagePath: widget.offer["product"]["image"]))),
      Padding(
          padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
          child: Text(
              "${Translates.of(context)!.price}: \$${widget.offer["price"]}",
              style: const TextStyle(fontSize: 18))),
      Padding(
          padding: const EdgeInsets.all(10),
          child: Text(widget.offer["product"]?["description"],
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 13)))
    ]);
  }

  FloatingActionButton _fabBuy() {
    return FloatingActionButton.extended(
        onPressed: _buyItem,
        label: Text(Translates.of(context)!.buy),
        icon: const Icon(Icons.shopping_cart));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(), body: _bodyPage(), floatingActionButton: _fabBuy());
  }

  Future<void> _buyItem() async {
    try {
      if (widget.currentBalance < double.parse("${widget.offer["price"]}")) {
        throw Translates.of(context)!.insufficientBalance;
      }
      await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => DialogLoadingData(
              text: Translates.of(context)!.makingPurchase,
              dialogContext: _,
              functionSync: () async {
                try {
                  final Map<String, dynamic> _itemJSON = {
                    "query": """
                        mutation PurchaseMutationRoot(\$purchaseOfferId: ID!) {
                         purchase(offerId: \$purchaseOfferId) {
                          success,
                          errorMessage,
                          customer {
                           balance
                          }
                         }
                        }
                        """,
                    "variables": """ {
                     "purchaseOfferId": "${widget.offer["id"]}"
                    }
                    """
                  };
                  http.Response _response = await http.post(
                      Uri.parse(ApiUris.query),
                      body: json.encode(_itemJSON),
                      headers: {
                        "Content-Type": "application/json",
                        "Accept-Language": Translates.of(context)!.codeLanguage,
                        'Authorization': 'Bearer $token'
                      }).timeout(const Duration(seconds: 30),
                      onTimeout: () => throw Translates.of(context)!
                          .weCouldNotConnectToTheServer);

                  if (_response.statusCode == 200) {
                    final Map<String, dynamic> _jsonRequest =
                        await json.decode(utf8.decode(_response.bodyBytes));
                    if (_jsonRequest["data"]?["purchase"]?["success"] == true) {
                      PublicMethods.snackMessage(
                          message: Translates.of(context)!.successfulPurchase,
                          context: context);
                      Navigator.of(_).pop();
                      Navigator.of(context).pop(widget.currentBalance -
                          double.parse("${widget.offer["price"]}"));
                    } else {
                      throw _jsonRequest["data"]?["purchase"]?["errorMessage"];
                    }
                  } else {
                    throw await json.decode(utf8.decode(_response.bodyBytes));
                  }
                } catch (error) {
                  PublicMethods.snackMessage(
                      message: error.toString(),
                      context: context,
                      isError: true);
                }
              }));
    } catch (error) {
      PublicMethods.snackMessage(
          message: error.toString(), context: context, isError: true);
    }
  }
}
