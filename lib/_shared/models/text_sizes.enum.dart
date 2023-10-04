enum TextSizes {
  xsmall,
  small,
  medium,
  large,
  xlarge;

  double get size {
    switch (this) {
      case TextSizes.xsmall:
        return 8;
      case TextSizes.small:
        return 13;
      case TextSizes.medium:
        return 15;
      case TextSizes.large:
        return 17;
      case TextSizes.xlarge:
        return 22;
      default:
        return 15;
    }
  }
}
