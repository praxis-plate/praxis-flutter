import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:talker/talker.dart';

class ActivityCell {
  static List<ActivityCell> annualActivityCells = [];

  static List<ActivityCell> getExampleList() {
    try {
      final today = DateTime.now();
      final startDate = today.subtract(const Duration(days: 365));
      annualActivityCells = _generateActivityCells(startDate, today);
      annualActivityCells = _addMonthNameCells();
      return annualActivityCells;
    } catch (e, st) {
      GetIt.I<Talker>().error(e, st);

      return [
        ActivityDay(date: DateTime.now(), value: 1),
      ];
    }
  }

  static List<ActivityCell> _generateActivityCells(
    DateTime startDate,
    DateTime endDate,
  ) {
    List<ActivityCell> data = [];
    for (DateTime date = startDate;
        date.isBefore(endDate);
        date = date.add(const Duration(days: 1))) {
      data.add(
        ActivityDay(date: date, value: (date.day % 5)),
      );
    }
    return data;
  }

  static List<ActivityCell> _addMonthNameCells() {
    final newLength = annualActivityCells.length + _monthsCount();
    final activityCellsWithMonthNames = <ActivityCell>[];
    final monthNames = <String>{''};

    for (int i = 0; i < newLength; i++) {
      if (_isMonthNameCell(i)) {
        final currentDate =
            (annualActivityCells[_indexSkippingMonths(i)] as ActivityDay).date;
        final monthName = DateFormat.MMM().format(currentDate);
        var monthText = '';

        if (monthName != monthNames.last) {
          monthNames.add(monthName);
          monthText = monthName;
        }

        activityCellsWithMonthNames.add(ActivityMonthName(name: monthText));
      } else {
        activityCellsWithMonthNames
            .add(annualActivityCells[_indexSkippingMonths(i)]);
      }
    }

    return activityCellsWithMonthNames;
  }

  static int _monthsCount() => (annualActivityCells.length / 7).ceil();

  static int _indexSkippingMonths(int i) => i - 1 * (i ~/ 7);

  static bool _isMonthNameCell(int i) => i % 8 == 0;
}

class ActivityMonthName implements ActivityCell {
  final String name;

  ActivityMonthName({
    required this.name,
  });
}

class ActivityDay implements ActivityCell {
  final DateTime date;
  final int value;

  ActivityDay({
    required this.date,
    required this.value,
  });
}
