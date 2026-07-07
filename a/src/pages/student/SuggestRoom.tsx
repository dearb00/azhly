import { useState } from "react";
import { useAppStore } from "@/stores/appStore";
import RoomCard from "@/components/features/RoomCard";
import { Room } from "@/types";
import { Search, X } from "lucide-react";
import { toast } from "sonner";

export default function SuggestRoom() {
  const { rooms, theme, currentUser, submitRequest } = useAppStore();
  const [query, setQuery] = useState("");
  const [selectedRoom, setSelectedRoom] = useState<Room | null>(null);
  const [date, setDate] = useState("2026-07-10");
  const [start, setStart] = useState("14:00");
  const [end, setEnd] = useState("15:30");
  const [purpose, setPurpose] = useState("");

  const filtered = rooms.filter(
    (r) => r.name.toLowerCase().includes(query.toLowerCase()) || r.building.toLowerCase().includes(query.toLowerCase())
  );

  const handleSubmit = () => {
    if (!selectedRoom || !purpose) { toast.error("Please fill in all fields."); return; }
    submitRequest({
      roomId: selectedRoom.id,
      roomName: selectedRoom.name,
      requesterId: currentUser?.id || "s1",
      requesterName: `${currentUser?.name} (Student)`,
      requesterRole: "student",
      date,
      startTime: start,
      endTime: end,
      purpose,
      forwardedFrom: "Submitted via Student Portal",
    });
    setSelectedRoom(null);
    setPurpose("");
    toast.success("Suggestion submitted! Your CR will review it.");
  };

  const inputStyle: React.CSSProperties = theme === "dark"
    ? { background: "rgba(255,255,255,0.06)", border: "1px solid rgba(124,58,237,0.3)", color: "white" }
    : { background: "rgba(255,255,255,0.7)", border: "1px solid rgba(124,58,237,0.25)", color: "#1a0a3d" };

  const cardStyle = theme === "dark"
    ? { background: "rgba(255,255,255,0.05)", border: "1px solid rgba(124,58,237,0.2)" }
    : { background: "rgba(255,255,255,0.65)", border: "1px solid rgba(124,58,237,0.18)" };

  return (
    <div className="space-y-4 animate-fadeInUp">
      <div>
        <h2 className="text-xl font-extrabold">Suggest a Room 💡</h2>
        <p className="text-xs text-muted-foreground mt-0.5">Your suggestion goes to CR → Teacher for approval</p>
      </div>

      {/* Search */}
      <div className="relative">
        <Search size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground" />
        <input
          value={query} onChange={(e) => setQuery(e.target.value)}
          placeholder="Search rooms..."
          className="w-full pl-9 pr-4 py-3 rounded-xl text-sm outline-none"
          style={inputStyle}
        />
      </div>

      {/* Selected Room */}
      {selectedRoom && (
        <div className="rounded-2xl p-4 relative" style={{ ...cardStyle, border: "1px solid rgba(124,58,237,0.5)" }}>
          <button onClick={() => setSelectedRoom(null)} className="absolute top-3 right-3 text-muted-foreground">
            <X size={14} />
          </button>
          <p className="font-bold text-sm" style={{ color: theme === "dark" ? "#c084fc" : "#7c3aed" }}>Selected: {selectedRoom.name}</p>
          <p className="text-xs text-muted-foreground">{selectedRoom.building} · {selectedRoom.capacity} seats</p>

          <div className="grid grid-cols-2 gap-2 mt-3">
            <div>
              <label className="text-xs text-muted-foreground">Date</label>
              <input type="date" value={date} onChange={(e) => setDate(e.target.value)}
                className="w-full px-3 py-2 rounded-lg text-xs mt-1 outline-none" style={inputStyle} />
            </div>
            <div>
              <label className="text-xs text-muted-foreground">Start Time</label>
              <input type="time" value={start} onChange={(e) => setStart(e.target.value)}
                className="w-full px-3 py-2 rounded-lg text-xs mt-1 outline-none" style={inputStyle} />
            </div>
            <div>
              <label className="text-xs text-muted-foreground">End Time</label>
              <input type="time" value={end} onChange={(e) => setEnd(e.target.value)}
                className="w-full px-3 py-2 rounded-lg text-xs mt-1 outline-none" style={inputStyle} />
            </div>
          </div>
          <div className="mt-2">
            <label className="text-xs text-muted-foreground">Purpose</label>
            <input value={purpose} onChange={(e) => setPurpose(e.target.value)}
              placeholder="e.g. Group study session"
              className="w-full px-3 py-2 rounded-lg text-xs mt-1 outline-none" style={inputStyle} />
          </div>
          <button onClick={handleSubmit}
            className="w-full mt-3 py-2.5 rounded-xl text-white font-bold text-sm transition-all hover:opacity-90"
            style={{ background: "linear-gradient(135deg,#7c3aed,#ec4899)" }}>
            Submit Suggestion
          </button>
        </div>
      )}

      {/* Rooms list */}
      <div className="space-y-3">
        {filtered.map((r) => (
          <RoomCard key={r.id} room={r}
            onRequest={(room) => setSelectedRoom(room)}
            showRequest={!selectedRoom} />
        ))}
      </div>
    </div>
  );
}
