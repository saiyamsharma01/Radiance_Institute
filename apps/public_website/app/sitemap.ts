import { MetadataRoute } from "next";

export default function sitemap(): MetadataRoute.Sitemap {
  const baseUrl = "https://radianceinstitute.net";

  const staticRoutes = [
    "",
    "/about",
    "/classes",
    "/classes/6",
    "/classes/7",
    "/classes/8",
    "/classes/9",
    "/classes/10",
    "/classes/11",
    "/classes/12",
    "/subjects",
    "/admissions",
    "/contact",
    "/faq",
    "/privacy-policy",
    "/terms",
  ];

  return staticRoutes.map((route) => ({
    url: `${baseUrl}${route}`,
    lastModified: new Date(),
    changeFrequency: route === "" || route === "/admissions" ? "weekly" : "monthly",
    priority: route === "" ? 1.0 : route === "/admissions" || route === "/subjects" ? 0.9 : 0.8,
  }));
}
