T getEnumFromString<T>(List<T> values, String value) {
  final folder = values.firstWhere(
      (type) => type.toString().split('.').last == value,
      orElse: () => values.first);
  return folder;
}
