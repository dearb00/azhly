import { useAppStore } from "@/stores/appStore";

interface BubbleBackgroundProps {
  children: React.ReactNode;
  className?: string;
}

const bubbles = [
  { size: 120, top: "8%", left: "10%", anim: "animate-float1", delay: "0s" },
  { size: 80, top: "20%", left: "75%", anim: "animate-float2", delay: "1s" },
  { size: 160, top: "55%", left: "5%", anim: "animate-float3", delay: "0.5s" },
  { size: 60, top: "70%", left: "60%", anim: "animate-float4", delay: "2s" },
  { size: 100, top: "35%", left: "85%", anim: "animate-float5", delay: "1.5s" },
  { size: 140, top: "80%", left: "30%", anim: "animate-float6", delay: "0.8s" },
  { size: 50, top: "12%", left: "45%", anim: "animate-float1", delay: "3s" },
  { size: 90, top: "45%", left: "50%", anim: "animate-float2", delay: "2.5s" },
  { size: 70, top: "88%", left: "80%", anim: "animate-float3", delay: "1.2s" },
  { size: 110, top: "62%", left: "20%", anim: "animate-float4", delay: "0.3s" },
];

export default function BubbleBackground({ children, className = "" }: BubbleBackgroundProps) {
  const theme = useAppStore((s) => s.theme);

  const bgClass = theme === "dark"
    ? "bg-[hsl(230,50%,8%)]"
    : "bg-gradient-to-br from-[hsl(280,40%,93%)] via-[hsl(300,35%,90%)] to-[hsl(270,40%,88%)]";

  const getBubbleStyle = (size: number, top: string, left: string, delay: string, i: number) => {
    const darkColors = [
      "rgba(120,60,200,0.35)", "rgba(90,40,170,0.28)", "rgba(140,70,220,0.3)",
      "rgba(70,30,150,0.25)", "rgba(160,80,240,0.2)",
    ];
    const lightColors = [
      "rgba(200,150,230,0.45)", "rgba(180,120,220,0.38)", "rgba(220,160,240,0.42)",
      "rgba(160,130,210,0.35)", "rgba(230,170,250,0.3)",
    ];
    const colors = theme === "dark" ? darkColors : lightColors;
    const color = colors[i % colors.length];
    return {
      width: size, height: size, top, left,
      background: `radial-gradient(circle at 30% 30%, ${color}, transparent 70%)`,
      backdropFilter: "blur(12px)",
      WebkitBackdropFilter: "blur(12px)",
      border: theme === "dark"
        ? "1px solid rgba(140,80,230,0.2)"
        : "1px solid rgba(200,150,240,0.35)",
      animationDelay: delay,
      borderRadius: "50%",
    } as React.CSSProperties;
  };

  return (
    <div className={`relative min-h-screen overflow-hidden ${bgClass} ${className}`}>
      {bubbles.map((b, i) => (
        <div
          key={i}
          className={`absolute pointer-events-none ${b.anim}`}
          style={getBubbleStyle(b.size, b.top, b.left, b.delay, i)}
        />
      ))}
      <div className="relative z-10 min-h-screen">{children}</div>
    </div>
  );
}
