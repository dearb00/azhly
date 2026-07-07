import { LayoutDashboard, Search, Calendar, BookOpen, User, Lightbulb, Settings } from "lucide-react";
import { useAppStore } from "@/stores/appStore";

interface NavItem { id: string; label: string; icon: React.ReactNode; }

const teacherTabs: NavItem[] = [
  { id: "dashboard", label: "Dashboard", icon: <LayoutDashboard size={20} /> },
  { id: "room-finder", label: "Rooms", icon: <Search size={20} /> },
  { id: "timetable", label: "Timetable", icon: <Calendar size={20} /> },
  { id: "manage", label: "Classes", icon: <Settings size={20} /> },
  { id: "profile", label: "Profile", icon: <User size={20} /> },
];

const crTabs: NavItem[] = [
  { id: "dashboard", label: "Dashboard", icon: <LayoutDashboard size={20} /> },
  { id: "room-finder", label: "Rooms", icon: <Search size={20} /> },
  { id: "timetable", label: "Timetable", icon: <Calendar size={20} /> },
  { id: "my-classes", label: "My Classes", icon: <BookOpen size={20} /> },
  { id: "profile", label: "Profile", icon: <User size={20} /> },
];

const studentTabs: NavItem[] = [
  { id: "dashboard", label: "Dashboard", icon: <LayoutDashboard size={20} /> },
  { id: "suggest", label: "Suggest", icon: <Lightbulb size={20} /> },
  { id: "timetable", label: "Timetable", icon: <Calendar size={20} /> },
  { id: "my-classes", label: "My Classes", icon: <BookOpen size={20} /> },
  { id: "profile", label: "Profile", icon: <User size={20} /> },
];

const adminTabs: NavItem[] = [
  { id: "dashboard", label: "Dashboard", icon: <LayoutDashboard size={20} /> },
  { id: "profile", label: "Profile", icon: <User size={20} /> },
];

export default function BottomNav() {
  const { currentUser, currentTab, setTab, theme } = useAppStore();
  const role = currentUser?.role;

  const tabs = role === "teacher" ? teacherTabs
    : role === "cr" ? crTabs
    : role === "student" ? studentTabs
    : adminTabs;

  const activeColor = theme === "dark" ? "#c084fc" : "#7c3aed";
  const bgStyle = theme === "dark"
    ? { background: "rgba(20,12,50,0.85)", backdropFilter: "blur(20px)", borderTop: "1px solid rgba(124,58,237,0.2)" }
    : { background: "rgba(255,255,255,0.75)", backdropFilter: "blur(20px)", borderTop: "1px solid rgba(124,58,237,0.15)" };

  return (
    <nav className="fixed bottom-0 left-0 right-0 z-30 pb-safe" style={bgStyle}>
      <div className="flex items-center justify-around px-2 py-2">
        {tabs.map((tab) => {
          const isActive = currentTab === tab.id;
          return (
            <button
              key={tab.id}
              onClick={() => setTab(tab.id)}
              className="flex flex-col items-center gap-1 px-3 py-2 rounded-xl transition-all duration-200 min-w-[56px]"
              style={isActive ? { background: theme === "dark" ? "rgba(124,58,237,0.2)" : "rgba(124,58,237,0.1)" } : {}}
            >
              <span style={{ color: isActive ? activeColor : theme === "dark" ? "rgba(180,160,220,0.6)" : "rgba(100,80,150,0.5)" }}
                className={`transition-transform duration-200 ${isActive ? "scale-110" : ""}`}>
                {tab.icon}
              </span>
              <span className="text-[10px] font-medium transition-all"
                style={{ color: isActive ? activeColor : theme === "dark" ? "rgba(180,160,220,0.5)" : "rgba(100,80,150,0.45)" }}>
                {tab.label}
              </span>
              {isActive && (
                <span className="w-1 h-1 rounded-full" style={{ background: activeColor }} />
              )}
            </button>
          );
        })}
      </div>
    </nav>
  );
}
