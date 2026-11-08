'use strict';
var fs = require('fs');
var path = require('path');
var crypto = require('crypto');
var assert = require('assert');
var root = path.resolve(__dirname, '..');
var sourceRoot = path.resolve(process.env.NOTES_SOURCE_ROOT || root);
var build = JSON.parse(fs.readFileSync(path.join(root, '.build/latest.json'), 'utf8'));
var config = JSON.parse(fs.readFileSync(path.join(root, '.pages.yml'), 'utf8'));
var entries = config.content.reduce(function (out, group) { return out.concat(group.items); }, []);
assert(new Set(entries.map(function (e) { return e.name; })).size === entries.length, 'CMS entry IDs must be unique');
var checks = [];
entries.forEach(function (e) {
  assert(fs.existsSync(path.join(sourceRoot, e.path)), 'Missing source ' + e.path);
  var match = e.path.match(/^(markdownsFile2?)\/markdownsFiles\/(.+)\.md$/);
  assert(match, 'Unknown source path ' + e.path);
  var html = path.join(build.site, match[1] === 'markdownsFile2' ? 'book2' : '', match[2] + '.html');
  assert(fs.existsSync(html), 'Missing rendered page ' + html);
  var text = fs.readFileSync(html, 'utf8');
  assert(text.indexOf('https://app.pagescms.org/KentTJ/markdownbook/notes-source/file/' + e.name) >= 0, 'Missing exact editor link ' + e.path);
  assert(text.indexOf('notes-edit-bar') >= 0, 'Missing edit toolbar ' + e.path);
  var advanced = 'https://github.dev/KentTJ/markdownbook/blob/notes-source/' + e.path.split('/').map(encodeURIComponent).join('/');
  assert(text.indexOf(advanced) >= 0, 'Missing exact advanced editor link ' + e.path);
  assert(text.indexOf('Commit &amp; Push') >= 0, 'Missing advanced editor publish instructions ' + e.path);
  checks.push(e.path);
});
build.manifest.forEach(function (file) {
  var current = crypto.createHash('sha256').update(fs.readFileSync(path.join(sourceRoot, file.path))).digest('hex');
  assert.strictEqual(current, file.sha256, 'Build changed the source file ' + file.path);
});
function countFiles(dir) {
  var count = 0;
  fs.readdirSync(dir, { withFileTypes: true }).forEach(function (entry) {
    assert(!entry.isSymbolicLink(), 'Deployment artifact must not contain symlinks');
    if (entry.isDirectory()) count += countFiles(path.join(dir, entry.name));
    else count++;
  });
  return count;
}
assert(fs.existsSync(path.join(build.site, 'index.html')), 'Missing main book home');
assert(fs.existsSync(path.join(build.site, 'book2/index.html')), 'Missing second book home');
['', 'book2'].forEach(function (prefix) {
  assert.strictEqual(fs.readFileSync(path.join(build.site, prefix, 'gitbook/gitbook-plugin-notes-edit/edit.css'), 'utf8'),
    fs.readFileSync(path.join(root, 'plugins/gitbook-plugin-notes-edit/assets/edit.css'), 'utf8'), 'Editor styles must be copied completely');
});
var report = { editableArticles: checks.length, sourceFilesUnchanged: build.manifest.length, publishedFiles: countFiles(build.site), editorLinksValid: true, sourceRoot: sourceRoot };
fs.writeFileSync(path.join(root, '.build/verification.json'), JSON.stringify(report, null, 2) + '\n');
console.log(JSON.stringify(report));
