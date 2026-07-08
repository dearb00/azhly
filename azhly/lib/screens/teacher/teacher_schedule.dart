import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/class_info_card.dart';

/// "My Schedule" — a teacher's read-only view of their scheduled classes,
/// grouped by day. No teacher-name field is shown on each card since it's
/// obviously the signed-in teacher's own schedule.
class TeacherSchedulePage extends StatelessWidget {
  const TeacherSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final colors = AppColors(state.isDarkMode);
    final classes = buildMockTimetable();

    final byDay = <String, List<TimetableEntry>>{};
    for (final c in classes) {
      byDay.putIfAbsent(c.day, () => []).add(c);
    }
    for (final list in byDay.values) {
      list.sort((a, b) => a.startTime.compareTo(b.startTime));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('My Schedule 🗓️', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: colors.textPrimary)),
        Text('${classes.length} classes this week', style: TextStyle(fontSize: 13, color: colors.textMuted)),
        const SizedBox(height: 16),
        ...kDays.where((d) => byDay.containsKey(d)).map((day) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8, top: 4),
                    child: Row(children: [
                      Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: colors.accent)),
                      const SizedBox(width: 8),
                      Text(day, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: colors.textPrimary)),
                    ]),
                  ),
                  ...byDay[day]!.map((c) => ClassInfoCard(
                        entry: c,
                        room: findRoomByName(c.room, state.rooms),
                        colors: colors,
                        showTeacher: false,
                      )),
                ],
              ),
            )),
      ],
    );
  }
}
