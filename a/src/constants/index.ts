import { Room, BookingRequest, TimetableEntry, Notification } from '@/types';

export const MOCK_ROOMS: Room[] = [
  { id: 'r1', name: 'Room 101', building: 'Block A', floor: 1, capacity: 40, status: 'free', facilities: ['Projector', 'AC', 'Whiteboard'] },
  { id: 'r2', name: 'Room 202', building: 'Block A', floor: 2, capacity: 60, status: 'occupied', facilities: ['Projector', 'AC', 'Smart Board'], currentClass: 'CS301 - Data Structures', nextFreeAt: '11:00 AM' },
  { id: 'r3', name: 'Lab 301', building: 'Block B', floor: 3, capacity: 30, status: 'free', facilities: ['Computers', 'AC', 'Projector'] },
  { id: 'r4', name: 'Seminar Hall', building: 'Block C', floor: 1, capacity: 120, status: 'regular', facilities: ['Stage', 'Mic', 'Projector', 'AC'], currentClass: 'Weekly Seminar' },
  { id: 'r5', name: 'Room 105', building: 'Block A', floor: 1, capacity: 45, status: 'free', facilities: ['Whiteboard', 'Fans'] },
  { id: 'r6', name: 'Conference Room', building: 'Admin Block', floor: 2, capacity: 20, status: 'free', facilities: ['Smart Board', 'Video Call Setup', 'AC'] },
  { id: 'r7', name: 'Lab 205', building: 'Block B', floor: 2, capacity: 35, status: 'occupied', facilities: ['Computers', 'AC'], currentClass: 'CS201 - Programming', nextFreeAt: '2:00 PM' },
  { id: 'r8', name: 'Room 310', building: 'Block C', floor: 3, capacity: 50, status: 'free', facilities: ['Projector', 'AC', 'Whiteboard'] },
];

export const MOCK_TIMETABLE: TimetableEntry[] = [
  { id: 't1', subject: 'Data Structures', room: 'Room 202', teacher: 'Dr. Ahmed', day: 'Monday', startTime: '09:00', endTime: '10:30', color: '#7C3AED' },
  { id: 't2', subject: 'Algorithms', room: 'Lab 301', teacher: 'Dr. Sara', day: 'Monday', startTime: '11:00', endTime: '12:30', color: '#EC4899' },
  { id: 't3', subject: 'Database Systems', room: 'Room 101', teacher: 'Dr. Khan', day: 'Tuesday', startTime: '09:00', endTime: '10:30', color: '#3B82F6' },
  { id: 't4', subject: 'Operating Systems', room: 'Room 310', teacher: 'Dr. Ali', day: 'Wednesday', startTime: '14:00', endTime: '15:30', color: '#10B981' },
  { id: 't5', subject: 'Computer Networks', room: 'Lab 205', teacher: 'Dr. Fatima', day: 'Thursday', startTime: '10:00', endTime: '11:30', color: '#F59E0B' },
  { id: 't6', subject: 'Software Engineering', room: 'Conference Room', teacher: 'Dr. Raza', day: 'Friday', startTime: '09:00', endTime: '10:30', color: '#8B5CF6' },
];

export const MOCK_REQUESTS: BookingRequest[] = [
  { id: 'req1', roomId: 'r1', roomName: 'Room 101', requesterId: 'u2', requesterName: 'Ali Hassan (CR)', requesterRole: 'cr', date: '2026-07-08', startTime: '14:00', endTime: '15:30', purpose: 'Group Study Session', status: 'pending', createdAt: Date.now() - 3600000 },
  { id: 'req2', roomId: 'r5', roomName: 'Room 105', requesterId: 'u3', requesterName: 'Ayesha (Student)', requesterRole: 'student', date: '2026-07-08', startTime: '16:00', endTime: '17:00', purpose: 'Project Presentation Practice', status: 'pending', createdAt: Date.now() - 1800000, forwardedFrom: 'Sara (CR)' },
  { id: 'req3', roomId: 'r3', roomName: 'Lab 301', requesterId: 'u1', requesterName: 'Dr. Ahmed (Teacher)', requesterRole: 'teacher', date: '2026-07-07', startTime: '10:00', endTime: '11:30', purpose: 'Extra Lab Session', status: 'approved', createdAt: Date.now() - 86400000, approvedBy: 'Dr. Ahmed' },
];

export const MOCK_NOTIFICATIONS: Notification[] = [
  { id: 'n1', title: 'Booking Approved', message: 'Lab 301 booking for July 7 has been approved.', type: 'success', timestamp: Date.now() - 3600000, read: false },
  { id: 'n2', title: '⚡ Conflict Alert', message: 'Room 105 conflict detected! Your request was approved via FCFS.', type: 'conflict', timestamp: Date.now() - 7200000, read: false },
  { id: 'n3', title: 'New Room Request', message: 'Ali Hassan forwarded a room request for your approval.', type: 'info', timestamp: Date.now() - 86400000, read: true },
];

export const DAYS = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
export const TIME_SLOTS = ['08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00'];
