const bool workOnDevelop = false;

abstract class ApiUris {
  static String get endPoint =>
      "https://staging-nu-needful-things.nubank.com.br/";

  static String get query => "${endPoint}query/";
}
