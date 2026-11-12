import { spawn } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';

const tunnelFile = path.join(process.cwd(), '.tunnel_url');
const exePath = path.join(process.cwd(), 'cloudflared.exe');
const MAX_RETRIES = 20;
const RETRY_DELAY = 30000; // 30 seconds

let attempt = 0;

function tryTunnel() {
  attempt++;
  console.log(`[TUNNEL] Attempt ${attempt}/${MAX_RETRIES} — Requesting Cloudflare Quick Tunnel...`);

  const cf = spawn(exePath, ['tunnel', '--url', 'http://127.0.0.1:3000'], {
    stdio: ['ignore', 'pipe', 'pipe'],
    windowsHide: true,
  });

  let found = false;
  let output = '';

  function handleOutput(data) {
    const text = data.toString();
    output += text;
    const match = text.match(/https:\/\/[a-zA-Z0-9]+-[a-zA-Z0-9-]+\.trycloudflare\.com/);
    if (match && !found && !match[0].includes('api.trycloudflare.com')) {
      found = true;
      const url = match[0];
      fs.writeFileSync(tunnelFile, url, 'utf8');
      console.log('\n=============================================================');
      console.log(`🌐 TUNNEL ACTIVE: ${url}`);
      console.log('=============================================================\n');
    }
  }

  cf.stdout.on('data', handleOutput);
  cf.stderr.on('data', handleOutput);

  cf.on('close', (code) => {
    if (!found && output.includes('429')) {
      if (attempt < MAX_RETRIES) {
        console.log(`[TUNNEL] Rate limited (429). Retrying in 30s...`);
        setTimeout(tryTunnel, RETRY_DELAY);
      } else {
        console.log(`[TUNNEL] Max retries reached. Please try again later.`);
      }
    } else if (found) {
      console.log(`[TUNNEL] Tunnel disconnected. Restarting in 3s...`);
      attempt = 0; // reset on successful connection
      setTimeout(tryTunnel, 3000);
    } else {
      console.log(`[TUNNEL] Failed with code ${code}. Retrying in 30s...`);
      setTimeout(tryTunnel, RETRY_DELAY);
    }
  });
}

tryTunnel();
