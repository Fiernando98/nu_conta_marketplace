import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:nu_conta_marketplace/utilities/api_uris.dart';

void main() {
  const String _token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhd2Vzb21lY3VzdG9tZXJAZ21haWwuY29tIn0.cGT2KqtmT8KNIJhyww3T8fAzUsCD5_vxuHl5WbXtp8c";

  group("Requests from GraphQL", () {
    test("Get viewer data", () async {
      final Map<String, dynamic> _itemJSON = {
        "query": """ {
             viewer {
              id
              name
              balance
              offers {
               id
               price
               product {
                id
                name
                description
                image
               }
              }
             }
            }
            """
      };
      http.Response _response = await http.post(Uri.parse(ApiUris.query),
          body: json.encode(_itemJSON),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $_token'
          });

      expect(_response.statusCode, 200);
    });

    test("Simulate some buy", () async {
      const String idOffer = "offer/portal-gun";
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
          "purchaseOfferId": "$idOffer"
        }
        """
      };
      http.Response _response = await http.post(Uri.parse(ApiUris.query),
          body: json.encode(_itemJSON),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $_token'
          });

      final Map<String, dynamic> _jsonRequest =
          await json.decode(utf8.decode(_response.bodyBytes));

      expect(_jsonRequest["data"]?["purchase"]?["success"] == true, true);
    });
  });
}
