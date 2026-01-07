import 'template_schedule.dart';

class TemplateScheduleEvaluator {
  static bool shouldShowScheduledTemplate(TemplateSchedule? schedule) {
    if (schedule == null || !schedule.enableSchedule) {
      return false;
    }

    final now = DateTime.now();

    /// 1) One-time schedule
    if (schedule.oneTimeStart != null &&
        schedule.oneTimeEnd != null &&
        now.isAfter(schedule.oneTimeStart!) &&
        now.isBefore(schedule.oneTimeEnd!)) {
      return true;
    }

    /// 2) Recurring rules
    for (final rule in schedule.recurringRules) {
      if (!_isRuleActive(now, rule)) continue;

      switch (rule.ruleType) {
        case RecurrenceType.daily:
          if (_isDailyMatch(now, rule)) return true;
          break;

        case RecurrenceType.weekly:
          if (_isWeeklyMatch(now, rule)) return true;
          break;

        case RecurrenceType.monthly:
          if (_isMonthlyMatch(now, rule)) return true;
          break;

        case RecurrenceType.yearly:
          if (_isYearlyMatch(now, rule)) return true;
          break;
      }
    }

    return false;
  }

  static bool _isRuleActive(DateTime now, ScheduleRule rule) {
    if (rule.startDate != null && now.isBefore(rule.startDate!)) {
      return false;
    }
    if (rule.endDate != null && now.isAfter(rule.endDate!)) {
      return false;
    }
    return true;
  }

  static bool _isDailyMatch(DateTime now, ScheduleRule rule) {
    if (rule.dailyStartTime == null || rule.dailyEndTime == null) {
      return false;
    }

    final current = _timeOfDay(now);
    return current >= rule.dailyStartTime! &&
        current <= rule.dailyEndTime!;
  }

  static bool _isWeeklyMatch(DateTime now, ScheduleRule rule) {
    if (rule.weeklyDays == null ||
        !rule.weeklyDays!.contains(now.weekday)) {
      return false;
    }

    if (rule.weeklyStartTime == null ||
        rule.weeklyEndTime == null) {
      return false;
    }

    final current = _timeOfDay(now);
    return current >= rule.weeklyStartTime! &&
        current <= rule.weeklyEndTime!;
  }

  static bool _isMonthlyMatch(DateTime now, ScheduleRule rule) {
    if (rule.monthlyDays == null ||
        !rule.monthlyDays!.contains(now.day)) {
      return false;
    }

    if (rule.monthlyStartTime == null ||
        rule.monthlyEndTime == null) {
      return false;
    }

    final current = _timeOfDay(now);
    return current >= rule.monthlyStartTime! &&
        current <= rule.monthlyEndTime!;
  }

  static bool _isYearlyMatch(DateTime now, ScheduleRule rule) {
    if (rule.yearlyDate == null) {
      return false;
    }

    if (rule.yearlyDate!.month != now.month ||
        rule.yearlyDate!.day != now.day) {
      return false;
    }

    if (rule.yearlyStartTime == null ||
        rule.yearlyEndTime == null) {
      return false;
    }

    final current = _timeOfDay(now);
    return current >= rule.yearlyStartTime! &&
        current <= rule.yearlyEndTime!;
  }

  static Duration _timeOfDay(DateTime time) {
    return Duration(
      hours: time.hour,
      minutes: time.minute,
      seconds: time.second,
    );
  }

  static bool isScheduleExpired(TemplateSchedule? schedule) {
    if (schedule == null || !schedule.enableSchedule) {
      return true;
    }

    final now = DateTime.now();

    /// One-time schedule expired
    if (schedule.oneTimeEnd != null &&
        schedule.oneTimeEnd!.isBefore(now) &&
        schedule.recurringRules.isEmpty) {
      return true;
    }

    /// Recurring rules expired
    for (final rule in schedule.recurringRules) {
      if (rule.endDate != null &&
          rule.endDate!.isBefore(now)) {
        return true;
      }
    }

    return false;
  }
}
