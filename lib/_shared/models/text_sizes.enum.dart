enum TextSizes {
  small,
  medium,
  large;

  double get size {
    switch (this) {
      case TextSizes.small:
        return 13;
      case TextSizes.medium:
        return 16;
      case TextSizes.large:
        return 22;
      default:
        return 16;
    }
  }
}
