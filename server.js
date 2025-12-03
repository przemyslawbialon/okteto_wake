const http = require('http');
const { exec } = require('child_process');
const fs = require('fs');
const path = require('path');

const PORT = 3333;
const DAPULSE_PATH = path.join(process.env.HOME, 'Development/dapulse');
const NODE_MODULES_PATH = path.join(DAPULSE_PATH, 'node_modules');

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type',
  'Content-Type': 'application/json'
};

function sendJson(res, statusCode, data) {
  res.writeHead(statusCode, corsHeaders);
  res.end(JSON.stringify(data));
}

function runCommand(cmd, cwd = null) {
  return new Promise((resolve, reject) => {
    const options = cwd ? { cwd, shell: '/bin/zsh' } : { shell: '/bin/zsh' };
    exec(cmd, options, (error, stdout, stderr) => {
      if (error) {
        reject({ error: error.message, stderr });
      } else {
        resolve({ stdout, stderr });
      }
    });
  });
}

async function deleteNodeModules(res) {
  try {
    if (!fs.existsSync(NODE_MODULES_PATH)) {
      return sendJson(res, 200, { success: true, message: 'node_modules does not exist' });
    }
    
    await runCommand(`rm -rf "${NODE_MODULES_PATH}"`);
    sendJson(res, 200, { success: true, message: 'node_modules deleted successfully' });
  } catch (err) {
    sendJson(res, 500, { success: false, error: err.error || err.message });
  }
}

async function restartWebpack(res) {
  try {
    await runCommand('pkill -f "webpack" || true');
    
    const child = exec(
      'source ~/.zshrc && start-webpack',
      { cwd: DAPULSE_PATH, shell: '/bin/zsh', detached: true }
    );
    child.unref();
    
    sendJson(res, 200, { success: true, message: 'Webpack restart initiated' });
  } catch (err) {
    sendJson(res, 500, { success: false, error: err.error || err.message });
  }
}

async function getStatus(res) {
  const status = {
    nodeModulesExists: fs.existsSync(NODE_MODULES_PATH),
    dapulsePathExists: fs.existsSync(DAPULSE_PATH)
  };
  
  try {
    const { stdout } = await runCommand('pgrep -f webpack || echo ""');
    status.webpackRunning = stdout.trim().length > 0;
  } catch {
    status.webpackRunning = false;
  }
  
  sendJson(res, 200, status);
}

function serveHtml(res) {
  const htmlPath = path.join(__dirname, 'index.html');
  fs.readFile(htmlPath, (err, data) => {
    if (err) {
      res.writeHead(404);
      res.end('Not found');
      return;
    }
    res.writeHead(200, { 'Content-Type': 'text/html' });
    res.end(data);
  });
}

const server = http.createServer(async (req, res) => {
  if (req.method === 'OPTIONS') {
    res.writeHead(204, corsHeaders);
    res.end();
    return;
  }

  const url = req.url;

  if (url === '/' || url === '/index.html') {
    return serveHtml(res);
  }

  if (url === '/api/delete-node-modules' && req.method === 'POST') {
    return deleteNodeModules(res);
  }

  if (url === '/api/restart-webpack' && req.method === 'POST') {
    return restartWebpack(res);
  }

  if (url === '/api/status' && req.method === 'GET') {
    return getStatus(res);
  }

  sendJson(res, 404, { error: 'Not found' });
});

server.listen(PORT, () => {
  console.log(`🚀 Okteto Dashboard running at http://localhost:${PORT}`);
  console.log(`   - DELETE node_modules: POST /api/delete-node-modules`);
  console.log(`   - Restart webpack:     POST /api/restart-webpack`);
  console.log(`   - Status:              GET  /api/status`);
});

