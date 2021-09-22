import 'package:nu_conta_marketplace/translates/translates.dart';

class LanguageEs extends Translates {
  final String _code;

  LanguageEs(this._code);

  @override
  String get codeLanguage => _code;

  @override
  String get welcome => "Bienvenido";

  @override
  String get weCouldNotConnectToTheServer =>
      "No pudimos conectarnos con el servidor";

  @override
  String get errorSomethingWrong => "Ups! Algo salió mal";

  @override
  String get tryAgain => "Intentar otra vez";
}
