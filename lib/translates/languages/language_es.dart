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

  @override
  String get search => "Buscar";

  @override
  String get offers => "Ofertas";

  @override
  String get noOffersAvailable => "No hay ofertas disponibles";

  @override
  String get checkThisOffer => "¡Mira esta oferta!";

  @override
  String get price => "Precio";

  @override
  String get buy => "Comprar";

  @override
  String get makingPurchase => "Realizando compra";
}
