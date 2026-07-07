import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import { User, Role, Theme, BookingRequest, Notification, Room } from '@/types';
import { MOCK_ROOMS, MOCK_REQUESTS, MOCK_NOTIFICATIONS } from '@/constants';
import { resolveConflicts, checkTimeConflict } from '@/lib/conflictResolution';

interface AppState {
  currentUser: User | null;
  isAuthenticated: boolean;
  theme: Theme;
  currentTab: string;
  rooms: Room[];
  requests: BookingRequest[];
  notifications: Notification[];
  smartEngineActive: boolean;
  smartEngineProgress: number;
  smartEngineStep: string;
  smartEngineResult: 'approved' | 'conflict' | null;
  pendingRequestId: string | null;
  login: (name: string, email: string, role: Role) => void;
  logout: () => void;
  setRole: (role: Role) => void;
  toggleTheme: () => void;
  setTab: (tab: string) => void;
  submitRequest: (req: Omit<BookingRequest, 'id' | 'status' | 'createdAt'>) => void;
  approveRequest: (id: string) => void;
  rejectRequest: (id: string, reason: string) => void;
  markAllRead: () => void;
  dismissSmartEngine: () => void;
}

export const useAppStore = create<AppState>()(
  persist(
    (set, get) => ({
      currentUser: null,
      isAuthenticated: false,
      theme: 'dark',
      currentTab: 'dashboard',
      rooms: MOCK_ROOMS,
      requests: MOCK_REQUESTS,
      notifications: MOCK_NOTIFICATIONS,
      smartEngineActive: false,
      smartEngineProgress: 0,
      smartEngineStep: '',
      smartEngineResult: null,
      pendingRequestId: null,

      login: (name, email, role) => {
        const user: User = { id: `u_${Date.now()}`, name, email, role };
        set({ currentUser: user, isAuthenticated: true, currentTab: 'dashboard' });
      },

      logout: () => set({ currentUser: null, isAuthenticated: false, currentTab: 'dashboard' }),

      setRole: (role) =>
        set((s) => ({ currentUser: s.currentUser ? { ...s.currentUser, role } : null })),

      toggleTheme: () =>
        set((s) => ({ theme: s.theme === 'dark' ? 'light' : 'dark' })),

      setTab: (tab) => set({ currentTab: tab }),

      submitRequest: (reqData) => {
        const { requests } = get();
        const hasConflict = checkTimeConflict(requests, reqData);
        const newReq: BookingRequest = {
          ...reqData,
          id: `req_${Date.now()}`,
          status: 'pending',
          createdAt: Date.now(),
        };

        set({
          smartEngineActive: true,
          smartEngineProgress: 0,
          smartEngineStep: 'Fetching Timetable...',
          smartEngineResult: null,
          pendingRequestId: newReq.id,
        });

        const steps = [
          { label: 'Fetching Timetable...', progress: 25 },
          { label: 'Checking Conflicts...', progress: 55 },
          { label: 'Allocating Room...', progress: 80 },
          { label: 'Completed!', progress: 100 },
        ];

        let i = 0;
        const interval = setInterval(() => {
          if (i < steps.length) {
            set({ smartEngineStep: steps[i].label, smartEngineProgress: steps[i].progress });
            i++;
          } else {
            clearInterval(interval);
            const allRequests = [...get().requests, newReq];
            const resolved = resolveConflicts(allRequests);
            const result = resolved.find((r) => r.id === newReq.id);
            const isConflict = hasConflict || result?.status === 'rejected';

            const notification: Notification = isConflict
              ? {
                  id: `n_${Date.now()}`,
                  title: '⚡ Conflict Alert',
                  message: `Room ${reqData.roomName} conflict! Request rejected via FCFS policy.`,
                  type: 'conflict',
                  timestamp: Date.now(),
                  read: false,
                }
              : {
                  id: `n_${Date.now()}`,
                  title: '✅ Room Allocated',
                  message: `${reqData.roomName} successfully allocated for ${reqData.date} ${reqData.startTime}.`,
                  type: 'success',
                  timestamp: Date.now(),
                  read: false,
                };

            set((s) => ({
              requests: resolved,
              notifications: [notification, ...s.notifications],
              smartEngineResult: isConflict ? 'conflict' : 'approved',
              rooms: s.rooms.map((r) =>
                r.id === reqData.roomId && !isConflict ? { ...r, status: 'occupied' as const } : r
              ),
            }));
          }
        }, 1000);
      },

      approveRequest: (id) =>
        set((s) => ({
          requests: s.requests.map((r) =>
            r.id === id ? { ...r, status: 'approved' as const, approvedBy: s.currentUser?.name } : r
          ),
          notifications: [
            {
              id: `n_${Date.now()}`,
              title: 'Request Approved',
              message: `Room booking approved by ${s.currentUser?.name}`,
              type: 'success',
              timestamp: Date.now(),
              read: false,
            },
            ...s.notifications,
          ],
        })),

      rejectRequest: (id, reason) =>
        set((s) => ({
          requests: s.requests.map((r) =>
            r.id === id ? { ...r, status: 'rejected' as const, rejectionReason: reason } : r
          ),
        })),

      markAllRead: () =>
        set((s) => ({ notifications: s.notifications.map((n) => ({ ...n, read: true })) })),

      dismissSmartEngine: () =>
        set({ smartEngineActive: false, smartEngineResult: null, pendingRequestId: null }),
    }),
    {
      name: 'azhly-store',
      partialize: (s) => ({
        theme: s.theme,
        currentUser: s.currentUser,
        isAuthenticated: s.isAuthenticated,
      }),
    }
  )
);
