"use client";

import { useEffect, useRef, useState } from "react";

interface StatItem {
  target: number;
  prefix?: string;
  suffix: string;
  label: string;
  decimals?: number;
}

const STATS: StatItem[] = [
  {
    target: 28,
    suffix: "+ Yrs",
    label: "Academic Legacy",
  },
  {
    target: 100,
    suffix: " %ile",
    label: "JEE Physics Peak",
  },
  {
    target: 200,
    suffix: "+",
    label: "Reels & Lectures",
  },
];

export default function AnimatedStatsStrip() {
  const containerRef = useRef<HTMLDivElement | null>(null);
  const [hasAnimated, setHasAnimated] = useState(false);
  const [counts, setCounts] = useState<number[]>([0, 0, 0]);

  useEffect(() => {
    const element = containerRef.current;
    if (!element) return;

    const observer = new IntersectionObserver(
      (entries) => {
        const [entry] = entries;
        if (entry.isIntersecting && !hasAnimated) {
          setHasAnimated(true);
        }
      },
      {
        threshold: 0.25, // Triggers when 25% of the stats strip is visible
      }
    );

    observer.observe(element);
    return () => observer.disconnect();
  }, [hasAnimated]);

  useEffect(() => {
    if (!hasAnimated) return;

    const duration = 1800; // 1.8 seconds smooth animation
    const startTime = performance.now();

    let animationFrameId: number;

    const updateCounts = (currentTime: number) => {
      const elapsed = currentTime - startTime;
      const progress = Math.min(elapsed / duration, 1);

      // Ease-out cubic curve: fast start, soft landing
      const easeProgress = 1 - Math.pow(1 - progress, 3);

      const nextCounts = STATS.map((stat) => {
        const val = easeProgress * stat.target;
        return stat.decimals ? parseFloat(val.toFixed(stat.decimals)) : Math.round(val);
      });

      setCounts(nextCounts);

      if (progress < 1) {
        animationFrameId = requestAnimationFrame(updateCounts);
      } else {
        // Ensure exact target values on finish
        setCounts(STATS.map((s) => s.target));
      }
    };

    animationFrameId = requestAnimationFrame(updateCounts);
    return () => cancelAnimationFrame(animationFrameId);
  }, [hasAnimated]);

  return (
    <div ref={containerRef} className="pt-4">
      <div className="grid grid-cols-3 divide-x divide-white/15 bg-white/5 backdrop-blur-md rounded-2xl p-3 sm:p-4 border border-white/10 max-w-lg mx-auto lg:mx-0 shadow-lg">
        {STATS.map((stat, idx) => (
          <div key={idx} className="px-2 sm:px-3 text-center transition-transform hover:scale-105 duration-200">
            <div className="font-display text-lg sm:text-2xl font-black text-amber-300 tracking-tight flex items-center justify-center">
              <span>{stat.prefix}</span>
              <span>{counts[idx]}</span>
              <span>{stat.suffix}</span>
            </div>
            <div className="text-[10px] sm:text-xs text-slate-300 font-medium mt-0.5">
              {stat.label}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
