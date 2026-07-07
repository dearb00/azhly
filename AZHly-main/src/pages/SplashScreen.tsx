import { useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { useAppStore } from "@/stores/appStore";
import BubbleBackground from "@/components/layout/BubbleBackground";

const LOGO_NAVY = "https://cdn-ai.onspace.ai/onspace/project/uploads/niMvJnJE5E65Sj4PFxLMBY/pasted-image-1783425459805-0.png";
const LOGO_LIGHT = "https://cdn-ai.onspace.ai/onspace/project/uploads/LRW6jxNw6QGvA28RQyhckk/pasted-image-1783425460346-1.png";

export default function SplashScreen() {
  const navigate = useNavigate();
  const { isAuthenticated, theme } = useAppStore();

  useEffect(() => {
    const t = setTimeout(() => {
      navigate(isAuthenticated ? "/app" : "/auth");
    }, 2800);
    return () => clearTimeout(t);
  }, [navigate, isAuthenticated]);

  const logoSrc = theme === "light" ? LOGO_NAVY : LOGO_LIGHT;

  return (
    <BubbleBackground>
      <div className="min-h-screen flex flex-col items-center justify-center">
        <div className="flex flex-col items-center gap-6 animate-fadeInUp">
          <div className="animate-pulseSlow">
            <img src={logoSrc} alt="AZHly" className="w-32 h-32 object-contain drop-shadow-2xl" />
          </div>

          <div className="text-center">
            <h1 className="text-5xl font-extrabold tracking-tight"
              style={{ background: "linear-gradient(135deg, #7c3aed, #ec4899)", WebkitBackgroundClip: "text", WebkitTextFillColor: "transparent" }}>
              AZHly
            </h1>
            <p className="text-sm mt-2 tracking-widest uppercase font-medium text-muted-foreground">
              Smart Room Booking
            </p>
          </div>

          <div className="flex gap-2 mt-4">
            {[0, 1, 2].map((i) => (
              <div key={i} className="w-2 h-2 rounded-full animate-pulseSlow"
                style={{
                  background: i === 0 ? "#7c3aed" : i === 1 ? "#a855f7" : "#ec4899",
                  animationDelay: `${i * 0.3}s`,
                }} />
            ))}
          </div>
        </div>
      </div>
    </BubbleBackground>
  );
}
