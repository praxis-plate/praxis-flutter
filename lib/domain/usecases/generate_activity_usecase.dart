import 'package:codium/domain/models/models.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:talker_flutter/talker_flutter.dart';

class GenerateActivityUsecase {
  Future<List<ActivityCell>> execute() async {
    try {
      final today = DateTime.now();
      final startDate = today.subtract(const Duration(days: 365));
      final days = _generateDays(startDate, today);
      return _insertMonthMarkers(days);
    } catch (e, st) {
      GetIt.I<Talker>().error(e, st);
      return [ActivityDay(date: DateTime.now(), value: 1)];
    }
  }

  List<ActivityCell> generateAnnualActivity(DateTime startDate, DateTime endDate) {
    try {
      final days = _generateDays(startDate, endDate);
      return _insertMonthMarkers(days);
    } catch (e, st) {
      GetIt.I<Talker>().error('Activity generation error', e, st);
      return [ActivityDay(date: DateTime.now(), value: 1)];
    }
  }

  List<ActivityDay> _generateDays(DateTime start, DateTime end) {
    return List<ActivityDay>.generate(
      end.difference(start).inDays,
      (i) => ActivityDay(
        date: start.add(Duration(days: i)),
        value: start.add(Duration(days: i)).day % 5,
      ),
    );
  }

  List<ActivityCell> _insertMonthMarkers(List<ActivityDay> days) {
    final result = <ActivityCell>[];
    String? lastMonth;

    for (final day in days) {
      final currentMonth = DateFormat.MMM().format(day.date);
      if (currentMonth != lastMonth) {
        result.add(ActivityMonth(name: currentMonth));
        lastMonth = currentMonth;
      }
      result.add(day);
    }

    return result;
  }
}