import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/request_card.dart';

class CrDashboard extends StatelessWidget {
  const CrDashboard({super.key});

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

    final myRequests = state.requests.where((r) => r.requesterRole == AppRole.cr || r.forwardedFrom != null).toList();
    final pending = state.requests.where((r) => r.status == RequestStatus.pending).toList();
    final freeRooms = state.rooms.where((r) => r.status == RoomStatus.free).length;
    final studentPending = state.requests.where((r) => r.requesterRole == AppRole.student && r.status == RequestStatus.pending).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('CR Dashboard 👋', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: colors.textPrimary)),
        Text(state.currentUser?.name ?? '', style: TextStyle(fontSize: 13, color: colors.textMuted)),
        const SizedBox(height: 16),
        Row(children: [
          _statCard(colors, 'My Requests', '${myRequests.length}', Icons.menu_book_rounded, AppPalette.purple),
          const SizedBox(width: 10),
          _statCard(colors, 'Pending', '${pending.length}', Icons.access_time, AppPalette.amber),
          const SizedBox(width: 10),
          _statCard(colors, 'Free Rooms', '$freeRooms', Icons.search, AppPalette.green),
        ]),
        const SizedBox(height: 20),
        Text('Student Requests to Forward', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: colors.textPrimary)),
        const SizedBox(height: 10),
        if (studentPending.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: colors.cardBg.withOpacity(0.6), borderRadius: BorderRadius.circular(18)),
            child: Center(child: Text('No student requests pending', style: TextStyle(fontSize: 13, color: colors.textMuted))),
          )
        else
          Column(children: studentPending.map((r) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: RequestCard(request: r, isDark: state.isDarkMode, showActions: true),
          )).toList()),
        const SizedBox(height: 20),
        Text('All Requests', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: colors.textPrimary)),
        const SizedBox(height: 10),
        Column(children: state.requests.take(4).map((r) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: RequestCard(request: r, isDark: state.isDarkMode),
        )).toList()),
      ],
    );
  }
}
