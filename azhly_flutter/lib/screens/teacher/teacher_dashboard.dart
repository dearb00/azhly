import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/request_card.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  Widget _statCard(AppColors colors, String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: colors.cardBg, borderRadius: BorderRadius.circular(18), border: Border.all(color: colors.cardBorder)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
              alignment: Alignment.center,
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: colors.textPrimary)),
            Text(label, style: TextStyle(fontSize: 10, color: colors.textMuted)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final colors = AppColors(state.isDarkMode);

    final pendingForTeacher = state.requests.where((r) => r.status == RequestStatus.pending && r.requesterRole != AppRole.teacher).toList();
    final approved = state.requests.where((r) => r.status == RequestStatus.approved).toList();
    final freeRooms = state.rooms.where((r) => r.status == RoomStatus.free).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Good Morning 👋', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: colors.textPrimary)),
        Text(state.currentUser?.name ?? '', style: TextStyle(fontSize: 13, color: colors.textMuted)),
        const SizedBox(height: 16),
        Row(children: [
          _statCard(colors, 'Pending Requests', '${pendingForTeacher.length}', Icons.access_time, AppPalette.amber),
          const SizedBox(width: 10),
          _statCard(colors, 'Free Rooms', '$freeRooms', Icons.menu_book_rounded, AppPalette.green),
          const SizedBox(width: 10),
          _statCard(colors, 'Approved', '${approved.length}', Icons.check_circle_outline, AppPalette.purple),
        ]),
        const SizedBox(height: 20),
        Row(children: [
          Icon(Icons.groups_rounded, size: 16, color: colors.accent),
          const SizedBox(width: 6),
          Text('Awaiting Your Approval', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: colors.textPrimary)),
          if (pendingForTeacher.isNotEmpty) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(color: AppPalette.pink, borderRadius: BorderRadius.circular(999)),
              child: Text('${pendingForTeacher.length}', style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ]),
        const SizedBox(height: 10),
        if (pendingForTeacher.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: colors.cardBg.withOpacity(0.6), borderRadius: BorderRadius.circular(18)),
            child: Center(child: Text('No pending requests 🎉', style: TextStyle(fontSize: 13, color: colors.textMuted))),
          )
        else
          Column(
            children: pendingForTeacher.map((r) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: RequestCard(request: r, isDark: state.isDarkMode, showActions: true),
            )).toList(),
          ),
        const SizedBox(height: 20),
        Text('Recent Activity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: colors.textPrimary)),
        const SizedBox(height: 10),
        Column(
          children: state.requests.take(3).map((r) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: RequestCard(request: r, isDark: state.isDarkMode),
          )).toList(),
        ),
      ],
    );
  }
}
