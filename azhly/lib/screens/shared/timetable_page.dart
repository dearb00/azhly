import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../data/mock_data.dart';
import '../../theme/app_theme.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({super.key});

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  String activeDay = 'Monday';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final colors = AppColors(state.isDarkMode);
    final timetable = buildMockTimetable();
    final dayEntries = timetable.where((e) => e.day == activeDay).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Timetable 📅', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: colors.textPrimary)),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: kDays.map((day) {
              final active = activeDay == day;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => activeDay = day),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: active ? AppPalette.purpleGradient2 : null,
                      color: active ? null : colors.chipBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(day.substring(0, 3), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: active ? Colors.white : colors.accent)),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
        Text(activeDay, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colors.textPrimary)),
        const SizedBox(height: 10),
        if (dayEntries.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(color: colors.cardBg, borderRadius: BorderRadius.circular(18), border: Border.all(color: colors.cardBorder)),
            child: Column(children: [
              const Text('🎉', style: TextStyle(fontSize: 24)),
              const SizedBox(height: 6),
              Text('No classes scheduled', style: TextStyle(fontSize: 13, color: colors.textMuted)),
            ]),
          )
        else
          ...dayEntries.map((e) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: colors.cardBg, borderRadius: BorderRadius.circular(18), border: Border.all(color: colors.cardBorder)),
                child: Row(children: [
                  Container(width: 4, decoration: BoxDecoration(color: Color(e.color), borderRadius: BorderRadius.circular(4)), height: 44),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.subject, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: colors.textPrimary)),
                        Text(e.room, style: TextStyle(fontSize: 11, color: colors.textMuted)),
                        Text(e.teacher, style: TextStyle(fontSize: 11, color: colors.textMuted)),
                      ],
                    ),
                  ),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text(e.startTime, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(e.color))),
                    Text('to ${e.endTime}', style: TextStyle(fontSize: 10, color: colors.textMuted)),
                  ]),
                ]),
              )),
        const SizedBox(height: 16),
        Text('This Week', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: colors.textPrimary)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: colors.cardBg, borderRadius: BorderRadius.circular(18), border: Border.all(color: colors.cardBorder)),
          child: Column(children: kDays.map((day) {
            final count = timetable.where((e) => e.day == day).length;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(children: [
                SizedBox(width: 88, child: Text(day, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: colors.textPrimary))),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: (count / 3).clamp(0, 1),
                      minHeight: 8,
                      backgroundColor: AppPalette.purple.withValues(alpha: 0.1),
                      valueColor: const AlwaysStoppedAnimation(AppPalette.pink),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text('$count class${count != 1 ? 'es' : ''}', style: TextStyle(fontSize: 10, color: colors.textMuted)),
              ]),
            );
          }).toList()),
        ),
      ],
    );
  }
}
