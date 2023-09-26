enum TextSizes {
  small,
  medium,
  large;

  double get size {
    switch (this) {
      case TextSizes.small:
        return 14;
      case TextSizes.medium:
        return 18;
      case TextSizes.large:
        return 24;
      default:
        return 16;
    }
  }
}
