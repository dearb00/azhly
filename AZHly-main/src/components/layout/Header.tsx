import { Bell, User } from "lucide-react";
import { useState } from "react";
import { useAppStore } from "@/stores/appStore";
import ThemeToggle from "@/components/features/ThemeToggle";
import NotificationPanel from "@/components/features/NotificationPanel";

// Logo URLs
const LOGO_NAVY = "https://cdn-ai.onspace.ai/onspace/project/uploads/niMvJnJE5E65Sj4PFxLMBY/pasted-image-1783425459805-0.png";
const LOGO_LIGHT = "https://cdn-ai.onspace.ai/onspace/project/uploads/LRW6jxNw6QGvA28RQyhckk/pasted-image-1783425460346-1.png";

export default function Header() {
  const { notifications, theme, currentUser } = useAppStore();
  const [showNotifs, setShowNotifs] = useState(false);
  const unread = notifications.filter((n) => !n.read).length;

  // Navy logo on light mode, light logo on dark mode
  const logoSrc = theme === "light" ? LOGO_NAVY : LOGO_LIGHT;

  return (
    <header className="relative z-30 flex items-center justify-between px-4 pt-10 pb-4">
      <div className="flex items-center gap-2">
        <img src={logoSrc} alt="AZHly" className="h-10 w-10 object-contain" />
        <div>
          <span className="text-xl font-bold tracking-tight" style={{ color: theme === "dark" ? "#c084fc" : "#7c3aed" }}>
            AZHly
          </span>
          <p className="text-xs text-muted-foreground -mt-1 capitalize">{currentUser?.role} Portal</p>
        </div>
      </div>

      <div className="flex items-center gap-3">
        <ThemeToggle />

        {/* Notification Bell */}
        <button
          onClick={() => setShowNotifs((v) => !v)}
          className="relative flex items-center justify-center w-10 h-10 rounded-full transition-all duration-200 hover:scale-110"
          style={{ background: theme === "dark" ? "rgba(124,58,237,0.2)" : "rgba(124,58,237,0.12)" }}
        >
          <Bell size={18} style={{ color: theme === "dark" ? "#c084fc" : "#7c3aed" }} />
          {unread > 0 && (
            <span className="absolute -top-1 -right-1 min-w-[18px] h-[18px] rounded-full text-[10px] font-bold flex items-center justify-center text-white"
              style={{ background: "#ec4899" }}>
              {unread > 9 ? "9+" : unread}
            </span>
          )}
        </button>

        {/* Profile Avatar */}
        <div className="w-10 h-10 rounded-full flex items-center justify-center font-bold text-sm text-white overflow-hidden"
          style={{ background: "linear-gradient(135deg, #7c3aed, #ec4899)" }}>
          {currentUser?.name?.charAt(0)?.toUpperCase() || <User size={16} />}
        </div>
      </div>

      {showNotifs && <NotificationPanel onClose={() => setShowNotifs(false)} />}
    </header>
  );
}
