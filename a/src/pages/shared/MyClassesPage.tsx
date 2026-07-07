import { useAppStore } from "@/stores/appStore";
import { MOCK_TIMETABLE } from "@/constants";
import { Clock, MapPin } from "lucide-react";

export default function MyClassesPage() {
  const { theme } = useAppStore();

  const cardStyle = theme === "dark"
    ? { background: "rgba(255,255,255,0.05)", border: "1px solid rgba(124,58,237,0.2)" }
    : { background: "rgba(255,255,255,0.65)", border: "1px solid rgba(124,58,237,0.15)" };

  return (
    <div className="space-y-4 animate-fadeInUp">
      <h2 className="text-xl font-extrabold">My Classes 📚</h2>
      <p className="text-sm text-muted-foreground">{MOCK_TIMETABLE.length} classes enrolled</p>

      <div className="space-y-3">
        {MOCK_TIMETABLE.map((c) => (
          <div key={c.id} className="rounded-2xl p-4" style={cardStyle}>
            <div className="flex items-center gap-3">
              <div className="w-12 h-12 rounded-2xl flex items-center justify-center text-white font-bold text-lg flex-shrink-0"
                style={{ background: c.color }}>
                {c.subject.charAt(0)}
              </div>
              <div className="flex-1">
                <p className="font-bold text-sm">{c.subject}</p>
                <div className="flex items-center gap-3 mt-0.5">
                  <span className="flex items-center gap-1 text-xs text-muted-foreground">
                    <MapPin size={11} />{c.room}
                  </span>
                  <span className="flex items-center gap-1 text-xs text-muted-foreground">
                    <Clock size={11} />{c.startTime}–{c.endTime}
                  </span>
                </div>
                <p className="text-xs text-muted-foreground mt-0.5">{c.day}</p>
              </div>
              <div className="text-right">
                <span className="text-xs px-2 py-1 rounded-full font-medium" style={{ background: `${c.color}20`, color: c.color }}>
                  {c.day.slice(0, 3)}
                </span>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
