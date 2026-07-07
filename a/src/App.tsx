import { Toaster } from "@/components/ui/toaster";
import { Toaster as Sonner } from "@/components/ui/sonner";
import { TooltipProvider } from "@/components/ui/tooltip";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import { useEffect } from "react";
import { useAppStore } from "@/stores/appStore";
import SplashScreen from "./pages/SplashScreen";
import Auth from "./pages/Auth";
import RoleSelection from "./pages/RoleSelection";
import MainApp from "./pages/MainApp";
import NotFound from "./pages/NotFound";

const queryClient = new QueryClient();

function ThemeWrapper({ children }: { children: React.ReactNode }) {
  const theme = useAppStore((s) => s.theme);
  useEffect(() => {
    document.documentElement.classList.toggle("dark", theme === "dark");
  }, [theme]);
  return <>{children}</>;
}

const App = () => (
  <QueryClientProvider client={queryClient}>
    <TooltipProvider>
      <Toaster />
      <Sonner />
      <BrowserRouter>
        <ThemeWrapper>
          <Routes>
            <Route path="/" element={<SplashScreen />} />
            <Route path="/auth" element={<Auth />} />
            <Route path="/role-select" element={<RoleSelection />} />
            <Route path="/app/*" element={<MainApp />} />
            <Route path="*" element={<NotFound />} />
          </Routes>
        </ThemeWrapper>
      </BrowserRouter>
    </TooltipProvider>
  </QueryClientProvider>
);

export default App;
