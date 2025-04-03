import 'package:hive/hive.dart';

class StatisticsService {
  final Box _statsBox;

  StatisticsService(this._statsBox);

  int get totalDhikr => _statsBox.get('totalDhikr', defaultValue: 0) as int;
  int get dailyDhikr => _statsBox.get('dailyDhikr', defaultValue: 0) as int;
  int get weeklyDhikr => _statsBox.get('weeklyDhikr', defaultValue: 0) as int;
  int get monthlyDhikr => _statsBox.get('monthlyDhikr', defaultValue: 0) as int;
  DateTime? get lastResetDate => _statsBox.get('lastResetDate');

  Future<void> updateCounts(int change) async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      // First check if we need to reset any periods
      if (lastResetDate == null || today.isAfter(lastResetDate!)) {
        bool newWeek = lastResetDate != null &&
            now.weekday == 5 &&
            lastResetDate!.weekday != 5;
        bool newMonth = lastResetDate != null &&
            now.month != lastResetDate!.month;

        // Reset periods before adding new counts
        if (newWeek) await _statsBox.put('weeklyDhikr', 0);
        if (newMonth) await _statsBox.put('monthlyDhikr', 0);

        // Always reset daily for new day
        await _statsBox.put('dailyDhikr', 0);
        await _statsBox.put('lastResetDate', today);
      }

      // Then update all counts (including newly reset ones)
      await _statsBox.put('dailyDhikr', dailyDhikr + change);
      await _statsBox.put('weeklyDhikr', weeklyDhikr + change);
      await _statsBox.put('monthlyDhikr', monthlyDhikr + change);
      await _statsBox.put('totalDhikr', totalDhikr + change);

    } catch (e) {
      print('Error updating statistics: $e');
      rethrow;
    }
  }

  // Debug method
  void printDebugStats() {
    print('''
    Daily: $dailyDhikr (last reset: $lastResetDate)
    Weekly: $weeklyDhikr
    Monthly: $monthlyDhikr
    Total: $totalDhikr
    ''');
  }
}