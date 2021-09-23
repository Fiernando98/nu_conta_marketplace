import 'package:flutter/material.dart';

///This Iterable is using for specific what language support this app
Iterable<String> get languagesSupported => ['en', 'es'];

///This abstract class is using for specific all the words you want to translate
abstract class Translates {
  static Translates? of(BuildContext context) {
    return Localizations.of<Translates>(context, Translates);
  }

  String get codeLanguage;

  String get welcome;

  String get weCouldNotConnectToTheServer;

  String get errorSomethingWrong;

  String get tryAgain;

  String get search;

  String get offers;

  String get noOffersAvailable;
}
