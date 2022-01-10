/// Register more extension for String
extension StringParse on String {
  /// Remove special symbols in String
  String get removeSymbols {
    return replaceAll(RegExp(r'[^\w\s]+'), '');
  }

  /// Remove special character
  String get normalize {
    String specialChar = 'ÀÁÂÃÄÅẤàáâãäåấÒÓÔÕÕÖØòóôõöøÈÉÊËẾèéêëðếÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    String withoutSpecialChar = 'AAAAAAAaaaaaaaOOOOOOOooooooEEEEEeeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';
    String str = this;
    for (int i = 0; i < specialChar.length; i++) {
      str = str.replaceAll(specialChar[i], withoutSpecialChar[i]);
    }
    return str;
  }
}

extension CapExtension on String {
  String get inCaps => isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';

  String get allInCaps => toUpperCase();

  String get capitalizeFirstOfEach => replaceAll(RegExp(' +'), ' ').split(" ").map((str) => str.inCaps).join(" ");
}
