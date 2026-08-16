extension NullableIntDisplay on int? {
  String display({String fallback = 'N/A'}) {
    return this == null ? fallback : toString();
  }
}
