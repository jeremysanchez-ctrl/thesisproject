import { spawn } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';

const tunnelFile = path.join(process.cwd(), '.tunnel_url');
const exePath = path.join(process.cwd(), 'cloudflared.exe');

let currentChild = null;

function start() {
  console.log('[TUNNEL] Starting Cloudflare Quick Tunnel on port 3000...');

  const cf = spawn(exePath, ['tunnel', '--url', 'http://127.0.0.1:3000'], {
    stdio: ['ignore', 'pipe', 'pipe'],
    windowsHide: true,
  });
  currentChild = cf;

  let tunnelUrlFound = false;

  function handleOutput(data) {
    const text = data.toString();
    const match = text.match(/https:\/\/[a-zA-Z0-9]+-[a-zA-Z0-9-]+\.trycloudflare\.com/);
    if (match && !tunnelUrlFound && !match[0].includes('api.trycloudflare.com')) {
      const url = match[0];
      tunnelUrlFound = true;
      try {
        fs.writeFileSync(tunnelFile, url, 'utf8');
      } catch {}
      console.log('\n=============================================================');
      console.log(`🌐 LIVE PUBLIC TUNNEL ACTIVE: ${url}`);
      console.log('Mobile phones on cellular data can now scan and submit!');
      console.log('=============================================================\n');
    }
  }

  cf.stdout.on('data', handleOutput);
  cf.stderr.on('data', handleOutput);

  cf.on('close', (code) => {
    console.log(`[TUNNEL] Process exited with code ${code}. Reconnecting in 3s...`);
    currentChild = null;
    setTimeout(start, 3000);
  });
}

start();

process.on('SIGINT', () => {
  if (currentChild) currentChild.kill();
  process.exit();
});
process.on('SIGTERM', () => {
  if (currentChild) currentChild.kill();
  process.exit();
});
