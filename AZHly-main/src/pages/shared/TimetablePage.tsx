import { useAppStore } from "@/stores/appStore";
import { MOCK_TIMETABLE, DAYS } from "@/constants";
import { useState } from "react";

export default function TimetablePage() {
  const { theme } = useAppStore();
  const [activeDay, setActiveDay] = useState("Monday");

  const dayEntries = MOCK_TIMETABLE.filter((e) => e.day === activeDay);

  const cardStyle = theme === "dark"
    ? { background: "rgba(255,255,255,0.05)", border: "1px solid rgba(124,58,237,0.2)" }
    : { background: "rgba(255,255,255,0.65)", border: "1px solid rgba(124,58,237,0.15)" };

  return (
    <div className="space-y-4 animate-fadeInUp">
      <h2 className="text-xl font-extrabold">Timetable 📅</h2>

      {/* Day Selector */}
      <div className="flex gap-2 overflow-x-auto pb-1">
        {DAYS.map((day) => (
          <button key={day} onClick={() => setActiveDay(day)}
            className="flex-shrink-0 px-4 py-2 rounded-xl text-xs font-semibold transition-all"
            style={activeDay === day
              ? { background: "linear-gradient(135deg,#7c3aed,#a855f7)", color: "white" }
              : { background: theme === "dark" ? "rgba(124,58,237,0.12)" : "rgba(124,58,237,0.08)", color: theme === "dark" ? "#c084fc" : "#7c3aed" }}>
            {day.slice(0, 3)}
          </button>
        ))}
      </div>

      <p className="text-sm font-medium">{activeDay}</p>

      {dayEntries.length === 0 ? (
        <div className="rounded-2xl p-8 text-center text-muted-foreground" style={cardStyle}>
          <p className="text-2xl mb-2">🎉</p>
          <p className="text-sm">No classes scheduled</p>
        </div>
      ) : (
        <div className="space-y-3">
          {dayEntries.map((entry) => (
            <div key={entry.id} className="rounded-2xl p-4 flex gap-4 items-stretch" style={cardStyle}>
              <div className="w-1 rounded-full flex-shrink-0" style={{ background: entry.color }} />
              <div className="flex-1">
                <p className="font-bold text-sm">{entry.subject}</p>
                <p className="text-xs text-muted-foreground mt-0.5">{entry.room}</p>
                <p className="text-xs text-muted-foreground">{entry.teacher}</p>
              </div>
              <div className="flex flex-col items-end justify-center gap-1">
                <span className="text-xs font-semibold" style={{ color: entry.color }}>{entry.startTime}</span>
                <span className="text-[10px] text-muted-foreground">to {entry.endTime}</span>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Full week mini view */}
      <div>
        <h3 className="font-bold text-sm mb-3">This Week</h3>
        <div className="rounded-2xl p-4 space-y-2" style={cardStyle}>
          {DAYS.map((day) => {
            const count = MOCK_TIMETABLE.filter((e) => e.day === day).length;
            return (
              <div key={day} className="flex items-center justify-between">
                <span className="text-xs font-medium w-24">{day}</span>
                <div className="flex-1 mx-3 h-2 rounded-full overflow-hidden" style={{ background: theme === "dark" ? "rgba(124,58,237,0.15)" : "rgba(124,58,237,0.1)" }}>
                  <div className="h-full rounded-full" style={{ width: `${(count / 3) * 100}%`, background: "linear-gradient(90deg,#7c3aed,#ec4899)" }} />
                </div>
                <span className="text-xs text-muted-foreground">{count} class{count !== 1 ? "es" : ""}</span>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}
