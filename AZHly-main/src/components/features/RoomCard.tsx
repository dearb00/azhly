import { Room } from "@/types";
import { Users, MapPin, Wifi, Monitor } from "lucide-react";
import { useAppStore } from "@/stores/appStore";

interface RoomCardProps {
  room: Room;
  onRequest?: (room: Room) => void;
  showRequest?: boolean;
}

const statusConfig = {
  free: { label: "Free", color: "#10b981", bg: "rgba(16,185,129,0.15)" },
  occupied: { label: "Occupied", color: "#ec4899", bg: "rgba(236,72,153,0.15)" },
  regular: { label: "Regular", color: "#f59e0b", bg: "rgba(245,158,11,0.15)" },
};

const facilityIcons: Record<string, React.ReactNode> = {
  "Projector": <Monitor size={12} />,
  "Smart Board": <Monitor size={12} />,
  "Computers": <Monitor size={12} />,
  "AC": <Wifi size={12} />,
};

export default function RoomCard({ room, onRequest, showRequest = true }: RoomCardProps) {
  const { theme } = useAppStore();
  const status = statusConfig[room.status];

  const cardStyle = theme === "dark"
    ? { background: "rgba(255,255,255,0.05)", border: "1px solid rgba(124,58,237,0.2)" }
    : { background: "rgba(255,255,255,0.7)", border: "1px solid rgba(124,58,237,0.18)" };

  return (
    <div className="rounded-2xl p-4 backdrop-blur-sm transition-all duration-200 hover:scale-[1.01]" style={cardStyle}>
      <div className="flex items-start justify-between mb-3">
        <div>
          <h3 className="font-bold text-base">{room.name}</h3>
          <div className="flex items-center gap-1 text-xs text-muted-foreground mt-0.5">
            <MapPin size={11} />
            <span>{room.building}, Floor {room.floor}</span>
          </div>
        </div>
        <span className="text-xs px-2.5 py-1 rounded-full font-semibold" style={{ color: status.color, background: status.bg }}>
          {status.label}
        </span>
      </div>

      <div className="flex items-center gap-1 text-xs text-muted-foreground mb-3">
        <Users size={12} />
        <span>{room.capacity} seats</span>
      </div>

      {room.currentClass && (
        <p className="text-xs mb-2 px-2 py-1 rounded-lg" style={{ background: theme === "dark" ? "rgba(236,72,153,0.1)" : "rgba(236,72,153,0.08)", color: "#ec4899" }}>
          🎓 {room.currentClass}
          {room.nextFreeAt && <span className="text-muted-foreground ml-1">· Free at {room.nextFreeAt}</span>}
        </p>
      )}

      <div className="flex flex-wrap gap-1 mb-3">
        {room.facilities.slice(0, 4).map((f) => (
          <span key={f} className="flex items-center gap-1 text-[10px] px-2 py-0.5 rounded-full"
            style={{ background: theme === "dark" ? "rgba(124,58,237,0.15)" : "rgba(124,58,237,0.1)", color: theme === "dark" ? "#c084fc" : "#7c3aed" }}>
            {facilityIcons[f] || null}{f}
          </span>
        ))}
      </div>

      {showRequest && room.status !== "occupied" && onRequest && (
        <button
          onClick={() => onRequest(room)}
          className="w-full py-2 rounded-xl text-sm font-semibold text-white transition-all duration-200 hover:opacity-90 hover:scale-[1.02] active:scale-95"
          style={{ background: "linear-gradient(135deg, #7c3aed, #a855f7)" }}>
          Request Room
        </button>
      )}
    </div>
  );
}
