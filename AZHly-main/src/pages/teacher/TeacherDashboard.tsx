import { useAppStore } from "@/stores/appStore";
import RequestCard from "@/components/features/RequestCard";
import { BookOpen, CheckCircle, Clock, Users } from "lucide-react";

export default function TeacherDashboard() {
  const { requests, rooms, theme, currentUser } = useAppStore();

  const pendingForTeacher = requests.filter((r) => r.status === "pending" && r.requesterRole !== "teacher");
  const approved = requests.filter((r) => r.status === "approved");
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
        <h2 className="text-xl font-extrabold">Good Morning 👋</h2>
        <p className="text-sm text-muted-foreground">{currentUser?.name}</p>
      </div>

      {/* Stats */}
      <div className="flex gap-3">
        {statCard("Pending Requests", pendingForTeacher.length, <Clock size={16} />, "#f59e0b")}
        {statCard("Free Rooms", freeRooms, <BookOpen size={16} />, "#10b981")}
        {statCard("Approved", approved.length, <CheckCircle size={16} />, "#7c3aed")}
      </div>

      {/* Pending Approvals */}
      <div>
        <div className="flex items-center gap-2 mb-3">
          <Users size={16} style={{ color: theme === "dark" ? "#c084fc" : "#7c3aed" }} />
          <h3 className="font-bold text-sm">Awaiting Your Approval</h3>
          {pendingForTeacher.length > 0 && (
            <span className="text-xs px-2 py-0.5 rounded-full text-white" style={{ background: "#ec4899" }}>
              {pendingForTeacher.length}
            </span>
          )}
        </div>
        {pendingForTeacher.length === 0 ? (
          <div className="rounded-2xl p-6 text-center text-muted-foreground text-sm"
            style={theme === "dark" ? { background: "rgba(255,255,255,0.04)" } : { background: "rgba(255,255,255,0.5)" }}>
            No pending requests 🎉
          </div>
        ) : (
          <div className="space-y-3">
            {pendingForTeacher.map((r) => <RequestCard key={r.id} request={r} showActions />)}
          </div>
        )}
      </div>

      {/* Recent Activity */}
      <div>
        <h3 className="font-bold text-sm mb-3">Recent Activity</h3>
        <div className="space-y-3">
          {requests.slice(0, 3).map((r) => <RequestCard key={r.id} request={r} />)}
        </div>
      </div>
    </div>
  );
}
