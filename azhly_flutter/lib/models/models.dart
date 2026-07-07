// Core data models for the AZHly app.
// Mirrors: src/types/index.ts from the original React source.

enum AppRole { teacher, cr, student, admin }

AppRole roleFromString(String s) {
  switch (s) {
    case 'teacher':
      return AppRole.teacher;
    case 'cr':
      return AppRole.cr;
    case 'student':
      return AppRole.student;
    case 'admin':
      return AppRole.admin;
  }
  return AppRole.student;
}

String roleToString(AppRole r) {
  switch (r) {
    case AppRole.teacher:
      return 'teacher';
    case AppRole.cr:
      return 'cr';
    case AppRole.student:
      return 'student';
    case AppRole.admin:
      return 'admin';
  }
}

String roleLabel(AppRole r) {
  switch (r) {
    case AppRole.teacher:
      return 'Teacher';
    case AppRole.cr:
      return 'Class Representative';
    case AppRole.student:
      return 'Student';
    case AppRole.admin:
      return 'Administrator';
  }
}

enum RoomStatus { free, occupied, regular }

RoomStatus roomStatusFromString(String s) {
  switch (s) {
    case 'occupied':
      return RoomStatus.occupied;
    case 'regular':
      return RoomStatus.regular;
    default:
      return RoomStatus.free;
  }
}

String roomStatusLabel(RoomStatus s) {
  switch (s) {
    case RoomStatus.free:
      return 'Free';
    case RoomStatus.occupied:
      return 'Occupied';
    case RoomStatus.regular:
      return 'Regular';
  }
}

enum RequestStatus { pending, approved, rejected, conflict }

String requestStatusLabel(RequestStatus s) {
  switch (s) {
    case RequestStatus.pending:
      return 'Pending';
    case RequestStatus.approved:
      return 'Approved';
    case RequestStatus.rejected:
      return 'Rejected';
    case RequestStatus.conflict:
      return 'Conflict';
  }
}

enum NotificationType { info, success, error, warning, conflict }

class AppUser {
  final String id;
  final String name;
  final String email;
  AppRole role;
  final String? department;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.department,
  });

  AppUser copyWith({AppRole? role}) => AppUser(
        id: id,
        name: name,
        email: email,
        role: role ?? this.role,
        department: department,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': roleToString(role),
        'department': department,
      };

  factory AppUser.fromJson(Map<String, dynamic> j) => AppUser(
        id: j['id'],
        name: j['name'],
        email: j['email'],
        role: roleFromString(j['role']),
        department: j['department'],
      );
}

class Room {
  final String id;
  final String name;
  final String building;
  final int floor;
  final int capacity;
  RoomStatus status;
  final List<String> facilities;
  final String? currentClass;
  final String? nextFreeAt;

  Room({
    required this.id,
    required this.name,
    required this.building,
    required this.floor,
    required this.capacity,
    required this.status,
    required this.facilities,
    this.currentClass,
    this.nextFreeAt,
  });
}

class BookingRequest {
  final String id;
  final String roomId;
  final String roomName;
  final String requesterId;
  final String requesterName;
  final AppRole requesterRole;
  final String date;
  final String startTime;
  final String endTime;
  final String purpose;
  RequestStatus status;
  final int createdAt;
  final String? forwardedFrom;
  String? rejectionReason;
  String? approvedBy;

  BookingRequest({
    required this.id,
    required this.roomId,
    required this.roomName,
    required this.requesterId,
    required this.requesterName,
    required this.requesterRole,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.purpose,
    required this.status,
    required this.createdAt,
    this.forwardedFrom,
    this.rejectionReason,
    this.approvedBy,
  });

  BookingRequest copyWith({
    RequestStatus? status,
    String? rejectionReason,
    String? approvedBy,
  }) {
    return BookingRequest(
      id: id,
      roomId: roomId,
      roomName: roomName,
      requesterId: requesterId,
      requesterName: requesterName,
      requesterRole: requesterRole,
      date: date,
      startTime: startTime,
      endTime: endTime,
      purpose: purpose,
      status: status ?? this.status,
      createdAt: createdAt,
      forwardedFrom: forwardedFrom,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      approvedBy: approvedBy ?? this.approvedBy,
    );
  }
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final int timestamp;
  bool read;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.read = false,
  });
}

class TimetableEntry {
  final String id;
  final String subject;
  final String room;
  final String teacher;
  final String day;
  final String startTime;
  final String endTime;
  final int color; // ARGB color value
  final String department;

  TimetableEntry({
    required this.id,
    required this.subject,
    required this.room,
    required this.teacher,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.color,
    this.department = 'CS',
  });
}
