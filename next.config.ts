import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  allowedDevOrigins: [
    '*.ngrok-free.app',
    '*.ngrok-free.dev',
    '*.trycloudflare.com',
    '*.pinggy.link',
    '*.pinggy.net',
    '*.loca.lt',
    'localhost:3000',
    '192.168.254.141:3000',
    '192.168.1.12:3000',
    '192.168.1.8:3000',
  ],
  experimental: {
    serverActions: {
      bodySizeLimit: '25mb',
      allowedOrigins: [
        '*.ngrok-free.app',
        '*.ngrok-free.dev',
        '*.trycloudflare.com',
        '*.pinggy.link',
        '*.pinggy.net',
        '*.loca.lt',
        'localhost:3000',
        'localhost:3001',
        '192.168.254.141:3000',
        '192.168.1.12:3000',
        '192.168.1.8:3000',
      ],
    },
  },
};

export default nextConfig;
