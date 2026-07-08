import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../data/mock_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/class_info_card.dart';

/// "My Classes" — shows only today's classes as cards containing
/// department, room no., block, floor, teacher name, time slot & subject.
class MyClassesPage extends StatelessWidget {
  const MyClassesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final colors = AppColors(state.isDarkMode);
    final all = buildMockTimetable();
    final today = kTodayName;
    final todayClasses = all.where((c) => c.day == today).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('My Classes 📚', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: colors.textPrimary)),
        Text("Today · $today · ${todayClasses.length} class${todayClasses.length == 1 ? '' : 'es'}",
            style: TextStyle(fontSize: 13, color: colors.textMuted)),
        const SizedBox(height: 16),
        if (todayClasses.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: colors.cardBg, borderRadius: BorderRadius.circular(18), border: Border.all(color: colors.cardBorder)),
            child: Center(child: Text('No classes scheduled for today 🎉', style: TextStyle(fontSize: 13, color: colors.textMuted))),
          )
        else
          ...todayClasses.map((c) => ClassInfoCard(
                entry: c,
                room: findRoomByName(c.room, state.rooms),
                colors: colors,
                showTeacher: true,
              )),
      ],
    );
  }
}
