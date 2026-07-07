import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { useAppStore } from "@/stores/appStore";
import BubbleBackground from "@/components/layout/BubbleBackground";
import ThemeToggle from "@/components/features/ThemeToggle";
import { Eye, EyeOff } from "lucide-react";

const LOGO_NAVY = "https://cdn-ai.onspace.ai/onspace/project/uploads/niMvJnJE5E65Sj4PFxLMBY/pasted-image-1783425459805-0.png";
const LOGO_LIGHT = "https://cdn-ai.onspace.ai/onspace/project/uploads/LRW6jxNw6QGvA28RQyhckk/pasted-image-1783425460346-1.png";

export default function Auth() {
  const [isLogin, setIsLogin] = useState(true);
  const [name, setName] = useState("");
  const [email, setEmail] = useState("user@azhly.edu");
  const [password, setPassword] = useState("password");
  const [showPass, setShowPass] = useState(false);
  const { login, theme } = useAppStore();
  const navigate = useNavigate();

  const logoSrc = theme === "light" ? LOGO_NAVY : LOGO_LIGHT;

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    login(name || "Alex User", email, "student");
    navigate("/role-select");
  };

  const inputStyle: React.CSSProperties = theme === "dark"
    ? { background: "rgba(255,255,255,0.06)", border: "1px solid rgba(124,58,237,0.3)", color: "white" }
    : { background: "rgba(255,255,255,0.7)", border: "1px solid rgba(124,58,237,0.25)", color: "#1a0a3d" };

  const cardStyle: React.CSSProperties = theme === "dark"
    ? { background: "rgba(255,255,255,0.05)", border: "1px solid rgba(124,58,237,0.25)", backdropFilter: "blur(20px)" }
    : { background: "rgba(255,255,255,0.7)", border: "1px solid rgba(124,58,237,0.2)", backdropFilter: "blur(20px)" };

  return (
    <BubbleBackground>
      <div className="min-h-screen flex flex-col">
        <div className="flex justify-end p-4">
          <ThemeToggle />
        </div>

        <div className="flex-1 flex items-center justify-center px-6 pb-12">
          <div className="w-full max-w-sm animate-fadeInUp">
            {/* Logo */}
            <div className="flex flex-col items-center mb-8">
              <img src={logoSrc} alt="AZHly" className="w-20 h-20 object-contain mb-3" />
              <h1 className="text-3xl font-extrabold" style={{ background: "linear-gradient(135deg,#7c3aed,#ec4899)", WebkitBackgroundClip: "text", WebkitTextFillColor: "transparent" }}>
                AZHly
              </h1>
              <p className="text-xs text-muted-foreground mt-1 tracking-widest uppercase">Smart Room Booking</p>
            </div>

            {/* Card */}
            <div className="rounded-3xl p-6" style={cardStyle}>
              {/* Tabs */}
              <div className="flex rounded-xl p-1 mb-6" style={{ background: theme === "dark" ? "rgba(124,58,237,0.12)" : "rgba(124,58,237,0.08)" }}>
                {["Login", "Sign Up"].map((tab) => (
                  <button key={tab}
                    onClick={() => setIsLogin(tab === "Login")}
                    className="flex-1 py-2 rounded-lg text-sm font-semibold transition-all duration-200"
                    style={
                      (tab === "Login") === isLogin
                        ? { background: "linear-gradient(135deg,#7c3aed,#a855f7)", color: "white" }
                        : { color: theme === "dark" ? "rgba(196,132,252,0.7)" : "rgba(124,58,237,0.6)" }
                    }>
                    {tab}
                  </button>
                ))}
              </div>

              <form onSubmit={handleSubmit} className="space-y-4">
                {!isLogin && (
                  <div>
                    <label className="text-xs font-medium text-muted-foreground mb-1 block">Full Name</label>
                    <input
                      value={name} onChange={(e) => setName(e.target.value)}
                      placeholder="Your full name"
                      className="w-full px-4 py-3 rounded-xl text-sm outline-none focus:ring-2"
                      style={{ ...inputStyle, "--tw-ring-color": "#7c3aed" } as React.CSSProperties}
                    />
                  </div>
                )}

                <div>
                  <label className="text-xs font-medium text-muted-foreground mb-1 block">Email</label>
                  <input
                    type="email" value={email} onChange={(e) => setEmail(e.target.value)}
                    placeholder="your@email.edu"
                    className="w-full px-4 py-3 rounded-xl text-sm outline-none"
                    style={inputStyle}
                  />
                </div>

                <div>
                  <label className="text-xs font-medium text-muted-foreground mb-1 block">Password</label>
                  <div className="relative">
                    <input
                      type={showPass ? "text" : "password"} value={password} onChange={(e) => setPassword(e.target.value)}
                      placeholder="••••••••"
                      className="w-full px-4 py-3 rounded-xl text-sm outline-none pr-11"
                      style={inputStyle}
                    />
                    <button type="button" onClick={() => setShowPass((v) => !v)}
                      className="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground">
                      {showPass ? <EyeOff size={16} /> : <Eye size={16} />}
                    </button>
                  </div>
                </div>

                <button type="submit"
                  className="w-full py-3 rounded-xl font-bold text-white text-sm mt-2 transition-all hover:opacity-90 hover:scale-[1.02] active:scale-95"
                  style={{ background: "linear-gradient(135deg,#7c3aed,#ec4899)" }}>
                  {isLogin ? "Sign In" : "Create Account"}
                </button>
              </form>
            </div>
          </div>
        </div>
      </div>
    </BubbleBackground>
  );
}
