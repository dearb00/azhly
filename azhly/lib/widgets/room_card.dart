import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class RoomCard extends StatelessWidget {
  final Room room;
  final bool isDark;
  final bool showRequest;
  final void Function(Room)? onRequest;

  const RoomCard({
    super.key,
    required this.room,
    required this.isDark,
    this.showRequest = true,
    this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors(isDark);
    final statusColor = colors.statusColor(room.status.name);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(room.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: colors.textPrimary)),
                    const SizedBox(height: 3),
                    Row(children: [
                      Icon(Icons.place_outlined, size: 12, color: colors.textMuted),
                      const SizedBox(width: 3),
                      Text('${room.building}, Floor ${room.floor}', style: TextStyle(fontSize: 11, color: colors.textMuted)),
                    ]),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(999)),
                child: Text(roomStatusLabel(room.status),
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: statusColor)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(children: [
            Icon(Icons.people_outline, size: 13, color: colors.textMuted),
            const SizedBox(width: 4),
            Text('${room.capacity} seats', style: TextStyle(fontSize: 11, color: colors.textMuted)),
          ]),
          if (room.currentClass != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(color: AppPalette.pink.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
              child: Text(
                '🎓 ${room.currentClass}${room.nextFreeAt != null ? ' · Free at ${room.nextFreeAt}' : ''}',
                style: const TextStyle(fontSize: 11, color: AppPalette.pink),
              ),
            ),
          ],
          const SizedBox(height: 10),
          Wrap(
            spacing: 6, runSpacing: 6,
            children: room.facilities.take(4).map((f) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: AppPalette.purple.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(999)),
                child: Text(f, style: TextStyle(fontSize: 10, color: colors.accent)),
              );
            }).toList(),
          ),
          if (showRequest && room.status != RoomStatus.occupied && onRequest != null) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => onRequest!(room),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPalette.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: const Text('Request Room', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              ),
            ),
          ],
        ],
      ),
    );
  }

}
