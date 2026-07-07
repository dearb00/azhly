import { useAppStore } from "@/stores/appStore";
import { Lightbulb, BookOpen, Clock } from "lucide-react";
import RequestCard from "@/components/features/RequestCard";

export default function StudentDashboard() {
  const { requests, rooms, theme, currentUser, setTab } = useAppStore();

  const myRequests = requests.filter((r) => r.requesterRole === "student");
  const freeRooms = rooms.filter((r) => r.status === "free").length;
  const approvedCount = myRequests.filter((r) => r.status === "approved").length;

  const cardStyle = theme === "dark"
    ? { background: "rgba(255,255,255,0.05)", border: "1px solid rgba(124,58,237,0.2)" }
    : { background: "rgba(255,255,255,0.65)", border: "1px solid rgba(124,58,237,0.15)" };

  const statCard = (label: string, value: number | string, icon: React.ReactNode, color: string) => (
    <div className="flex-1 rounded-2xl p-4 flex flex-col gap-1" style={cardStyle}>
      <div className="w-8 h-8 rounded-xl flex items-center justify-center" style={{ background: `${color}20`, color }}>{icon}</div>
      <p className="text-2xl font-extrabold mt-1">{value}</p>
      <p className="text-xs text-muted-foreground">{label}</p>
    </div>
  );

  return (
    <div className="space-y-5 animate-fadeInUp">
      <div>
        <h2 className="text-xl font-extrabold">Hello, {currentUser?.name?.split(" ")[0]}! 👋</h2>
        <p className="text-sm text-muted-foreground">Track your room suggestions below</p>
      </div>

      <div className="flex gap-3">
        {statCard("My Requests", myRequests.length, <BookOpen size={16} />, "#7c3aed")}
        {statCard("Approved", approvedCount, <Clock size={16} />, "#10b981")}
        {statCard("Free Rooms", freeRooms, <Lightbulb size={16} />, "#ec4899")}
      </div>

      {/* Suggest CTA */}
      <button onClick={() => setTab("suggest")}
        className="w-full py-4 rounded-2xl text-white font-bold text-sm flex items-center justify-center gap-2 transition-all hover:opacity-90"
        style={{ background: "linear-gradient(135deg,#7c3aed,#ec4899)" }}>
        <Lightbulb size={18} />
        Suggest a Room
      </button>

      <div>
        <h3 className="font-bold text-sm mb-3">My Request History</h3>
        {myRequests.length === 0 ? (
          <div className="rounded-2xl p-6 text-center text-muted-foreground text-sm" style={cardStyle}>
            No requests yet. Suggest a room above!
          </div>
        ) : (
          <div className="space-y-3">
            {myRequests.map((r) => <RequestCard key={r.id} request={r} />)}
          </div>
        )}
      </div>
    </div>
  );
}
