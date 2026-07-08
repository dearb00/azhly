import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

/// Card used for "My Classes" (student / CR-GR) and "My Schedule" (teacher).
/// Shows department, room no., block, floor, time slot and subject — plus
/// the teacher's name, except when [showTeacher] is false (a teacher
/// viewing their own schedule doesn't need to see their own name repeated
/// on every card).
class ClassInfoCard extends StatelessWidget {
  final TimetableEntry entry;
  final Room? room;
  final AppColors colors;
  final bool showTeacher;
  final bool showDay;

  const ClassInfoCard({
    super.key,
    required this.entry,
    required this.room,
    required this.colors,
    this.showTeacher = true,
    this.showDay = false,
  });

  Widget _chip(String text, {IconData? icon}) {
    final c = Color(entry.color);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) ...[Icon(icon, size: 11, color: c), const SizedBox(width: 3)],
        Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: c)),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Color(entry.color);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: colors.cardBg, borderRadius: BorderRadius.circular(18), border: Border.all(color: colors.cardBorder)),
      child: IntrinsicHeight(
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(width: 4, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(
                    child: Text(entry.subject, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: colors.textPrimary)),
                  ),
                  if (showDay)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(999)),
                      child: Text(entry.day.substring(0, 3), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
                    ),
                ]),
                const SizedBox(height: 8),
                Wrap(spacing: 6, runSpacing: 6, children: [
                  _chip(entry.department),
                  _chip('Room No: ${room?.name.replaceAll(RegExp(r'[^0-9]'), '') ?? entry.room}', icon: Icons.meeting_room_outlined),
                  _chip(room?.building ?? '—', icon: Icons.apartment_outlined),
                  _chip('Floor: ${room?.floor ?? '—'}', icon: Icons.layers_outlined),
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  if (showTeacher) ...[
                    Icon(Icons.person_outline, size: 12, color: colors.textMuted),
                    const SizedBox(width: 3),
                    Flexible(child: Text(entry.teacher, style: TextStyle(fontSize: 11, color: colors.textMuted), overflow: TextOverflow.ellipsis)),
                    const SizedBox(width: 10),
                  ],
                  Icon(Icons.access_time, size: 12, color: colors.textMuted),
                  const SizedBox(width: 3),
                  Text('${entry.startTime}–${entry.endTime}', style: TextStyle(fontSize: 11, color: colors.textMuted)),
                ]),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }
}
