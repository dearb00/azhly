import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/request_card.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

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
              decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
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

    final myRequests = state.requests.where((r) => r.requesterRole == AppRole.student).toList();
    final freeRooms = state.rooms.where((r) => r.status == RoomStatus.free).length;
    final approvedCount = myRequests.where((r) => r.status == RequestStatus.approved).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Hello, ${state.currentUser?.name.split(' ').first ?? ''}! 👋',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: colors.textPrimary)),
        Text('Track your room suggestions below', style: TextStyle(fontSize: 13, color: colors.textMuted)),
        const SizedBox(height: 16),
        Row(children: [
          _statCard(colors, 'My Requests', '${myRequests.length}', Icons.menu_book_rounded, AppPalette.purple),
          const SizedBox(width: 10),
          _statCard(colors, 'Approved', '$approvedCount', Icons.access_time, AppPalette.green),
          const SizedBox(width: 10),
          _statCard(colors, 'Free Rooms', '$freeRooms', Icons.lightbulb_outline, AppPalette.pink),
        ]),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(gradient: AppPalette.purpleGradient, borderRadius: BorderRadius.circular(18)),
            child: ElevatedButton(
              onPressed: () => state.setTab('suggest'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent, shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
              child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.lightbulb, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text('Suggest a Room', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              ]),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text('My Request History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: colors.textPrimary)),
        const SizedBox(height: 10),
        if (myRequests.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: colors.cardBg, borderRadius: BorderRadius.circular(18), border: Border.all(color: colors.cardBorder)),
            child: Center(child: Text('No requests yet. Suggest a room above!', style: TextStyle(fontSize: 13, color: colors.textMuted))),
          )
        else
          Column(children: myRequests.map((r) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: RequestCard(request: r, isDark: state.isDarkMode),
          )).toList()),
      ],
    );
  }
}
