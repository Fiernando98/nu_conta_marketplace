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
}
