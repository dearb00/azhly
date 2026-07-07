import { useAppStore } from "@/stores/appStore";
import { MOCK_TIMETABLE } from "@/constants";
import { BookOpen, Edit3, Trash2, Plus } from "lucide-react";
import { useState } from "react";

export default function ManageClasses() {
  const { theme } = useAppStore();
  const [classes] = useState(MOCK_TIMETABLE);

  const cardStyle = theme === "dark"
    ? { background: "rgba(255,255,255,0.05)", border: "1px solid rgba(124,58,237,0.2)" }
    : { background: "rgba(255,255,255,0.65)", border: "1px solid rgba(124,58,237,0.15)" };

  return (
    <div className="space-y-4 animate-fadeInUp">
      <div className="flex items-center justify-between">
        <h2 className="text-xl font-extrabold">Manage Classes</h2>
        <button className="flex items-center gap-1 px-3 py-2 rounded-xl text-xs font-semibold text-white"
          style={{ background: "linear-gradient(135deg,#7c3aed,#a855f7)" }}>
          <Plus size={14} /> New Class
        </button>
      </div>

      <div className="space-y-3">
        {classes.map((c) => (
          <div key={c.id} className="rounded-2xl p-4" style={cardStyle}>
            <div className="flex items-start justify-between">
              <div className="flex items-center gap-3">
                <div className="w-3 h-12 rounded-full flex-shrink-0" style={{ background: c.color }} />
                <div>
                  <p className="font-bold text-sm">{c.subject}</p>
                  <p className="text-xs text-muted-foreground">{c.room}</p>
                  <p className="text-xs text-muted-foreground">{c.day} · {c.startTime}–{c.endTime}</p>
                </div>
              </div>
              <div className="flex gap-2">
                <button className="w-8 h-8 rounded-lg flex items-center justify-center text-muted-foreground hover:text-foreground transition-colors"
                  style={{ background: theme === "dark" ? "rgba(255,255,255,0.06)" : "rgba(0,0,0,0.05)" }}>
                  <Edit3 size={14} />
                </button>
                <button className="w-8 h-8 rounded-lg flex items-center justify-center transition-colors"
                  style={{ background: "rgba(239,68,68,0.12)", color: "#ef4444" }}>
                  <Trash2 size={14} />
                </button>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
