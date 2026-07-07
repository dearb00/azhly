import { BookingRequest } from '@/types';

export function resolveConflicts(requests: BookingRequest[]): BookingRequest[] {
  const grouped: Record<string, BookingRequest[]> = {};

  requests.forEach((req) => {
    const key = `${req.roomId}_${req.date}_${req.startTime}_${req.endTime}`;
    if (!grouped[key]) grouped[key] = [];
    grouped[key].push(req);
  });

  const resolved: BookingRequest[] = [];

  Object.values(grouped).forEach((group) => {
    if (group.length === 1) {
      resolved.push(group[0]);
    } else {
      // FCFS: sort by createdAt ascending
      const sorted = [...group].sort((a, b) => a.createdAt - b.createdAt);
      sorted.forEach((req, idx) => {
        if (idx === 0) {
          resolved.push({ ...req, status: 'approved', approvedBy: 'Smart Engine (FCFS)' });
        } else {
          resolved.push({
            ...req,
            status: 'rejected',
            rejectionReason: `Conflict: Room already allocated to ${sorted[0].requesterName} via First-Come-First-Served policy.`,
          });
        }
      });
    }
  });

  return resolved;
}

export function checkTimeConflict(
  existingRequests: BookingRequest[],
  newRequest: Omit<BookingRequest, 'id' | 'status' | 'createdAt'>
): boolean {
  return existingRequests.some((req) => {
    if (req.roomId !== newRequest.roomId || req.date !== newRequest.date) return false;
    if (req.status === 'rejected') return false;
    const newStart = timeToMinutes(newRequest.startTime);
    const newEnd = timeToMinutes(newRequest.endTime);
    const existStart = timeToMinutes(req.startTime);
    const existEnd = timeToMinutes(req.endTime);
    return newStart < existEnd && newEnd > existStart;
  });
}

function timeToMinutes(time: string): number {
  const [h, m] = time.split(':').map(Number);
  return h * 60 + m;
}
