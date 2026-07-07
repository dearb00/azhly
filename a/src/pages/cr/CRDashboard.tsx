import { useAppStore } from "@/stores/appStore";
import RequestCard from "@/components/features/RequestCard";
import { BookOpen, CheckCircle, Clock, Search } from "lucide-react";

export default function CRDashboard() {
  const { requests, rooms, theme, currentUser } = useAppStore();

  const myRequests = requests.filter((r) => r.requesterRole === "cr" || r.forwardedFrom);
  const pending = requests.filter((r) => r.status === "pending");
  const freeRooms = rooms.filter((r) => r.status === "free").length;

  const statCard = (label: string, value: number | string, icon: React.ReactNode, color: string) => (
    <div className="flex-1 rounded-2xl p-4 flex flex-col gap-1"
      style={theme === "dark"
        ? { background: "rgba(255,255,255,0.05)", border: "1px solid rgba(124,58,237,0.2)" }
        : { background: "rgba(255,255,255,0.65)", border: "1px solid rgba(124,58,237,0.15)" }}>
      <div className="w-8 h-8 rounded-xl flex items-center justify-center" style={{ background: `${color}20`, color }}>{icon}</div>
      <p className="text-2xl font-extrabold mt-1">{value}</p>
      <p className="text-xs text-muted-foreground">{label}</p>
    </div>
  );

  return (
    <div className="space-y-5 animate-fadeInUp">
      <div>
        <h2 className="text-xl font-extrabold">CR Dashboard 👋</h2>
        <p className="text-sm text-muted-foreground">{currentUser?.name}</p>
      </div>

      <div className="flex gap-3">
        {statCard("My Requests", myRequests.length, <BookOpen size={16} />, "#7c3aed")}
        {statCard("Pending", pending.length, <Clock size={16} />, "#f59e0b")}
        {statCard("Free Rooms", freeRooms, <Search size={16} />, "#10b981")}
      </div>

      <div>
        <h3 className="font-bold text-sm mb-3">Student Requests to Forward</h3>
        <div className="space-y-3">
          {requests.filter((r) => r.requesterRole === "student" && r.status === "pending").map((r) => (
            <RequestCard key={r.id} request={r} showActions />
          ))}
          {requests.filter((r) => r.requesterRole === "student" && r.status === "pending").length === 0 && (
            <div className="rounded-2xl p-6 text-center text-muted-foreground text-sm"
              style={theme === "dark" ? { background: "rgba(255,255,255,0.04)" } : { background: "rgba(255,255,255,0.5)" }}>
              No student requests pending
            </div>
          )}
        </div>
      </div>

      <div>
        <h3 className="font-bold text-sm mb-3">All Requests</h3>
        <div className="space-y-3">
          {requests.slice(0, 4).map((r) => <RequestCard key={r.id} request={r} />)}
        </div>
      </div>
    </div>
  );
}
