export type Role = 'teacher' | 'cr' | 'student' | 'admin';
export type Theme = 'light' | 'dark';
export type RoomStatus = 'free' | 'occupied' | 'regular';
export type RequestStatus = 'pending' | 'approved' | 'rejected' | 'conflict';

export interface User {
  id: string;
  name: string;
  email: string;
  role: Role;
  avatar?: string;
  department?: string;
}

export interface Room {
  id: string;
  name: string;
  building: string;
  floor: number;
  capacity: number;
  status: RoomStatus;
  facilities: string[];
  currentClass?: string;
  nextFreeAt?: string;
}

export interface BookingRequest {
  id: string;
  roomId: string;
  roomName: string;
  requesterId: string;
  requesterName: string;
  requesterRole: Role;
  date: string;
  startTime: string;
  endTime: string;
  purpose: string;
  status: RequestStatus;
  createdAt: number;
  forwardedFrom?: string;
  rejectionReason?: string;
  approvedBy?: string;
}

export interface Notification {
  id: string;
  title: string;
  message: string;
  type: 'info' | 'success' | 'error' | 'warning' | 'conflict';
  timestamp: number;
  read: boolean;
}

export interface SmartEngineStep {
  label: string;
  done: boolean;
}

export interface TimetableEntry {
  id: string;
  subject: string;
  room: string;
  teacher: string;
  day: string;
  startTime: string;
  endTime: string;
  color: string;
}
