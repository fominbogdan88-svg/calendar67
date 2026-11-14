import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // Playwright нельзя упаковывать в бандл — он запускается как обычный Node-модуль.
  serverExternalPackages: ["playwright-core"],
  poweredByHeader: false,
};

export default nextConfig;
