import 'dart:convert';
import 'template_schedule.dart';

class TemplateScheduleParser {
  static TemplateSchedule parse(String jsonString) {
    final Map<String, dynamic> raw = jsonDecode(jsonString);

    // 🔥 Normalize backend keys (WinForms → Flutter)
    final bool enableSchedule =
        raw['enableSchedule'] ??
            raw['EnableSchedule'] ??
            false;

    final String? scheduleType =
    raw['ScheduleType']?.toString().toLowerCase();

    DateTime? oneTimeStart;
    DateTime? oneTimeEnd;
    List<ScheduleRule> recurringRules = [];

    // 🟢 ONE-TIME SCHEDULE (WinForms)
    if (scheduleType == 'onetime') {
      oneTimeStart = raw['oneTimeStart'] != null
          ? DateTime.parse(raw['oneTimeStart'])
          : raw['OneTimeStart'] != null
          ? DateTime.parse(raw['OneTimeStart'])
          : null;

      oneTimeEnd = raw['oneTimeEnd'] != null
          ? DateTime.parse(raw['oneTimeEnd'])
          : raw['OneTimeEnd'] != null
          ? DateTime.parse(raw['OneTimeEnd'])
          : null;
    }

    // 🔵 RECURRING SCHEDULE (future-ready)
    if (raw['recurringRules'] != null) {
      recurringRules = _parseRules(raw['recurringRules']);
    }

    return TemplateSchedule(
      enableSchedule: enableSchedule,
      oneTimeStart: oneTimeStart,
      oneTimeEnd: oneTimeEnd,
      recurringRules: recurringRules,
    );
  }

  static List<ScheduleRule> _parseRules(List<dynamic>? rulesJson) {
    if (rulesJson == null) return [];

    return rulesJson.map((rule) {
      return ScheduleRule(
        ruleType: RecurrenceType.values[rule['ruleType']],
        startDate: rule['startDate'] != null
            ? DateTime.parse(rule['startDate'])
            : null,
        endDate: rule['endDate'] != null
            ? DateTime.parse(rule['endDate'])
            : null,

        dailyStartTime: _parseTime(rule['dailyStartTime']),
        dailyEndTime: _parseTime(rule['dailyEndTime']),

        weeklyDays: rule['weeklyDays']?.cast<int>(),
        weeklyStartTime: _parseTime(rule['weeklyStartTime']),
        weeklyEndTime: _parseTime(rule['weeklyEndTime']),

        monthlyDays: rule['monthlyDays']?.cast<int>(),
        monthlyStartTime: _parseTime(rule['monthlyStartTime']),
        monthlyEndTime: _parseTime(rule['monthlyEndTime']),

        yearlyDate: rule['yearlyDate'] != null
            ? DateTime.parse(rule['yearlyDate'])
            : null,
        yearlyStartTime: _parseTime(rule['yearlyStartTime']),
        yearlyEndTime: _parseTime(rule['yearlyEndTime']),
      );
    }).toList();
  }

  static Duration? _parseTime(String? time) {
    if (time == null) return null;

    final parts = time.split(':');
    return Duration(
      hours: int.parse(parts[0]),
      minutes: int.parse(parts[1]),
      seconds: parts.length > 2 ? int.parse(parts[2]) : 0,
    );
  }
}
