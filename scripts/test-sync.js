'use strict';
// Exercise real Git merges in disposable repositories; never contacts GitHub.
var fs = require('fs'), path = require('path'), os = require('os');
var cp = require('child_process'), assert = require('assert');
var sync = require('./sync-notes');
var dir = fs.mkdtempSync(path.join(os.tmpdir(), 'notes-sync-test-'));
var origin = path.join(dir, 'origin.git'), pc = path.join(dir, 'pc'), phone = path.join(dir, 'phone');
function git(cwd, args) {
  var r = cp.spawnSync('git', args, { cwd: cwd, encoding: 'utf8', windowsHide: true });
  if (r.status !== 0) throw new Error(r.stderr || r.stdout);
  return r.stdout.trim();
}
function identity(repo) {
  git(repo, ['config', 'user.name', 'Notes sync test']);
  git(repo, ['config', 'user.email', 'notes-test@example.invalid']);
  git(repo, ['config', 'core.autocrlf', 'false']);
}
function write(repo, name, content) { fs.writeFileSync(path.join(repo, name), content); }
function commit(repo, message) { git(repo, ['add', '--all']); git(repo, ['commit', '-m', message]); }
git(dir, ['init', '--bare', origin]);
git(dir, ['init', '-b', 'notes-source', pc]);
identity(pc);
git(pc, ['remote', 'add', 'origin', origin]);
write(pc, 'one.md', 'original\n'); write(pc, 'two.md', 'original\n'); commit(pc, 'baseline');
git(pc, ['push', '-u', 'origin', 'notes-source']);
git(dir, ['clone', '-b', 'notes-source', origin, phone]); identity(phone);
write(phone, 'one.md', 'from phone\n'); commit(phone, 'phone edit'); git(phone, ['push']);
sync(pc, 'sync', origin, function () {});
assert.strictEqual(fs.readFileSync(path.join(pc, 'one.md'), 'utf8'), 'from phone\n');
write(pc, 'two.md', 'local work\n');
assert.throws(function () { sync(pc, 'sync', origin, function () {}); }, /尚未提交/);
assert.strictEqual(fs.readFileSync(path.join(pc, 'two.md'), 'utf8'), 'local work\n');
write(phone, 'one.md', 'another phone edit\n'); commit(phone, 'second phone edit'); git(phone, ['push']);
sync(pc, 'publish', origin, function () {});
assert.strictEqual(fs.readFileSync(path.join(pc, 'one.md'), 'utf8'), 'another phone edit\n');
assert.strictEqual(fs.readFileSync(path.join(pc, 'two.md'), 'utf8'), 'local work\n');
git(phone, ['pull', '--ff-only']);
write(phone, 'one.md', 'phone conflict\n'); commit(phone, 'conflicting phone edit'); git(phone, ['push']);
var remoteBefore = git(phone, ['rev-parse', 'HEAD']);
write(pc, 'one.md', 'pc conflict\n');
assert.throws(function () { sync(pc, 'publish', origin, function () {}); }, /存在冲突/);
assert.strictEqual(fs.readFileSync(path.join(pc, 'one.md'), 'utf8'), 'pc conflict\n');
assert.strictEqual(git(pc, ['status', '--porcelain']), '');
assert.strictEqual(git(pc, ['ls-remote', 'origin', 'notes-source']).split(/\s/)[0], remoteBefore);
assert.throws(function () { sync(pc, 'publish', origin + '-wrong', function () {}); }, /does not match/);
console.log(JSON.stringify({ downloadedPhoneEdit: true, dirtyFilesProtected: true, mergedIndependentEdits: true, conflictingEditsPreserved: true, remoteUnchangedOnConflict: true, wrongRemoteRejected: true }));
