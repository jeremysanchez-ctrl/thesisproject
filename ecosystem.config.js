module.exports = {
  apps: [
    {
      name: 'dcs-sfms-app',
      cwd: 'C:/Users/Gab/.gemini/antigravity/scratch/DCS-SFMS',
      script: 'C:/Users/Gab/.gemini/antigravity/scratch/nodejs/node-v20.18.3-win-x64/node_modules/npm/bin/npm-cli.js',
      args: 'run dev',
      interpreter: 'C:/Users/Gab/.gemini/antigravity/scratch/nodejs/node-v20.18.3-win-x64/node.exe',
      env: {
        NODE_ENV: 'development',
        PATH: 'C:/Users/Gab/.gemini/antigravity/scratch/nodejs/node-v20.18.3-win-x64;' + process.env.PATH,
      },
      autorestart: false,
      watch: false,
      max_memory_restart: '1G',
    },
  ],
};
