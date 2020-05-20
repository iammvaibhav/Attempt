import 'dart:collection';

import 'package:attempt/repository/model/Sentence.dart';

import 'Filter.dart';

class DateFilter extends Filter {

  // these
  DateTime startDate;
  DateTime endDate;
  HashMap<String, DateTime> lastUpdatedData;

  DateFilter(this.startDate, this.endDate, this.lastUpdatedData);

  DateFilter.from(String dateFilterType, this.lastUpdatedData) {
    final bounds = _getDateBounds(dateFilterType);
    startDate = bounds[0];
    endDate = bounds[1];
  }


  @override
  bool satisfies(Sentence sentence) {
    if (lastUpdatedData.containsKey(sentence.word)) {
      final wordLastUpdated = lastUpdatedData[sentence.word];
      return wordLastUpdated.isAfter(startDate) && wordLastUpdated.isBefore(endDate);
    }
    return false;
  }

  List<DateTime> _getDateBounds(String dateFilterType) {
    final now = DateTime.now();
    switch (dateFilterType) {
      case "Last 24 Hours": return [DateTime.now().subtract(Duration(days: 1)), now];
      case "Today": return [DateTime(now.year, now.month, now.day, 3), now];
      case "Yesterday": return [DateTime(now.year, now.month, now.day, 3).subtract(Duration(days: 1)),
        DateTime(now.year, now.month, now.day, 3)];
      case "Last 3 Days": return [DateTime(now.year, now.month, now.day, 3).subtract(Duration(days: 3)), now];
      case "Last Week": return [DateTime(now.year, now.month, now.day, 3).subtract(Duration(days: 7)), now];
      case "Last Month": return [DateTime(now.year, now.month, now.day, 3).subtract(Duration(days: 30)), now];
    }
  }
}