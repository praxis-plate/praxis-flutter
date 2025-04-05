extension DurationFormatting on Duration {
  String format() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    if (inHours > 99) {
      return '99+ ч';
    }

    List<String> parts = [];

    if (inHours > 0) {
      parts.add('${twoDigits(inHours)}ч');
    }

    if (inMinutes.remainder(60) > 0) {
      parts.add('${twoDigits(inMinutes.remainder(60))}м');
    }

    return parts.isNotEmpty ? parts.join(' ') : '0м';
  }
}
