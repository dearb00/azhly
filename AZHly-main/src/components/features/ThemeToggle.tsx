import { useAppStore } from "@/stores/appStore";
import { Sun, Moon } from "lucide-react";

export default function ThemeToggle() {
  const { theme, toggleTheme } = useAppStore();

  return (
    <button
      onClick={toggleTheme}
      className="flex items-center gap-1.5 px-3 py-1.5 rounded-full transition-all duration-300 hover:scale-105"
      style={theme === "dark"
        ? { background: "rgba(124,58,237,0.25)", border: "1px solid rgba(124,58,237,0.4)" }
        : { background: "rgba(124,58,237,0.12)", border: "1px solid rgba(124,58,237,0.3)" }
      }
    >
      {theme === "dark" ? (
        <>
          <Sun size={14} style={{ color: "#c084fc" }} />
          <span className="text-xs font-medium" style={{ color: "#c084fc" }}>Light</span>
        </>
      ) : (
        <>
          <Moon size={14} style={{ color: "#7c3aed" }} />
          <span className="text-xs font-medium" style={{ color: "#7c3aed" }}>Dark</span>
        </>
      )}
    </button>
  );
}
