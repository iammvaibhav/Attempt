import 'package:attempt/repository/model/Word.dart';
import 'package:attempt/words/transformation/filters/Filter.dart';

/// Next day starts at 3 am!
class DateFilter extends Filter {

  // these
  DateTime startDate;
  DateTime endDate;

  DateFilter(this.startDate, this.endDate);
  
  DateFilter.from(ConvenientDateFilterType dateFilterType) {
    final bounds = _getDateBounds(dateFilterType);
    startDate = bounds[0];
    endDate = bounds[1];
  }

  @override
  bool satisfies(Word word) {
    return word.lastUpdated.isAfter(startDate) && word.lastUpdated.isBefore(endDate);
  }

  List<DateTime> _getDateBounds(ConvenientDateFilterType dateFilterType) {
    final now = DateTime.now();
    switch (dateFilterType) {
      case ConvenientDateFilterType.LAST_24_HOURS: return [DateTime.now().subtract(Duration(days: 1)), now];
      case ConvenientDateFilterType.TODAY: return [DateTime(now.year, now.month, now.day, 3), now];
      case ConvenientDateFilterType.YESTERDAY: return [DateTime(now.year, now.month, now.day, 3).subtract(Duration(days: 1)),
        DateTime(now.year, now.month, now.day, 3)];
      case ConvenientDateFilterType.LAST_3_DAYS: return [DateTime(now.year, now.month, now.day, 3).subtract(Duration(days: 3)), now];
      case ConvenientDateFilterType.LAST_WEEK: return [DateTime(now.year, now.month, now.day, 3).subtract(Duration(days: 7)), now];
      case ConvenientDateFilterType.LAST_MONTH: return [DateTime(now.year, now.month, now.day, 3).subtract(Duration(days: 30)), now];
    }
  }
}

enum ConvenientDateFilterType {
  LAST_24_HOURS, TODAY, YESTERDAY, LAST_3_DAYS, LAST_WEEK, LAST_MONTH
}