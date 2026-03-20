import { PluginOption, ViteDevServer } from 'vite';
import fs from 'fs';
import path from 'path';
import { exec } from 'child_process';

const BOLD = '\x1b[1m';
const DIM = '\x1b[2m';
const GREEN = '\x1b[32m';
const YELLOW = '\x1b[33m';
const RESET = '\x1b[0m';

const DATABASE_PATH = path.resolve(__dirname, 'data/database.json');
const EMPTY_DATABASE = JSON.stringify({
  boards: [],
  cards: [],
  lists: [],
  users: []
}, null, 2);

function printBanner(port: number) {
  console.clear();
  console.log();
  console.log(`  ${GREEN}${BOLD}Trello app is running${RESET}`);
  console.log(`  ${DIM}http://localhost:${port}${RESET}`);
  console.log();
  console.log(`  ${BOLD}Shortcuts${RESET}`);
  console.log();
  console.log(`  - ${RESET}${BOLD}o${RESET}${DIM}pen app in browser${RESET}`);
  console.log(`  - ${RESET}${BOLD}r${RESET}${DIM}emove app data${RESET}`);
  console.log(`  - ${RESET}${BOLD}q${RESET}${DIM}uit the app${RESET}`);
  console.log();
}

export const trelloConsole = (port: number): PluginOption => ({
  name: 'trello-console',
  configureServer(server: ViteDevServer) {
    server.httpServer?.once('listening', () => {
      printBanner(port);

      if (process.stdin.isTTY) {
        process.stdin.setRawMode(true);
        process.stdin.resume();
        process.stdin.setEncoding('utf8');

        process.stdin.on('data', (key: string) => {
          switch (key) {
            case 'o': {
              const url = `http://localhost:${port}`;
              const cmd = process.platform === 'darwin' ? 'open' : process.platform === 'win32' ? 'start' : 'xdg-open';
              exec(`${cmd} ${url}`);
              break;
            }
            case 'r': {
              fs.writeFileSync(DATABASE_PATH, EMPTY_DATABASE + '\n');
              console.log(`  ${YELLOW}App data removed${RESET}`);
              break;
            }
            case 'q':
            case '\u0003': // Ctrl+C
              process.exit(0);
              break;
          }
        });
      }
    });
  }
});
