import { useAppStore } from "@/stores/appStore";
import { Bell, X, CheckCheck } from "lucide-react";
import { formatDistanceToNow } from "date-fns";

interface NotificationPanelProps {
  onClose: () => void;
}

const typeColors = {
  info: "#7c3aed",
  success: "#10b981",
  error: "#ef4444",
  warning: "#f59e0b",
  conflict: "#ec4899",
};

const typeIcons = {
  info: "ℹ️",
  success: "✅",
  error: "❌",
  warning: "⚠️",
  conflict: "⚡",
};

export default function NotificationPanel({ onClose }: NotificationPanelProps) {
  const { notifications, markAllRead, theme } = useAppStore();

  const panelStyle = theme === "dark"
    ? { background: "rgba(15,8,40,0.97)", border: "1px solid rgba(124,58,237,0.35)" }
    : { background: "rgba(255,255,255,0.97)", border: "1px solid rgba(124,58,237,0.2)" };

  return (
    <div className="absolute right-4 top-20 w-80 rounded-2xl shadow-2xl z-50 overflow-hidden animate-scaleIn" style={panelStyle}>
      <div className="flex items-center justify-between px-4 py-3" style={{ borderBottom: theme === "dark" ? "1px solid rgba(124,58,237,0.2)" : "1px solid rgba(124,58,237,0.12)" }}>
        <div className="flex items-center gap-2">
          <Bell size={16} style={{ color: theme === "dark" ? "#c084fc" : "#7c3aed" }} />
          <span className="font-bold text-sm">Notifications</span>
        </div>
        <div className="flex items-center gap-2">
          <button onClick={markAllRead} className="text-xs text-muted-foreground hover:text-foreground flex items-center gap-1">
            <CheckCheck size={13} /> All read
          </button>
          <button onClick={onClose} className="text-muted-foreground hover:text-foreground">
            <X size={16} />
          </button>
        </div>
      </div>

      <div className="overflow-y-auto max-h-80">
        {notifications.length === 0 && (
          <div className="p-6 text-center text-muted-foreground text-sm">No notifications</div>
        )}
        {notifications.map((n) => (
          <div key={n.id} className="px-4 py-3 transition-colors"
            style={{
              background: !n.read ? (theme === "dark" ? "rgba(124,58,237,0.08)" : "rgba(124,58,237,0.05)") : "transparent",
              borderBottom: theme === "dark" ? "1px solid rgba(255,255,255,0.04)" : "1px solid rgba(0,0,0,0.04)"
            }}>
            <div className="flex items-start gap-2">
              <span className="text-base flex-shrink-0 mt-0.5">{typeIcons[n.type]}</span>
              <div className="flex-1 min-w-0">
                <p className="text-xs font-semibold" style={{ color: typeColors[n.type] }}>{n.title}</p>
                <p className="text-xs text-muted-foreground mt-0.5 leading-relaxed">{n.message}</p>
                <p className="text-[10px] text-muted-foreground mt-1 opacity-60">
                  {formatDistanceToNow(new Date(n.timestamp), { addSuffix: true })}
                </p>
              </div>
              {!n.read && <div className="w-2 h-2 rounded-full flex-shrink-0 mt-1" style={{ background: typeColors[n.type] }} />}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
