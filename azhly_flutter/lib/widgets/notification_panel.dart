import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

String _timeAgo(int timestampMs) {
  final diff = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(timestampMs));
  if (diff.inMinutes < 1) return 'just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  return '${diff.inDays}d ago';
}

const _typeIcons = {
  NotificationType.info: 'ℹ️',
  NotificationType.success: '✅',
  NotificationType.error: '❌',
  NotificationType.warning: '⚠️',
  NotificationType.conflict: '⚡',
};

Color _typeColor(NotificationType t) {
  switch (t) {
    case NotificationType.info:
      return AppPalette.purple;
    case NotificationType.success:
      return AppPalette.green;
    case NotificationType.error:
      return AppPalette.red;
    case NotificationType.warning:
      return AppPalette.amber;
    case NotificationType.conflict:
      return AppPalette.pink;
  }
}

class NotificationPanel extends StatelessWidget {
  final VoidCallback onClose;
  const NotificationPanel({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final colors = AppColors(state.isDarkMode);

    return Positioned(
      right: 16,
      top: 76,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 300,
          constraints: const BoxConstraints(maxHeight: 360),
          decoration: BoxDecoration(
            color: colors.modalBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppPalette.purple.withOpacity(state.isDarkMode ? 0.35 : 0.2)),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 24, offset: Offset(0, 8))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: colors.cardBorder)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.notifications, size: 16, color: colors.accent),
                    const SizedBox(width: 8),
                    Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: colors.textPrimary)),
                    const Spacer(),
                    GestureDetector(
                      onTap: state.markAllRead,
                      child: Row(children: [
                        Icon(Icons.done_all, size: 13, color: colors.textMuted),
                        const SizedBox(width: 4),
                        Text('All read', style: TextStyle(fontSize: 11, color: colors.textMuted)),
                      ]),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(onTap: onClose, child: Icon(Icons.close, size: 16, color: colors.textMuted)),
                  ],
                ),
              ),
              Flexible(
                child: state.notifications.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text('No notifications', style: TextStyle(color: colors.textMuted, fontSize: 13)),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.notifications.length,
                        itemBuilder: (context, i) {
                          final n = state.notifications[i];
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: !n.read ? AppPalette.purple.withOpacity(0.06) : Colors.transparent,
                              border: Border(bottom: BorderSide(color: colors.cardBorder.withOpacity(0.4))),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_typeIcons[n.type] ?? '', style: const TextStyle(fontSize: 15)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(n.title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _typeColor(n.type))),
                                      const SizedBox(height: 2),
                                      Text(n.message, style: TextStyle(fontSize: 12, color: colors.textMuted)),
                                      const SizedBox(height: 4),
                                      Text(_timeAgo(n.timestamp), style: TextStyle(fontSize: 10, color: colors.textMuted.withOpacity(0.7))),
                                    ],
                                  ),
                                ),
                                if (!n.read)
                                  Container(
                                    margin: const EdgeInsets.only(top: 4, left: 4),
                                    width: 8, height: 8,
                                    decoration: BoxDecoration(shape: BoxShape.circle, color: _typeColor(n.type)),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
