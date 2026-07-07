import { useAppStore } from "@/stores/appStore";
import { BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer, PieChart, Pie, Cell } from "recharts";
import { TrendingUp, Users, BookOpen, AlertTriangle } from "lucide-react";

const bookingData = [
  { day: "Mon", bookings: 12, conflicts: 2 },
  { day: "Tue", bookings: 8, conflicts: 1 },
  { day: "Wed", bookings: 15, conflicts: 3 },
  { day: "Thu", bookings: 6, conflicts: 0 },
  { day: "Fri", bookings: 10, conflicts: 1 },
];

const roomUsage = [
  { name: "Free", value: 5, color: "#10b981" },
  { name: "Occupied", value: 2, color: "#ec4899" },
  { name: "Regular", value: 1, color: "#f59e0b" },
];

export default function AdminDashboard() {
  const { theme, rooms, requests } = useAppStore();

  const totalBookings = requests.length;
  const conflicts = requests.filter((r) => r.status === "rejected").length;
  const approvedCount = requests.filter((r) => r.status === "approved").length;
  const freeRooms = rooms.filter((r) => r.status === "free").length;

  const cardStyle = theme === "dark"
    ? { background: "rgba(255,255,255,0.05)", border: "1px solid rgba(124,58,237,0.2)" }
    : { background: "rgba(255,255,255,0.65)", border: "1px solid rgba(124,58,237,0.15)" };

  const tooltipStyle = {
    backgroundColor: theme === "dark" ? "rgba(15,8,40,0.95)" : "rgba(255,255,255,0.95)",
    border: "1px solid rgba(124,58,237,0.3)",
    borderRadius: "12px",
    color: theme === "dark" ? "white" : "#1a0a3d",
  };

  const statCards = [
    { label: "Total Requests", value: totalBookings, icon: <BookOpen size={16} />, color: "#7c3aed" },
    { label: "Conflicts (FCFS)", value: conflicts, icon: <AlertTriangle size={16} />, color: "#ec4899" },
    { label: "Approved", value: approvedCount, icon: <TrendingUp size={16} />, color: "#10b981" },
    { label: "Free Rooms", value: freeRooms, icon: <Users size={16} />, color: "#f59e0b" },
  ];

  return (
    <div className="space-y-5 animate-fadeInUp">
      <div>
        <h2 className="text-xl font-extrabold">Admin Analytics 📊</h2>
        <p className="text-xs text-muted-foreground mt-0.5">System is self-governing. Reports only.</p>
      </div>

      {/* Stat cards */}
      <div className="grid grid-cols-2 gap-3">
        {statCards.map((s) => (
          <div key={s.label} className="rounded-2xl p-4" style={cardStyle}>
            <div className="w-8 h-8 rounded-xl flex items-center justify-center mb-2" style={{ background: `${s.color}20`, color: s.color }}>
              {s.icon}
            </div>
            <p className="text-2xl font-extrabold">{s.value}</p>
            <p className="text-xs text-muted-foreground">{s.label}</p>
          </div>
        ))}
      </div>

      {/* Bar chart */}
      <div className="rounded-2xl p-4" style={cardStyle}>
        <h3 className="font-bold text-sm mb-4">Weekly Booking Activity</h3>
        <ResponsiveContainer width="100%" height={180}>
          <BarChart data={bookingData} barSize={12}>
            <XAxis dataKey="day" tick={{ fontSize: 11, fill: theme === "dark" ? "#8b7fb5" : "#9080b0" }} axisLine={false} tickLine={false} />
            <YAxis hide />
            <Tooltip contentStyle={tooltipStyle} cursor={{ fill: "rgba(124,58,237,0.08)" }} />
            <Bar dataKey="bookings" fill="#7c3aed" radius={[6, 6, 0, 0]} />
            <Bar dataKey="conflicts" fill="#ec4899" radius={[6, 6, 0, 0]} />
          </BarChart>
        </ResponsiveContainer>
        <div className="flex gap-4 mt-2">
          {[{ color: "#7c3aed", label: "Bookings" }, { color: "#ec4899", label: "Conflicts" }].map((l) => (
            <div key={l.label} className="flex items-center gap-1.5">
              <div className="w-2.5 h-2.5 rounded-sm" style={{ background: l.color }} />
              <span className="text-xs text-muted-foreground">{l.label}</span>
            </div>
          ))}
        </div>
      </div>

      {/* Pie chart */}
      <div className="rounded-2xl p-4" style={cardStyle}>
        <h3 className="font-bold text-sm mb-4">Room Status Overview</h3>
        <div className="flex items-center gap-4">
          <ResponsiveContainer width={120} height={120}>
            <PieChart>
              <Pie data={roomUsage} cx="50%" cy="50%" innerRadius={35} outerRadius={55} dataKey="value" strokeWidth={0}>
                {roomUsage.map((entry, i) => <Cell key={i} fill={entry.color} />)}
              </Pie>
            </PieChart>
          </ResponsiveContainer>
          <div className="space-y-2">
            {roomUsage.map((r) => (
              <div key={r.name} className="flex items-center gap-2">
                <div className="w-2.5 h-2.5 rounded-full" style={{ background: r.color }} />
                <span className="text-xs">{r.name}</span>
                <span className="text-xs font-bold ml-auto" style={{ color: r.color }}>{r.value}</span>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* FCFS Log */}
      <div className="rounded-2xl p-4" style={cardStyle}>
        <h3 className="font-bold text-sm mb-3">FCFS Resolution Log</h3>
        <div className="space-y-2">
          {requests.filter((r) => r.status === "rejected" && r.rejectionReason).map((r) => (
            <div key={r.id} className="rounded-xl p-3 text-xs" style={{ background: "rgba(236,72,153,0.1)", border: "1px solid rgba(236,72,153,0.2)" }}>
              <p className="font-semibold" style={{ color: "#ec4899" }}>⚡ Conflict – {r.roomName}</p>
              <p className="text-muted-foreground mt-0.5">{r.rejectionReason}</p>
            </div>
          ))}
          {requests.filter((r) => r.status === "rejected").length === 0 && (
            <p className="text-muted-foreground text-xs text-center py-3">No conflicts recorded</p>
          )}
        </div>
      </div>
    </div>
  );
}
