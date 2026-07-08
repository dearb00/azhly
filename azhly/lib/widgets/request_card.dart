import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class RequestCard extends StatelessWidget {
  final BookingRequest request;
  final bool isDark;
  final bool showActions;

  const RequestCard({super.key, required this.request, required this.isDark, this.showActions = false});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors(isDark);
    final state = context.read<AppState>();
    final statusColor = colors.statusColor(request.status.name);

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
            children: [
              Icon(Icons.place_outlined, size: 14, color: colors.accent),
              const SizedBox(width: 6),
              Expanded(child: Text(request.roomName, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: colors.textPrimary))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(999)),
                child: Text(requestStatusLabel(request.status), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(children: [
            Icon(Icons.person_outline, size: 12, color: colors.textMuted),
            const SizedBox(width: 4),
            Text(request.requesterName, style: TextStyle(fontSize: 11, color: colors.textMuted)),
          ]),
          const SizedBox(height: 3),
          Row(children: [
            Icon(Icons.access_time, size: 12, color: colors.textMuted),
            const SizedBox(width: 4),
            Text('${request.date} · ${request.startTime} – ${request.endTime}', style: TextStyle(fontSize: 11, color: colors.textMuted)),
          ]),
          const SizedBox(height: 4),
          Text(request.purpose, style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: colors.textMuted)),
          if (request.forwardedFrom != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text('Forwarded by: ${request.forwardedFrom}', style: TextStyle(fontSize: 10, color: colors.textMuted.withOpacity(0.8))),
            ),
          if (request.rejectionReason != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(request.rejectionReason!, style: const TextStyle(fontSize: 10, color: AppPalette.red)),
            ),
          if (request.approvedBy != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text('Approved by: ${request.approvedBy}', style: const TextStyle(fontSize: 10, color: AppPalette.green)),
            ),
          if (showActions && request.status == RequestStatus.pending) ...[
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => state.approveRequest(request.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPalette.purple,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Approve', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => state.rejectRequest(request.id, 'Declined by reviewer.'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppPalette.red,
                    side: const BorderSide(color: AppPalette.red),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Reject', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              ),
            ]),
          ],
        ],
      ),
    );
  }
}
