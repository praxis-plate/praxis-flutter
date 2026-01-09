import 'package:codium/l10n/app_localizations.dart';

class DurationFormatter {
  static String formatCompact(Duration duration, AppLocalizations s) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '$hours${s.hoursShort} $minutes${s.minutesShort}';
  }

  static String formatEstimated(Duration duration, AppLocalizations s) {
    if (duration.inSeconds < 60) {
      return '${duration.inSeconds} ${s.minutes}';
    } else if (duration.inMinutes < 60) {
      return '${duration.inMinutes} ${s.minutes}';
    } else {
      return '${duration.inHours} ${s.hours}';
    }
  }

  static String formatLessonDuration(Duration duration, AppLocalizations s) {
    final minutes = duration.inMinutes;
    if (minutes < 60) {
      return '$minutes ${s.minutesShort}';
    }
    final hours = duration.inHours;
    final remainingMinutes = minutes.remainder(60);
    return '$hours${s.hoursShort} $remainingMinutes${s.minutesShort}';
  }

  static String formatSeconds(int seconds, AppLocalizations s) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    if (minutes > 0) {
      return '$minutes${s.minutesShort} $remainingSeconds${s.secondsShort}';
    }
    return '$remainingSeconds${s.secondsShort}';
  }
}

@Deprecated('Use DurationFormatter methods with localization instead')
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
