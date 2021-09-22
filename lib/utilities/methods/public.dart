import 'package:flutter/material.dart';

abstract class PublicMethods {
  ///In this function you print a lot of text using multiple prints
  static void superPrint(dynamic text) {
    final RegExp pattern = RegExp('.{1,800}');
    pattern
        .allMatches(text.toString())
        .forEach((match) => debugPrint(match.group(0)));
  }

  ///In this function you draw a snackbar just send the text and a bool
  ///if is a error message
  static void snackMessage(
      {required final String message,
      required final BuildContext context,
      final bool isError = false}) {
    try {
      final SnackBar snackBar = SnackBar(
          duration: Duration(seconds: (isError) ? 4 : 2),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          behavior: SnackBarBehavior.floating,
          backgroundColor: (isError) ? Colors.red[700] : Colors.green[700],
          content: Row(children: [
            Icon((isError) ? Icons.error : Icons.done,
                size: 30, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
                child: Text(message,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)))
          ]));
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (error) {
      throw error.toString();
    }
  }

/*///In this function you can get the error inside the json response
  static Future<String> getErrorFromServer(
      {required final http.Response response,
      required final BuildContext context}) async {
    try {
      if (response.statusCode == 404) {
        return "${Translates.of(context)!.dataNotFound} (${response.statusCode})";
      }
      if (response.statusCode >= 500 && response.statusCode < 600) {
        return "${Translates.of(context)!.internalServerError} (${response.statusCode})";
      }
      var errorJSON = await json.decode(utf8.decode(response.bodyBytes));
      switch (errorJSON.runtimeType.toString()) {
        case "_InternalLinkedHashMap<String, dynamic>":
          if ((errorJSON as Map<String, dynamic>).containsKey("detail")) {
            return "${errorJSON['detail']} Error: ${response.statusCode}";
          }
          return "${_getListServerErrors(errorJSON)}Error: ${response.statusCode}";
        case "List<dynamic>":
          List<dynamic> _errorsList =
              await json.decode(utf8.decode(response.bodyBytes));
          return "${_errorsList.join('\n')} Error: ${response.statusCode}";
        case "JSArray<dynamic>":
          List<dynamic> _errorsList =
              await json.decode(utf8.decode(response.bodyBytes));
          return "${_errorsList.join('\n')} Error: ${response.statusCode}";
        default:
          return "${(errorJSON).toString()} Error: ${response.statusCode}";
      }
    } catch (error) {
      return error.toString();
    }
  }

  ///This function is just for foreach the data in the error list
  static String _getListServerErrors(final Map<String, dynamic> errors) {
    try {
      String error = "";
      for (var key in errors.keys) {
        error += "$key: ${errors[key]}\n";
      }
      return error;
    } catch (error) {
      throw error.toString();
    }
  }

  ///In this function you can call a bottomsheet for confirm the close action
  static Future<bool> bottomSheetCloseWindow(final BuildContext context) async {
    return (await showModalBottomSheet(
            context: context,
            elevation: 10,
            backgroundColor: Colors.transparent,
            enableDrag: true,
            isDismissible: false,
            builder: (context) => BottomSheetSelectSingleOption(
                    title: Translates.of(context)!.questionClosePage,
                    listItems: [
                      BottomSheetItems(
                          title: Translates.of(context)!.close,
                          icon: Icons.exit_to_app)
                    ])) ==
        0);
  }

  static String userTypeName(
      {required final UserTypeEnum userType,
      required final BuildContext context}) {
    switch (userType) {
      case UserTypeEnum.composer:
        return Translates.of(context)!.composer;
      case UserTypeEnum.interested:
        return Translates.of(context)!.interested;
      case UserTypeEnum.services:
        return Translates.of(context)!.services;
    }
  }

  static String assetTypeName({required final UserTypeEnum userType}) {
    switch (userType) {
      case UserTypeEnum.composer:
        return AssetsApp.pearsonGuitar;
      case UserTypeEnum.interested:
        return AssetsApp.concert;
      case UserTypeEnum.services:
        return AssetsApp.pearsonHeadphones;
    }
  }*/
}
