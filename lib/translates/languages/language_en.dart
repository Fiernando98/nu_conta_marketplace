import 'package:nu_conta_marketplace/translates/translates.dart';

class LanguageEn extends Translates {
  final String _code;

  LanguageEn(this._code);

  @override
  String get codeLanguage => _code;

  @override
  String get welcome => "Welcome";

  @override
  String get weCouldNotConnectToTheServer =>
      "We could not connect to the server";

  @override
  String get errorSomethingWrong => "Oops! Something went wrong";

  @override
  String get tryAgain => "Try again";

  @override
  String get search => "Search";

  @override
  String get offers => "Offers";

  @override
  String get noOffersAvailable => "No offers available";

  @override
  String get checkThisOffer => "Check this offer!";

  @override
  String get price => "Price";

  @override
  String get buy => "Buy";

  @override
  String get makingPurchase => "Making purchase";

  @override
  String get insufficientBalance => "Insufficient balance";

  @override
  String get successfulPurchase => "Successful purchase";
}
