'use strict';
var fs = require('fs');
var path = require('path');
var crypto = require('crypto');
var child = require('child_process');
process.on('uncaughtException', function (error) {
  var detail = String(error.stack || error);
  console.error(detail);
  if (process.env.GITHUB_ACTIONS) console.error('::error::' + detail.replace(/%/g, '%25').replace(/\r/g, '%0D').replace(/\n/g, '%0A'));
  process.exitCode = 1;
});
var root = path.resolve(__dirname, '..');
var sourceRoot = path.resolve(process.env.NOTES_SOURCE_ROOT || root);
var workRoot = path.join(root, '.build');
fs.mkdirSync(workRoot, { recursive: true });
var runRoot = fs.mkdtempSync(path.join(workRoot, 'run-'));
var site = path.join(runRoot, 'site');
var books = [
  { name: 'markdownsFile', destination: '', label: '技术与思考' },
  { name: 'markdownsFile2', destination: 'book2', label: '投资与工具' }
];
var excluded = new Set(['_book', 'node_modules', '.git', '.DS_Store', 'Thumbs.db', 'desktop.ini']);
var manifest = [];
function copyTree(from, to, prefix) {
  fs.mkdirSync(to, { recursive: true });
  fs.readdirSync(from, { withFileTypes: true }).forEach(function (entry) {
    if (excluded.has(entry.name)) return;
    var src = path.join(from, entry.name), dst = path.join(to, entry.name);
    var rel = prefix + '/' + entry.name;
    if (entry.isSymbolicLink()) throw new Error('Source symlinks are not supported: ' + rel);
    if (entry.isDirectory()) return copyTree(src, dst, rel);
    if (!entry.isFile()) throw new Error('Unsupported source entry: ' + rel);
    fs.copyFileSync(src, dst);
    manifest.push({ path: rel, sha256: crypto.createHash('sha256').update(fs.readFileSync(src)).digest('hex') });
  });
}
function run(args, cwd) {
  var result = child.spawnSync(process.execPath, args, { cwd: cwd, encoding: 'utf8', maxBuffer: 32 * 1024 * 1024 });
  if (result.stdout) process.stdout.write(result.stdout);
  if (result.stderr) process.stderr.write(result.stderr);
  if (result.error) throw result.error;
  if (result.status !== 0) throw new Error('Build step failed, exit ' + result.status + '\n' + ((result.stdout || '') + '\n' + (result.stderr || '')).slice(-6000));
  if (/Failed to load prism syntax|(?:^|\n)(?:Error|TypeError|SyntaxError|ReferenceError):/.test((result.stdout || '') + (result.stderr || ''))) {
    var lines = ((result.stdout || '') + '\n' + (result.stderr || '')).split('\n');
    throw new Error('Build reported a rendering error\n' + lines.filter(function (line) { return /Failed to load prism syntax|Error:|Cannot find module/.test(line); }).join('\n').slice(-6000));
  }
}
books.forEach(function (book) {
  var original = path.join(sourceRoot, book.name);
  var staged = path.join(runRoot, book.name);
  var content = path.join(staged, 'markdownsFiles');
  copyTree(path.join(original, 'markdownsFiles'), content, book.name + '/markdownsFiles');
  var config = JSON.parse(fs.readFileSync(path.join(original, 'book.json'), 'utf8'));
  config.plugins = (config.plugins || []).filter(function (name) { return name !== 'notes-edit'; }).concat(['notes-edit']);
  config.pluginsConfig = config.pluginsConfig || {};
  config.pluginsConfig['notes-edit'] = {
    repository: 'KentTJ/markdownbook', branch: 'notes-source', sourcePrefix: book.name + '/markdownsFiles'
  };
  config.pluginsConfig.prism = config.pluginsConfig.prism || {};
  config.pluginsConfig.prism.lang = Object.assign({}, config.pluginsConfig.prism.lang, { flow: 'typescript', shell: 'bash' });
  fs.writeFileSync(path.join(staged, 'book.json'), JSON.stringify(config, null, 2) + '\n');
  fs.writeFileSync(path.join(staged, '.bookignore'), '_book\nnode_modules\n');
  // GitBook 3 scans the book's own node_modules directory, not ancestor folders.
  fs.symlinkSync(path.join(root, 'node_modules'), path.join(staged, 'node_modules'), process.platform === 'win32' ? 'junction' : 'dir');
  run([require.resolve('gitbook-summary/bin/summary.js'), 'sm'], content);
  // gitbook-summary URL-encodes spaces, while GitBook 3 resolves source paths
  // literally; use existing local paths so those articles are rendered too.
  var summaryPath = path.join(content, 'SUMMARY.md');
  var summary = fs.readFileSync(summaryPath, 'utf8').replace(/\]\(([^)]+)\)/g, function (link, ref) {
    if (/^[a-z]+:/i.test(ref)) return link;
    var decoded;
    try { decoded = decodeURI(ref); } catch (e) { return link; }
    return fs.existsSync(path.join(content, decoded)) ? '](' + decoded + ')' : link;
  });
  fs.writeFileSync(summaryPath, summary);
  // The home page is the table of contents, generated before rendering.
  fs.copyFileSync(path.join(content, 'SUMMARY.md'), path.join(content, 'README.md'));
  run([path.join(__dirname, 'build-one.js'), staged, path.join(site, book.destination)], root);
});
// Only a successful build can produce the deployment manifest.
fs.writeFileSync(path.join(site, '.nojekyll'), '');
fs.writeFileSync(path.join(site, 'notes-build.json'), JSON.stringify({ sourceCommit: process.env.GITHUB_SHA || null, builtAt: new Date().toISOString() }, null, 2));
var result = { site: site, runRoot: runRoot, sourceFiles: manifest.length, manifest: manifest };
fs.writeFileSync(path.join(workRoot, 'latest.json'), JSON.stringify(result, null, 2) + '\n');
if (process.env.GITHUB_OUTPUT) fs.appendFileSync(process.env.GITHUB_OUTPUT, 'site=' + site + '\n');
console.log('NOTES_BUILD_OK ' + site);
