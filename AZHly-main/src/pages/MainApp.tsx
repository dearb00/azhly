import { useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { useAppStore } from "@/stores/appStore";
import BubbleBackground from "@/components/layout/BubbleBackground";
import Header from "@/components/layout/Header";
import BottomNav from "@/components/layout/BottomNav";
import SmartEngineModal from "@/components/features/SmartEngineModal";

// Teacher pages
import TeacherDashboard from "./teacher/TeacherDashboard";
import RoomFinderPage from "./shared/RoomFinderPage";
import ManageClasses from "./teacher/ManageClasses";
// CR pages
import CRDashboard from "./cr/CRDashboard";
// Student pages
import StudentDashboard from "./student/StudentDashboard";
import SuggestRoom from "./student/SuggestRoom";
// Admin
import AdminDashboard from "./admin/AdminDashboard";
// Shared
import TimetablePage from "./shared/TimetablePage";
import MyClassesPage from "./shared/MyClassesPage";
import ProfilePage from "./shared/ProfilePage";

export default function MainApp() {
  const { isAuthenticated, currentUser, currentTab } = useAppStore();
  const navigate = useNavigate();

  useEffect(() => {
    if (!isAuthenticated || !currentUser) navigate("/auth");
  }, [isAuthenticated, currentUser, navigate]);

  if (!currentUser) return null;
  const role = currentUser.role;

  const renderContent = () => {
    if (currentTab === "profile") return <ProfilePage />;
    if (currentTab === "timetable") return <TimetablePage />;
    if (currentTab === "my-classes") return <MyClassesPage />;

    if (role === "teacher") {
      if (currentTab === "dashboard") return <TeacherDashboard />;
      if (currentTab === "room-finder") return <RoomFinderPage />;
      if (currentTab === "manage") return <ManageClasses />;
    }
    if (role === "cr") {
      if (currentTab === "dashboard") return <CRDashboard />;
      if (currentTab === "room-finder") return <RoomFinderPage />;
    }
    if (role === "student") {
      if (currentTab === "dashboard") return <StudentDashboard />;
      if (currentTab === "suggest") return <SuggestRoom />;
    }
    if (role === "admin") {
      return <AdminDashboard />;
    }
    return <TeacherDashboard />;
  };

  return (
    <BubbleBackground>
      <div className="min-h-screen flex flex-col pb-24">
        <Header />
        <main className="flex-1 px-4 py-2">
          {renderContent()}
        </main>
        <BottomNav />
      </div>
      <SmartEngineModal />
    </BubbleBackground>
  );
}
