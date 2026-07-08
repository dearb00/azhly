import '../models/models.dart';

final int _now = DateTime.now().millisecondsSinceEpoch;

List<Room> buildMockRooms() => [
      Room(id: 'r1', name: 'Room 101', building: 'Block A', floor: 1, capacity: 40, status: RoomStatus.free, facilities: ['Projector', 'AC', 'Whiteboard']),
      Room(id: 'r2', name: 'Room 202', building: 'Block A', floor: 2, capacity: 60, status: RoomStatus.occupied, facilities: ['Projector', 'AC', 'Smart Board'], currentClass: 'CS301 - Data Structures', nextFreeAt: '11:00 AM'),
      Room(id: 'r3', name: 'Lab 301', building: 'Block B', floor: 3, capacity: 30, status: RoomStatus.free, facilities: ['Computers', 'AC', 'Projector']),
      Room(id: 'r4', name: 'Seminar Hall', building: 'Block C', floor: 1, capacity: 120, status: RoomStatus.regular, facilities: ['Stage', 'Mic', 'Projector', 'AC'], currentClass: 'Weekly Seminar'),
      Room(id: 'r5', name: 'Room 105', building: 'Block A', floor: 1, capacity: 45, status: RoomStatus.free, facilities: ['Whiteboard', 'Fans']),
      Room(id: 'r6', name: 'Conference Room', building: 'Admin Block', floor: 2, capacity: 20, status: RoomStatus.free, facilities: ['Smart Board', 'Video Call Setup', 'AC']),
      Room(id: 'r7', name: 'Lab 205', building: 'Block B', floor: 2, capacity: 35, status: RoomStatus.occupied, facilities: ['Computers', 'AC'], currentClass: 'CS201 - Programming', nextFreeAt: '2:00 PM'),
      Room(id: 'r8', name: 'Room 310', building: 'Block C', floor: 3, capacity: 50, status: RoomStatus.free, facilities: ['Projector', 'AC', 'Whiteboard']),
    ];

List<TimetableEntry> buildMockTimetable() => [
      TimetableEntry(id: 't1', subject: 'Data Structures', room: 'Room 202', teacher: 'Dr. Ahmed', day: 'Monday', startTime: '09:00', endTime: '10:30', color: 0xFF7C3AED, department: 'CS'),
      TimetableEntry(id: 't2', subject: 'Algorithms', room: 'Lab 301', teacher: 'Dr. Sara', day: 'Monday', startTime: '11:00', endTime: '12:30', color: 0xFFEC4899, department: 'CS'),
      TimetableEntry(id: 't3', subject: 'Database Systems', room: 'Room 101', teacher: 'Dr. Khan', day: 'Tuesday', startTime: '09:00', endTime: '10:30', color: 0xFF3B82F6, department: 'SE'),
      TimetableEntry(id: 't4', subject: 'Operating Systems', room: 'Room 310', teacher: 'Dr. Ali', day: 'Wednesday', startTime: '14:00', endTime: '15:30', color: 0xFF10B981, department: 'CS'),
      TimetableEntry(id: 't5', subject: 'Computer Networks', room: 'Lab 205', teacher: 'Dr. Fatima', day: 'Thursday', startTime: '10:00', endTime: '11:30', color: 0xFFF59E0B, department: 'IT'),
      TimetableEntry(id: 't6', subject: 'Software Engineering', room: 'Conference Room', teacher: 'Dr. Raza', day: 'Friday', startTime: '09:00', endTime: '10:30', color: 0xFF8B5CF6, department: 'SE'),
      TimetableEntry(id: 't7', subject: 'Discrete Structures', room: 'Room 101', teacher: 'Miss Ayesha', day: kTodayName, startTime: '13:30', endTime: '15:00', color: 0xFF3B82F6, department: 'CS'),
      TimetableEntry(id: 't8', subject: 'Artificial Intelligence', room: 'Room 310', teacher: 'Dr. Fatima', day: kTodayName, startTime: '15:00', endTime: '16:30', color: 0xFFF59E0B, department: 'CS'),
    ];

/// Convenience lookup so class cards can show block / floor without
/// duplicating that data on every timetable entry.
Room? findRoomByName(String name, List<Room> rooms) {
  for (final r in rooms) {
    if (r.name == name) return r;
  }
  return null;
}

/// Today's weekday name (falls back to 'Monday' on weekends so the demo
/// data always has something to show).
String get kTodayName {
  const names = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  final idx = DateTime.now().weekday - 1;
  final name = names[idx];
  return kDays.contains(name) ? name : 'Monday';
}

List<BookingRequest> buildMockRequests() => [
      BookingRequest(
        id: 'req1', roomId: 'r1', roomName: 'Room 101',
        requesterId: 'u2', requesterName: 'Ali Hassan (CR)', requesterRole: AppRole.cr,
        date: '2026-07-08', startTime: '14:00', endTime: '15:30',
        purpose: 'Group Study Session', status: RequestStatus.pending,
        createdAt: _now - 3600000,
      ),
      BookingRequest(
        id: 'req2', roomId: 'r5', roomName: 'Room 105',
        requesterId: 'u3', requesterName: 'Ayesha (Student)', requesterRole: AppRole.student,
        date: '2026-07-08', startTime: '16:00', endTime: '17:00',
        purpose: 'Project Presentation Practice', status: RequestStatus.pending,
        createdAt: _now - 1800000, forwardedFrom: 'Sara (CR)',
      ),
      BookingRequest(
        id: 'req3', roomId: 'r3', roomName: 'Lab 301',
        requesterId: 'u1', requesterName: 'Dr. Ahmed (Teacher)', requesterRole: AppRole.teacher,
        date: '2026-07-07', startTime: '10:00', endTime: '11:30',
        purpose: 'Extra Lab Session', status: RequestStatus.approved,
        createdAt: _now - 86400000, approvedBy: 'Dr. Ahmed',
      ),
    ];

List<AppNotification> buildMockNotifications() => [
      AppNotification(id: 'n1', title: 'Booking Approved', message: 'Lab 301 booking for July 7 has been approved.', type: NotificationType.success, timestamp: _now - 3600000, read: false),
      AppNotification(id: 'n2', title: '⚡ Conflict Alert', message: 'Room 105 conflict detected! Your request was approved via FCFS.', type: NotificationType.conflict, timestamp: _now - 7200000, read: false),
      AppNotification(id: 'n3', title: 'New Room Request', message: 'Ali Hassan forwarded a room request for your approval.', type: NotificationType.info, timestamp: _now - 86400000, read: true),
    ];

const List<String> kDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
const List<String> kTimeSlots = ['08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00'];
