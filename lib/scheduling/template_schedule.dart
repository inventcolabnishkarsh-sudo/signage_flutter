enum RecurrenceType {
  daily,
  weekly,
  monthly,
  yearly,
}

class TemplateSchedule {
  final bool enableSchedule;

  /// One-time schedule
  final DateTime? oneTimeStart;
  final DateTime? oneTimeEnd;

  /// Recurring rules
  final List<ScheduleRule> recurringRules;

  TemplateSchedule({
    required this.enableSchedule,
    this.oneTimeStart,
    this.oneTimeEnd,
    this.recurringRules = const [],
  });
}

class ScheduleRule {
  final RecurrenceType ruleType;

  /// Rule active date range
  final DateTime? startDate;
  final DateTime? endDate;

  /// Daily
  final Duration? dailyStartTime;
  final Duration? dailyEndTime;

  /// Weekly
  final List<int>? weeklyDays; // DateTime.monday = 1
  final Duration? weeklyStartTime;
  final Duration? weeklyEndTime;

  /// Monthly
  final List<int>? monthlyDays;
  final Duration? monthlyStartTime;
  final Duration? monthlyEndTime;

  /// Yearly
  final DateTime? yearlyDate;
  final Duration? yearlyStartTime;
  final Duration? yearlyEndTime;

  ScheduleRule({
    required this.ruleType,
    this.startDate,
    this.endDate,
    this.dailyStartTime,
    this.dailyEndTime,
    this.weeklyDays,
    this.weeklyStartTime,
    this.weeklyEndTime,
    this.monthlyDays,
    this.monthlyStartTime,
    this.monthlyEndTime,
    this.yearlyDate,
    this.yearlyStartTime,
    this.yearlyEndTime,
  });
}
