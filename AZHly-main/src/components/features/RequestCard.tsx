import { BookingRequest } from "@/types";
import { useAppStore } from "@/stores/appStore";
import { Clock, MapPin, User } from "lucide-react";

interface RequestCardProps {
  request: BookingRequest;
  showActions?: boolean;
}

const statusConfig = {
  pending: { label: "Pending", color: "#f59e0b", bg: "rgba(245,158,11,0.15)" },
  approved: { label: "Approved", color: "#10b981", bg: "rgba(16,185,129,0.15)" },
  rejected: { label: "Rejected", color: "#ef4444", bg: "rgba(239,68,68,0.15)" },
  conflict: { label: "Conflict", color: "#ec4899", bg: "rgba(236,72,153,0.15)" },
};

export default function RequestCard({ request, showActions = false }: RequestCardProps) {
  const { theme, approveRequest, rejectRequest } = useAppStore();
  const status = statusConfig[request.status];

  const cardStyle = theme === "dark"
    ? { background: "rgba(255,255,255,0.05)", border: "1px solid rgba(124,58,237,0.2)" }
    : { background: "rgba(255,255,255,0.7)", border: "1px solid rgba(124,58,237,0.15)" };

  return (
    <div className="rounded-2xl p-4 backdrop-blur-sm" style={cardStyle}>
      <div className="flex items-start justify-between mb-2">
        <div className="flex items-center gap-2">
          <MapPin size={14} style={{ color: theme === "dark" ? "#c084fc" : "#7c3aed" }} />
          <span className="font-semibold text-sm">{request.roomName}</span>
        </div>
        <span className="text-xs px-2 py-0.5 rounded-full font-medium" style={{ color: status.color, background: status.bg }}>
          {status.label}
        </span>
      </div>

      <div className="space-y-1 text-xs text-muted-foreground mb-3">
        <div className="flex items-center gap-1"><User size={11} /><span>{request.requesterName}</span></div>
        <div className="flex items-center gap-1"><Clock size={11} />
          <span>{request.date} · {request.startTime} – {request.endTime}</span>
        </div>
        <p className="italic">{request.purpose}</p>
        {request.forwardedFrom && <p className="text-[10px] opacity-70">Forwarded by: {request.forwardedFrom}</p>}
        {request.rejectionReason && <p className="text-[10px] text-red-400">{request.rejectionReason}</p>}
        {request.approvedBy && <p className="text-[10px] text-green-400">Approved by: {request.approvedBy}</p>}
      </div>

      {showActions && request.status === "pending" && (
        <div className="flex gap-2">
          <button onClick={() => approveRequest(request.id)}
            className="flex-1 py-2 rounded-xl text-xs font-semibold text-white transition-all hover:opacity-90"
            style={{ background: "linear-gradient(135deg, #7c3aed, #a855f7)" }}>
            Approve
          </button>
          <button onClick={() => rejectRequest(request.id, "Declined by reviewer.")}
            className="flex-1 py-2 rounded-xl text-xs font-semibold transition-all hover:opacity-90"
            style={{ background: theme === "dark" ? "rgba(239,68,68,0.2)" : "rgba(239,68,68,0.12)", color: "#ef4444", border: "1px solid rgba(239,68,68,0.3)" }}>
            Reject
          </button>
        </div>
      )}
    </div>
  );
}
