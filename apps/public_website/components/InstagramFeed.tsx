"use client";

import { useState } from "react";
import Image from "next/image";
import Link from "next/link";
import {
  Instagram,
  Heart,
  MessageCircle,
  ExternalLink,
  Award,
  Sparkles,
  BookOpen,
  Play,
  X,
  Share2,
  CheckCircle2,
} from "lucide-react";

interface InstagramPost {
  id: string;
  type: "image" | "reel";
  title: string;
  category: "all" | "physics" | "toppers" | "classroom" | "tips";
  caption: string;
  hashtags: string[];
  likes: number;
  comments: number;
  date: string;
  image: string;
  duration?: string;
  link: string;
}

const INSTAGRAM_POSTS: InstagramPost[] = [
  {
    id: "post-1",
    type: "reel",
    title: "Er. Bedi Sir on Rotational Motion Shortcuts",
    category: "physics",
    caption:
      "Mastering Moment of Inertia for JEE Advanced in under 60 seconds! Er. Bedi Sir explains the parallel-axis theorem shortcut every aspirant needs. Conceptual clarity leads to rank perfection! 🎯⚛️",
    hashtags: [
      "#RadianceInstitute",
      "#PhysicsByBediSir",
      "#JEEAdvanced",
      "#AmritsarCoaching",
      "#RaniKaBagh",
    ],
    likes: 482,
    comments: 38,
    date: "2 days ago",
    duration: "0:58",
    image: "/images/teacher_physics.jpg",
    link: "https://www.instagram.com/radiance_institute/",
  },
  {
    id: "post-2",
    type: "image",
    title: "Felicitation of JEE Main 99.8%ile Achievers",
    category: "toppers",
    caption:
      "Huge congratulations to our brilliant minds for conquering JEE Main 2026 with 99.8+ Percentile in Physics! Your dedication at Radiance Institute Rani Ka Bagh has made all of Amritsar proud! 🏆✨",
    hashtags: [
      "#RadianceToppers",
      "#JEEMain2026",
      "#AmritsarPride",
      "#BediCollegeOfPhysics",
      "#HallOfFame",
    ],
    likes: 624,
    comments: 54,
    date: "4 days ago",
    image: "/images/student_testimonial.jpg",
    link: "https://www.instagram.com/radiance_institute/",
  },
  {
    id: "post-3",
    type: "image",
    title: "Senior Secondary Optics Practical Session",
    category: "classroom",
    caption:
      "Deep dive into Wave Optics and Diffraction patterns in our advanced science lab. Real experiments bridge the gap between theory and board exam excellence! 🔬💡",
    hashtags: [
      "#Class12Physics",
      "#CBSEBoards",
      "#OpticsLab",
      "#RadianceAmritsar",
      "#ConceptualLearning",
    ],
    likes: 351,
    comments: 19,
    date: "1 week ago",
    image: "/images/institute_lab.jpg",
    link: "https://www.instagram.com/radiance_institute/",
  },
  {
    id: "post-4",
    type: "reel",
    title: "Foundation Academy: Mental Ability & Olympiad Math",
    category: "tips",
    caption:
      "Class 8 & 9 junior scholars solving NTSE number series with 3x speed! Building logical reasoning early creates future IITians and Doctors. Admissions ongoing for Foundation Batches! 🧠⚡",
    hashtags: [
      "#FoundationAcademy",
      "#Class9Maths",
      "#OlympiadPrep",
      "#NTSE",
      "#JuniorScholars",
    ],
    likes: 298,
    comments: 23,
    date: "1 week ago",
    duration: "1:15",
    image: "/images/institute_hero_banner.jpg",
    link: "https://www.instagram.com/radiance_institute/",
  },
  {
    id: "post-5",
    type: "image",
    title: "Sunday All-Punjab Grand Test Series",
    category: "classroom",
    caption:
      "Over 120 aspirants testing their mettle in our strictly invigilated Sunday test simulation. Real exam temperament begins right here at Rani Ka Bagh! 📝⏱️",
    hashtags: [
      "#RadianceTestSeries",
      "#ExamTemperament",
      "#NEETPrep",
      "#JEEMainMock",
      "#AmritsarStudents",
    ],
    likes: 419,
    comments: 31,
    date: "2 weeks ago",
    image: "/images/institute_lab.jpg",
    link: "https://www.instagram.com/radiance_institute/",
  },
  {
    id: "post-6",
    type: "reel",
    title: "Bedi Sir's Golden Rule for Numerical Accuracy",
    category: "physics",
    caption:
      "'Units, Dimensions, and Vector Signs: 80% of errors vanish when you check these three things.' Watch Er. Bedi Sir break down tricky electrostatics questions effortlessly. ⚡📐",
    hashtags: [
      "#PhysicsTips",
      "#BediSirPhysics",
      "#JEETricks",
      "#QualityEducation",
      "#Amritsar",
    ],
    likes: 567,
    comments: 42,
    date: "3 weeks ago",
    duration: "0:45",
    image: "/images/teacher_physics.jpg",
    link: "https://www.instagram.com/radiance_institute/",
  },
];

