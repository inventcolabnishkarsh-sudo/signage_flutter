import '../scheduling/template_schedule.dart';
import '../scheduling/template_schedule_evaluator.dart';

class PlaybackController {
  String? activeTemplateFile;
  TemplateSchedule? activeSchedule;

  bool shouldPlayNow() {
    return TemplateScheduleEvaluator
        .shouldShowScheduledTemplate(activeSchedule);
  }

  void updateTemplate(String fileName) {
    activeTemplateFile = fileName;
  }

  void updateSchedule(TemplateSchedule schedule) {
    activeSchedule = schedule;
  }
}
