import { useNavigate } from "react-router-dom";
import { useAppStore } from "@/stores/appStore";
import BubbleBackground from "@/components/layout/BubbleBackground";
import ThemeToggle from "@/components/features/ThemeToggle";
import { GraduationCap, Users, User, ShieldCheck } from "lucide-react";
import { Role } from "@/types";

const LOGO_NAVY = "https://cdn-ai.onspace.ai/onspace/project/uploads/niMvJnJE5E65Sj4PFxLMBY/pasted-image-1783425459805-0.png";
const LOGO_LIGHT = "https://cdn-ai.onspace.ai/onspace/project/uploads/LRW6jxNw6QGvA28RQyhckk/pasted-image-1783425460346-1.png";

const roles: { id: Role; label: string; desc: string; icon: React.ReactNode; gradient: string }[] = [
  { id: "teacher", label: "Teacher", desc: "Manage classes & approve bookings", icon: <GraduationCap size={28} />, gradient: "linear-gradient(135deg,#7c3aed,#a855f7)" },
  { id: "cr", label: "CR / GR", desc: "Class rep — forward & manage requests", icon: <Users size={28} />, gradient: "linear-gradient(135deg,#a855f7,#ec4899)" },
  { id: "student", label: "Student", desc: "Suggest rooms through your CR", icon: <User size={28} />, gradient: "linear-gradient(135deg,#ec4899,#f97316)" },
  { id: "admin", label: "Admin", desc: "View reports & analytics only", icon: <ShieldCheck size={28} />, gradient: "linear-gradient(135deg,#3b82f6,#7c3aed)" },
];

export default function RoleSelection() {
  const { setRole, currentUser, theme } = useAppStore();
  const navigate = useNavigate();
  const logoSrc = theme === "light" ? LOGO_NAVY : LOGO_LIGHT;

  const handleSelect = (role: Role) => {
    setRole(role);
    navigate("/app");
  };

  const cardStyle = (gradient: string) => theme === "dark"
    ? { background: "rgba(255,255,255,0.05)", border: "1px solid rgba(124,58,237,0.25)", backdropFilter: "blur(16px)" }
    : { background: "rgba(255,255,255,0.65)", border: "1px solid rgba(124,58,237,0.18)", backdropFilter: "blur(16px)" };

  return (
    <BubbleBackground>
      <div className="min-h-screen flex flex-col">
        <div className="flex justify-end p-4"><ThemeToggle /></div>

        <div className="flex-1 flex flex-col items-center px-6 pb-12">
          <div className="animate-fadeInUp text-center mb-8">
            <img src={logoSrc} alt="AZHly" className="w-16 h-16 object-contain mx-auto mb-4" />
            <h2 className="text-2xl font-extrabold">Welcome, {currentUser?.name?.split(" ")[0]}!</h2>
            <p className="text-muted-foreground text-sm mt-1">Select your role to continue</p>
          </div>

          <div className="w-full max-w-sm space-y-3 animate-fadeInUp">
            {roles.map((r, i) => (
              <button key={r.id}
                onClick={() => handleSelect(r.id)}
                className="w-full flex items-center gap-4 p-4 rounded-2xl text-left transition-all duration-200 hover:scale-[1.02] active:scale-95"
                style={{ ...cardStyle(r.gradient), animationDelay: `${i * 0.1}s` }}>
                <div className="w-14 h-14 rounded-2xl flex items-center justify-center text-white flex-shrink-0"
                  style={{ background: r.gradient }}>
                  {r.icon}
                </div>
                <div>
                  <p className="font-bold">{r.label}</p>
                  <p className="text-xs text-muted-foreground">{r.desc}</p>
                </div>
                <div className="ml-auto">
                  <div className="w-6 h-6 rounded-full flex items-center justify-center"
                    style={{ background: theme === "dark" ? "rgba(124,58,237,0.2)" : "rgba(124,58,237,0.12)" }}>
                    <span style={{ color: theme === "dark" ? "#c084fc" : "#7c3aed" }}>›</span>
                  </div>
                </div>
              </button>
            ))}
          </div>
        </div>
      </div>
    </BubbleBackground>
  );
}