const STORY_HIGHLIGHTS = [
  { title: "Er. Bedi Sir", icon: Sparkles, color: "from-amber-500 to-red-500" },
  { title: "Physics Demos", icon: Play, color: "from-blue-500 to-indigo-600" },
  { title: "Toppers 2026", icon: Award, color: "from-emerald-500 to-teal-600" },
  { title: "Classroom Life", icon: BookOpen, color: "from-purple-500 to-pink-500" },
  { title: "Sunday Tests", icon: CheckCircle2, color: "from-orange-500 to-amber-500" },
];

export default function InstagramFeed() {
  const [activeFilter, setActiveFilter] = useState<string>("all");
  const [selectedPost, setSelectedPost] = useState<InstagramPost | null>(null);
  const [likedPosts, setLikedPosts] = useState<Record<string, boolean>>({});

  const filteredPosts =
    activeFilter === "all"
      ? INSTAGRAM_POSTS
      : INSTAGRAM_POSTS.filter((p) => p.category === activeFilter);

  const toggleLike = (id: string, e: React.MouseEvent) => {
    e.stopPropagation();
    setLikedPosts((prev) => ({ ...prev, [id]: !prev[id] }));
  };

  return (
    <section className="py-20 bg-gradient-to-b from-slate-50 via-white to-slate-50 relative overflow-hidden" id="instagram-feed">
      {/* Background Accent */}
      <div className="absolute top-0 right-1/4 w-96 h-96 bg-pink-100/40 rounded-full blur-3xl pointer-events-none" />
      <div className="absolute bottom-0 left-1/4 w-96 h-96 bg-blue-100/40 rounded-full blur-3xl pointer-events-none" />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        {/* Instagram Header Card */}
        <div className="bg-white rounded-3xl p-6 sm:p-8 border border-slate-200/80 shadow-xl mb-12">
          <div className="flex flex-col md:flex-row items-center md:items-start justify-between gap-6">
            {/* Left: Avatar & Profile Info */}
            <div className="flex flex-col sm:flex-row items-center sm:items-start text-center sm:text-left gap-5">
              {/* Instagram Story Gradient Ring */}
              <div className="p-1 rounded-2xl bg-gradient-to-tr from-amber-500 via-pink-500 to-purple-600 shadow-md shrink-0">
                <div className="p-1.5 bg-white rounded-xl">
                  <div className="relative w-20 h-20 sm:w-24 sm:h-24 rounded-lg overflow-hidden flex items-center justify-center">
                    <Image
                      src="/images/radiance_logo.jpg"
                      alt="Radiance Institute Instagram Profile"
                      fill
                      className="object-contain"
                    />
                  </div>
                </div>
              </div>

              <div>
                <div className="flex flex-wrap items-center justify-center sm:justify-start gap-2.5">
                  <h3 className="text-xl sm:text-2xl font-black text-slate-900 tracking-tight">
                    radiance_institute
                  </h3>
                  <span className="inline-flex items-center gap-1 bg-blue-50 text-blue-700 text-xs font-semibold px-2.5 py-0.5 rounded-full border border-blue-200">
                    <CheckCircle2 className="w-3.5 h-3.5 text-blue-600 fill-blue-100" />
                    Verified Official
                  </span>
                </div>
                <p className="text-sm font-semibold text-slate-700 mt-1">
                  Radiance Institute • Bedi College of Physics
                </p>
                <p className="text-xs sm:text-sm text-slate-500 max-w-xl mt-1 leading-relaxed">
                  📍 85-A, Rani Ka Bagh, Amritsar | Physics by Er. Bedi Sir (Est. 1998)
                  <br />
                  🎓 Foundations (6–10) • Senior Secondary PCM (11–12) • JEE Main/Adv & NEET
                </p>

                {/* Follower Stats */}
                <div className="flex items-center justify-center sm:justify-start gap-6 mt-4 text-xs sm:text-sm">
                  <div>
                    <strong className="text-slate-900 font-bold">207+</strong>{" "}
                    <span className="text-slate-500">Posts</span>
                  </div>
                  <div>
                    <strong className="text-slate-900 font-bold">1,250+</strong>{" "}
                    <span className="text-slate-500">Amritsar Scholars</span>
                  </div>
                  <div>
                    <strong className="text-slate-900 font-bold">28 Yrs</strong>{" "}
                    <span className="text-slate-500">Legacy</span>
                  </div>
                </div>
              </div>
            </div>

            {/* Right: Direct Follow Button */}
            <div className="flex flex-col sm:flex-row items-center gap-3 w-full md:w-auto">
              <a
                href="https://www.instagram.com/radiance_institute/"
                target="_blank"
                rel="noopener noreferrer"
                className="w-full sm:w-auto inline-flex items-center justify-center gap-2 bg-gradient-to-r from-purple-600 via-pink-600 to-amber-500 hover:from-purple-700 hover:to-amber-600 text-white font-bold text-sm px-6 py-3 rounded-xl shadow-lg hover:shadow-xl transition-all"
              >
                <Instagram className="w-4 h-4" />
                <span>Follow @radiance_institute</span>
                <ExternalLink className="w-3.5 h-3.5 ml-0.5" />
              </a>
            </div>
          </div>

          {/* Story Highlights Bar */}
          <div className="mt-8 pt-6 border-t border-slate-100">
            <p className="text-xs font-bold uppercase tracking-wider text-slate-400 mb-4 text-center sm:text-left">
              Instagram Story Highlights
            </p>
            <div className="flex items-center justify-start gap-4 sm:gap-8 overflow-x-auto pb-2 scrollbar-none">
              {STORY_HIGHLIGHTS.map((item, idx) => {
                const Icon = item.icon;
                return (
                  <a
                    key={idx}
                    href="https://www.instagram.com/radiance_institute/"
                    target="_blank"
                    rel="noopener noreferrer"
                    className="flex flex-col items-center gap-2 group shrink-0"
                  >
                    <div
                      className={`p-0.5 rounded-full bg-gradient-to-tr ${item.color} group-hover:scale-105 transition-transform`}
                    >
                      <div className="p-1 bg-white rounded-full">
                        <div className="w-14 h-14 rounded-full bg-slate-50 flex items-center justify-center text-slate-700 group-hover:text-blue-600">
                          <Icon className="w-6 h-6" />
                        </div>
                      </div>
                    </div>
                    <span className="text-xs font-medium text-slate-700 group-hover:text-blue-600 whitespace-nowrap">
                      {item.title}
                    </span>
                  </a>
                );
              })}
            </div>
          </div>
        </div>

        {/* Section Heading & Category Filters */}
        <div className="flex flex-col md:flex-row md:items-end justify-between gap-6 mb-8">
          <div>
            <div className="inline-flex items-center gap-2 text-xs font-bold uppercase tracking-wider text-pink-600 bg-pink-50 px-3 py-1 rounded-full mb-2">
              <Instagram className="w-3.5 h-3.5" />
              <span>Real-Time Institute Life</span>
            </div>
            <h2 className="text-2xl sm:text-3xl font-extrabold text-slate-900 tracking-tight">
              Classroom Moments & Academic Feats
            </h2>
            <p className="text-sm sm:text-base text-slate-600 mt-1">
              Explore recent posts, concept reels, topper felicitations, and laboratory sessions.
            </p>
          </div>

          {/* Category Filter Pills */}
          <div className="flex flex-wrap items-center gap-2">
            {[
              { id: "all", label: "All Posts" },
              { id: "physics", label: "Physics by Bedi Sir" },
              { id: "toppers", label: "Toppers & Ranks" },
              { id: "classroom", label: "Classrooms & Labs" },
              { id: "tips", label: "Prep Tips" },
            ].map((cat) => (
              <button
                key={cat.id}
                onClick={() => setActiveFilter(cat.id)}
                className={`text-xs font-semibold px-4 py-2 rounded-full transition-all ${
                  activeFilter === cat.id
                    ? "bg-radiance-navy text-white shadow-md"
                    : "bg-slate-100 hover:bg-slate-200 text-slate-700"
                }`}
              >
                {cat.label}
              </button>
            ))}
          </div>
        </div>

        {/* Posts Grid */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 sm:gap-8">
          {filteredPosts.map((post) => {
            const isLiked = likedPosts[post.id];
            return (
              <div
                key={post.id}
                onClick={() => setSelectedPost(post)}
                className="group cursor-pointer bg-white rounded-2xl border border-slate-200/90 overflow-hidden shadow-sm hover:shadow-xl transition-all duration-300 flex flex-col"
              >
                {/* Media Container */}
                <div className="relative aspect-[4/3] w-full overflow-hidden bg-slate-900">
                  <Image
                    src={post.image}
                    alt={post.title}
                    fill
                    className="object-cover group-hover:scale-105 transition-transform duration-500 opacity-95 group-hover:opacity-100"
                  />

                  {/* Top Badge (Reel vs Image) */}
                  <div className="absolute top-3 left-3 z-10 flex items-center gap-1.5 bg-black/60 backdrop-blur-md px-2.5 py-1 rounded-full text-white text-[11px] font-medium">
                    {post.type === "reel" ? (
                      <>
                        <Play className="w-3 h-3 text-amber-400 fill-amber-400" />
                        <span>Reel {post.duration}</span>
                      </>
                    ) : (
                      <>
                        <Sparkles className="w-3 h-3 text-pink-400" />
                        <span>Post</span>
                      </>
                    )}
                  </div>

                  {/* Instagram Logo Watermark */}
                  <div className="absolute top-3 right-3 z-10 w-7 h-7 rounded-full bg-black/40 backdrop-blur-md flex items-center justify-center text-white">
                    <Instagram className="w-4 h-4" />
                  </div>

                  {/* Hover Overlay */}
                  <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-black/30 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300 flex items-end p-4">
                    <p className="text-white text-xs font-semibold flex items-center gap-1">
                      <span>Click to view Instagram details</span>
                      <ExternalLink className="w-3 h-3" />
                    </p>
                  </div>
                </div>

                {/* Card Content */}
                <div className="p-5 flex-1 flex flex-col justify-between">
                  <div>
                    <h3 className="font-bold text-slate-900 text-base group-hover:text-radiance-blue transition-colors line-clamp-1">
                      {post.title}
                    </h3>
                    <p className="text-xs text-slate-600 mt-2 line-clamp-2 leading-relaxed">
                      {post.caption}
                    </p>

                    {/* Hashtags */}
                    <div className="flex flex-wrap gap-1 mt-3">
                      {post.hashtags.slice(0, 3).map((tag, i) => (
                        <span key={i} className="text-[11px] text-blue-600 font-medium">
                          {tag}
                        </span>
                      ))}
                    </div>
                  </div>

                  {/* Footer Interaction Bar */}
                  <div className="pt-4 mt-4 border-t border-slate-100 flex items-center justify-between text-xs text-slate-500">
                    <div className="flex items-center gap-4">
                      <button
                        onClick={(e) => toggleLike(post.id, e)}
                        className={`flex items-center gap-1 transition-colors ${
                          isLiked ? "text-red-500 font-semibold" : "hover:text-red-500"
                        }`}
                      >
                        <Heart
                          className={`w-4 h-4 ${isLiked ? "fill-red-500 text-red-500" : ""}`}
                        />
                        <span>{isLiked ? post.likes + 1 : post.likes}</span>
                      </button>
                      <span className="flex items-center gap-1">
                        <MessageCircle className="w-4 h-4" />
                        <span>{post.comments}</span>
                      </span>
                    </div>

                    <span className="text-[11px] text-slate-400">{post.date}</span>
                  </div>
                </div>
              </div>
            );
          })}
        </div>

        {/* View on Instagram Footer Banner */}
        <div className="mt-12 bg-gradient-to-r from-blue-900 via-radiance-navy to-slate-900 rounded-2xl p-6 sm:p-8 text-white flex flex-col sm:flex-row items-center justify-between gap-6 shadow-xl">
          <div className="text-center sm:text-left">
            <h3 className="text-lg sm:text-xl font-bold flex items-center justify-center sm:justify-start gap-2">
              <Instagram className="w-5 h-5 text-pink-400" />
              <span>Stay connected with @radiance_institute on Instagram</span>
            </h3>
            <p className="text-xs sm:text-sm text-slate-300 mt-1 max-w-xl">
              Get weekly physics mindmaps, formula sheets, mock test notifications, and guidance sessions from Er. Bedi Sir.
            </p>
          </div>
          <a
            href="https://www.instagram.com/radiance_institute/"
            target="_blank"
            rel="noopener noreferrer"
            className="shrink-0 bg-white hover:bg-slate-100 text-radiance-navy font-bold text-xs sm:text-sm px-6 py-3 rounded-xl shadow-md transition-all flex items-center gap-2"
          >
            <span>Open @radiance_institute</span>
            <ExternalLink className="w-4 h-4" />
          </a>
        </div>
      </div>

      {/* Interactive Post Modal */}
      {selectedPost && (
        <div
          className="fixed inset-0 z-50 bg-black/75 backdrop-blur-sm flex items-center justify-center p-4"
          onClick={() => setSelectedPost(null)}
        >
          <div
            className="bg-white rounded-3xl max-w-3xl w-full overflow-hidden shadow-2xl relative animate-in fade-in zoom-in-95 duration-200"
            onClick={(e) => e.stopPropagation()}
          >
            {/* Close Button */}
            <button
              onClick={() => setSelectedPost(null)}
              className="absolute top-4 right-4 z-20 w-9 h-9 rounded-full bg-black/60 text-white hover:bg-black flex items-center justify-center transition-all"
            >
              <X className="w-5 h-5" />
            </button>

            <div className="grid grid-cols-1 md:grid-cols-2">
              {/* Media Column */}
              <div className="relative aspect-square md:aspect-auto bg-slate-950 flex items-center justify-center">
                <Image
                  src={selectedPost.image}
                  alt={selectedPost.title}
                  fill
                  className="object-cover"
                />
                {selectedPost.type === "reel" && (
                  <div className="absolute inset-0 flex items-center justify-center bg-black/30">
                    <div className="w-16 h-16 rounded-full bg-white/90 text-radiance-navy flex items-center justify-center pl-1 shadow-2xl">
                      <Play className="w-8 h-8 fill-radiance-navy" />
                    </div>
                  </div>
                )}
              </div>

              {/* Details Column */}
              <div className="p-6 sm:p-8 flex flex-col justify-between max-h-[550px] overflow-y-auto">
                <div>
                  {/* Institute Header */}
                  <div className="flex items-center gap-3 pb-4 border-b border-slate-100">
                    <div className="relative w-10 h-10 rounded-full overflow-hidden border border-slate-200">
                      <Image
                        src="/images/radiance_logo.jpg"
                        alt="Radiance"
                        fill
                        className="object-cover"
                      />
                    </div>
                    <div>
                      <h4 className="text-sm font-bold text-slate-900">radiance_institute</h4>
                      <p className="text-xs text-slate-500">Rani Ka Bagh, Amritsar</p>
                    </div>
                  </div>

                  {/* Caption & Content */}
                  <div className="py-4 space-y-3">
                    <h3 className="font-extrabold text-base text-slate-900">
                      {selectedPost.title}
                    </h3>
                    <p className="text-xs sm:text-sm text-slate-700 leading-relaxed">
                      {selectedPost.caption}
                    </p>
                    <div className="flex flex-wrap gap-1.5 pt-2">
                      {selectedPost.hashtags.map((tag, idx) => (
                        <span key={idx} className="text-xs font-medium text-blue-600 bg-blue-50 px-2 py-0.5 rounded">
                          {tag}
                        </span>
                      ))}
                    </div>
                  </div>
                </div>

                {/* Engagement & Direct Link */}
                <div className="pt-4 border-t border-slate-100 space-y-4">
                  <div className="flex items-center justify-between text-xs text-slate-600">
                    <div className="flex items-center gap-4">
                      <button
                        onClick={(e) => toggleLike(selectedPost.id, e)}
                        className="flex items-center gap-1.5 font-semibold text-slate-800 hover:text-red-500"
                      >
                        <Heart
                          className={`w-5 h-5 ${
                            likedPosts[selectedPost.id] ? "fill-red-500 text-red-500" : ""
                          }`}
                        />
                        <span>
                          {likedPosts[selectedPost.id]
                            ? selectedPost.likes + 1
                            : selectedPost.likes}{" "}
                          likes
                        </span>
                      </button>
                      <span className="flex items-center gap-1.5">
                        <MessageCircle className="w-5 h-5" />
                        <span>{selectedPost.comments} comments</span>
                      </span>
                    </div>
                    <span className="text-slate-400">{selectedPost.date}</span>
                  </div>

                  <a
                    href={selectedPost.link}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="w-full inline-flex items-center justify-center gap-2 bg-radiance-navy hover:bg-radiance-blue text-white font-bold text-xs sm:text-sm py-3 rounded-xl transition-colors shadow"
                  >
                    <Instagram className="w-4 h-4" />
                    <span>View Original Post on Instagram</span>
                    <ExternalLink className="w-3.5 h-3.5" />
                  </a>
                </div>
              </div>
            </div>
          </div>
        </div>
      )}
    </section>
  );
}
