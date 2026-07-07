import { useAppStore } from "@/stores/appStore";
import { useNavigate } from "react-router-dom";
import { User, Mail, Building, LogOut, ChevronRight, Shield } from "lucide-react";
import ThemeToggle from "@/components/features/ThemeToggle";

const LOGO_NAVY = "https://cdn-ai.onspace.ai/onspace/project/uploads/niMvJnJE5E65Sj4PFxLMBY/pasted-image-1783425459805-0.png";
const LOGO_LIGHT = "https://cdn-ai.onspace.ai/onspace/project/uploads/LRW6jxNw6QGvA28RQyhckk/pasted-image-1783425460346-1.png";

const roleLabels: Record<string, string> = {
  teacher: "Teacher",
  cr: "Class Representative",
  student: "Student",
  admin: "Administrator",
};

export default function ProfilePage() {
  const { currentUser, logout, theme, requests, notifications } = useAppStore();
  const navigate = useNavigate();

  const logoSrc = theme === "light" ? LOGO_NAVY : LOGO_LIGHT;

  const handleLogout = () => {
    logout();
    navigate("/auth");
  };

  const cardStyle = theme === "dark"
    ? { background: "rgba(255,255,255,0.05)", border: "1px solid rgba(124,58,237,0.2)" }
    : { background: "rgba(255,255,255,0.65)", border: "1px solid rgba(124,58,237,0.15)" };

  const menuItem = (icon: React.ReactNode, label: string, value?: string) => (
    <div className="flex items-center gap-3 py-3" style={{ borderBottom: theme === "dark" ? "1px solid rgba(255,255,255,0.05)" : "1px solid rgba(0,0,0,0.05)" }}>
      <div className="w-8 h-8 rounded-xl flex items-center justify-center" style={{ background: theme === "dark" ? "rgba(124,58,237,0.15)" : "rgba(124,58,237,0.1)" }}>
        <span style={{ color: theme === "dark" ? "#c084fc" : "#7c3aed" }}>{icon}</span>
      </div>
      <div className="flex-1">
        <p className="text-xs text-muted-foreground">{label}</p>
        <p className="text-sm font-medium">{value || "—"}</p>
      </div>
      <ChevronRight size={14} className="text-muted-foreground" />
    </div>
  );

  return (
    <div className="space-y-5 animate-fadeInUp">
      {/* Avatar Card */}
      <div className="rounded-3xl p-6 flex flex-col items-center gap-3" style={cardStyle}>
        <div className="w-20 h-20 rounded-full flex items-center justify-center text-white text-3xl font-extrabold"
          style={{ background: "linear-gradient(135deg,#7c3aed,#ec4899)" }}>
          {currentUser?.name?.charAt(0).toUpperCase()}
        </div>
        <div className="text-center">
          <h2 className="text-xl font-extrabold">{currentUser?.name}</h2>
          <p className="text-sm text-muted-foreground">{currentUser?.email}</p>
          <span className="text-xs px-3 py-1 rounded-full font-semibold mt-2 inline-block"
            style={{ background: "linear-gradient(135deg,#7c3aed,#a855f7)", color: "white" }}>
            {roleLabels[currentUser?.role || "student"]}
          </span>
        </div>

        <div className="flex gap-6 mt-2">
          {[
            { label: "Requests", value: requests.length },
            { label: "Notifications", value: notifications.length },
            { label: "Unread", value: notifications.filter((n) => !n.read).length },
          ].map((stat) => (
            <div key={stat.label} className="text-center">
              <p className="text-xl font-extrabold" style={{ color: theme === "dark" ? "#c084fc" : "#7c3aed" }}>{stat.value}</p>
              <p className="text-[10px] text-muted-foreground">{stat.label}</p>
            </div>
          ))}
        </div>
      </div>

      {/* Details */}
      <div className="rounded-2xl px-4" style={cardStyle}>
        {menuItem(<User size={15} />, "Full Name", currentUser?.name)}
        {menuItem(<Mail size={15} />, "Email", currentUser?.email)}
        {menuItem(<Shield size={15} />, "Role", roleLabels[currentUser?.role || "student"])}
        {menuItem(<Building size={15} />, "Department", currentUser?.department || "Computer Science")}
      </div>

      {/* Theme */}
      <div className="rounded-2xl p-4 flex items-center justify-between" style={cardStyle}>
        <p className="font-medium text-sm">Appearance</p>
        <ThemeToggle />
      </div>

      {/* App info */}
      <div className="rounded-2xl p-4 flex items-center gap-3" style={cardStyle}>
        <img src={logoSrc} alt="AZHly" className="w-10 h-10 object-contain" />
        <div>
          <p className="font-bold text-sm">AZHly v1.0</p>
          <p className="text-xs text-muted-foreground">Smart Room Booking & Management</p>
        </div>
      </div>

      {/* Logout */}
      <button onClick={handleLogout}
        className="w-full py-3.5 rounded-2xl font-bold text-sm flex items-center justify-center gap-2 transition-all hover:opacity-90"
        style={{ background: "rgba(239,68,68,0.12)", color: "#ef4444", border: "1px solid rgba(239,68,68,0.25)" }}>
        <LogOut size={16} />
        Sign Out
      </button>
    </div>
  );
}
