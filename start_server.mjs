import { spawn } from 'node:child_process';
import path from 'node:path';

const nextBin = path.join(process.cwd(), 'node_modules', 'next', 'dist', 'bin', 'next');

let currentProcess = null;

function start() {
  console.log('[SERVER] Starting Next.js Production Server on port 3000...');

  const s = spawn(process.execPath, [nextBin, 'start', '-p', '3000'], {
    stdio: 'inherit',
    cwd: process.cwd(),
    env: process.env,
  });
  currentProcess = s;

  s.on('exit', (code) => {
    console.log(`[SERVER] Next.js exited with code ${code}. Restarting in 2s...`);
    currentProcess = null;
    setTimeout(start, 2000);
  });
}

start();

process.on('SIGINT', () => {
  if (currentProcess) currentProcess.kill();
  process.exit();
});
process.on('SIGTERM', () => {
  if (currentProcess) currentProcess.kill();
  process.exit();
});
