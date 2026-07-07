import { useEffect } from "react";
import { useAppStore } from "@/stores/appStore";
import { CheckCircle, AlertTriangle } from "lucide-react";

const LOGO_NAVY = "https://cdn-ai.onspace.ai/onspace/project/uploads/niMvJnJE5E65Sj4PFxLMBY/pasted-image-1783425459805-0.png";
const LOGO_LIGHT = "https://cdn-ai.onspace.ai/onspace/project/uploads/LRW6jxNw6QGvA28RQyhckk/pasted-image-1783425460346-1.png";

const STEPS = ["Fetching Timetable...", "Checking Conflicts...", "Allocating Room...", "Completed!"];

export default function SmartEngineModal() {
  const { smartEngineActive, smartEngineProgress, smartEngineStep, smartEngineResult, theme, dismissSmartEngine } = useAppStore();

  useEffect(() => {
    if (smartEngineResult) {
      const t = setTimeout(dismissSmartEngine, 3000);
      return () => clearTimeout(t);
    }
  }, [smartEngineResult, dismissSmartEngine]);

  if (!smartEngineActive) return null;

  // Use navy logo on light mode, light logo on dark mode (same as header)
  const logoSrc = theme === "light" ? LOGO_NAVY : LOGO_LIGHT;

  const cardBg = theme === "dark"
    ? "rgba(18,10,45,0.95)"
    : "rgba(255,255,255,0.95)";
  const borderCol = theme === "dark" ? "rgba(124,58,237,0.5)" : "rgba(124,58,237,0.3)";

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-6"
      style={{ background: "rgba(0,0,0,0.6)", backdropFilter: "blur(8px)" }}>

      <div className="w-full max-w-sm rounded-3xl p-6 animate-scaleIn shadow-2xl"
        style={{ background: cardBg, border: `1px solid ${borderCol}` }}>

        {/* Logo + Title */}
        <div className="flex flex-col items-center mb-6">
          <div className="relative mb-3">
            <img src={logoSrc} alt="AZHly" className="w-20 h-20 object-contain animate-pulseSlow" />
          </div>
          <h2 className="text-lg font-bold" style={{ color: theme === "dark" ? "#c084fc" : "#7c3aed" }}>
            Smart Engine
          </h2>
          <p className="text-xs text-muted-foreground mt-1">Processing your room request...</p>
        </div>

        {/* Progress Bar */}
        {!smartEngineResult && (
          <div className="mb-4">
            <div className="flex justify-between text-xs text-muted-foreground mb-2">
              <span>{smartEngineStep}</span>
              <span>{smartEngineProgress}%</span>
            </div>
            <div className="w-full rounded-full h-2 overflow-hidden" style={{ background: theme === "dark" ? "rgba(124,58,237,0.2)" : "rgba(124,58,237,0.12)" }}>
              <div
                className="h-full rounded-full transition-all duration-500"
                style={{
                  width: `${smartEngineProgress}%`,
                  background: "linear-gradient(90deg, #7c3aed, #ec4899)",
                }}
              />
            </div>
          </div>
        )}

        {/* Steps */}
        {!smartEngineResult && (
          <div className="space-y-2">
            {STEPS.map((step, i) => {
              const currentIdx = STEPS.indexOf(smartEngineStep);
              const done = i < currentIdx;
              const active = i === currentIdx;
              return (
                <div key={step} className="flex items-center gap-2">
                  <div className={`w-2 h-2 rounded-full transition-all duration-300 ${done ? "" : active ? "animate-pulseSlow" : "opacity-30"}`}
                    style={{ background: done ? "#10b981" : active ? "#7c3aed" : (theme === "dark" ? "rgba(255,255,255,0.3)" : "rgba(100,80,150,0.3)") }} />
                  <span className={`text-xs transition-all duration-300 ${done ? "line-through" : active ? "font-semibold" : "opacity-40"}`}
                    style={{ color: done ? "#10b981" : active ? (theme === "dark" ? "#c084fc" : "#7c3aed") : undefined }}>
                    {step}
                  </span>
                </div>
              );
            })}
          </div>
        )}

        {/* Result */}
        {smartEngineResult === "approved" && (
          <div className="flex flex-col items-center gap-2 py-4 animate-fadeIn">
            <CheckCircle size={48} className="text-green-500" />
            <p className="font-bold text-green-500 text-lg">Room Allocated!</p>
            <p className="text-xs text-muted-foreground text-center">Your booking has been confirmed successfully.</p>
          </div>
        )}
        {smartEngineResult === "conflict" && (
          <div className="flex flex-col items-center gap-2 py-4 animate-fadeIn">
            <AlertTriangle size={48} style={{ color: "#ec4899" }} />
            <p className="font-bold text-lg" style={{ color: "#ec4899" }}>Conflict Detected</p>
            <p className="text-xs text-muted-foreground text-center">Request rejected via FCFS policy. Check notifications for details.</p>
          </div>
        )}
      </div>
    </div>
  );
}
