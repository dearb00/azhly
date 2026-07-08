import '../models/models.dart';

int _timeToMinutes(String time) {
  final parts = time.split(':');
  final h = int.parse(parts[0]);
  final m = int.parse(parts[1]);
  return h * 60 + m;
}

/// Groups requests by room+date+time slot and resolves conflicts using
/// First-Come-First-Served (earliest createdAt wins).
List<BookingRequest> resolveConflicts(List<BookingRequest> requests) {
  final Map<String, List<BookingRequest>> grouped = {};

  for (final req in requests) {
    final key = '${req.roomId}_${req.date}_${req.startTime}_${req.endTime}';
    grouped.putIfAbsent(key, () => []).add(req);
  }

  final List<BookingRequest> resolved = [];

  for (final group in grouped.values) {
    if (group.length == 1) {
      resolved.add(group.first);
    } else {
      final sorted = [...group]..sort((a, b) => a.createdAt.compareTo(b.createdAt));
      for (var idx = 0; idx < sorted.length; idx++) {
        final req = sorted[idx];
        if (idx == 0) {
          resolved.add(req.copyWith(status: RequestStatus.approved, approvedBy: 'Smart Engine (FCFS)'));
        } else {
          resolved.add(req.copyWith(
            status: RequestStatus.rejected,
            rejectionReason:
                'Conflict: Room already allocated to ${sorted[0].requesterName} via First-Come-First-Served policy.',
          ));
        }
      }
    }
  }

  return resolved;
}

/// Checks whether a new (not-yet-created) request overlaps an existing one
/// for the same room & date.
bool checkTimeConflict(List<BookingRequest> existing, {
  required String roomId,
  required String date,
  required String startTime,
  required String endTime,
}) {
  for (final req in existing) {
    if (req.roomId != roomId || req.date != date) continue;
    if (req.status == RequestStatus.rejected) continue;
    final newStart = _timeToMinutes(startTime);
    final newEnd = _timeToMinutes(endTime);
    final existStart = _timeToMinutes(req.startTime);
    final existEnd = _timeToMinutes(req.endTime);
    if (newStart < existEnd && newEnd > existStart) return true;
  }
  return false;
}
