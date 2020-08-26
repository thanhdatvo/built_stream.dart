class StringUtils {
  static final StringUtils _instance = StringUtils._();
  StringUtils._();
  factory StringUtils() => _instance;

  String capitalizeOnlyFirstLetter(String word) =>
      '${word[0].toLowerCase()}${word.substring(1)}';
  String getAction(String displayName) =>
      displayName.replaceFirst("Stream", "");
}
