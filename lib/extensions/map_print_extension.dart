extension MapPrintExtension on Map {
  String print() {
    String openBracket = "\n{\n";
    String closeBracket = "{";
    String data = "";
    for (var element in entries) {
      data += "${element.key} : ${element.value}\n";
    }

    return "$openBracket$data $closeBracket";
  }
}
