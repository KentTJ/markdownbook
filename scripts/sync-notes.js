'use strict';
var cp = require('child_process');
var path = require('path');
var fs = require('fs');
function synchronize(root, action, remote, log) {
root = fs.realpathSync.native(path.resolve(root));
log = log || console.log;
function git(args, allowFailure) {
  var r = cp.spawnSync('git', args, { cwd: root, encoding: 'utf8', windowsHide: true, maxBuffer: 16 * 1024 * 1024 });
  if (r.error) throw r.error;
  if (r.status && !allowFailure) throw new Error((r.stderr || r.stdout || 'Git failed').trim());
  return r;
}
function output(args) { return git(args).stdout.trim(); }
  if (['sync', 'publish'].indexOf(action) < 0) throw new Error('Use: node scripts/sync-notes.js sync|publish');
  var actualRoot = fs.realpathSync.native(path.resolve(output(['rev-parse', '--show-toplevel'])));
  if (actualRoot.toLowerCase() !== root.toLowerCase()) throw new Error('Unexpected repository root.');
  if (output(['branch', '--show-current']) !== 'notes-source') throw new Error('请切换到 notes-source 分支后再同步。');
  if (output(['remote', 'get-url', 'origin']) !== remote) throw new Error('Remote repository does not match the configured notes repository.');
  if (output(['ls-files', '-u'])) throw new Error('请先解决现有 Git 冲突；本次未修改文件。');
  var status = output(['status', '--porcelain']);
  if (status && action === 'sync') throw new Error('本地有尚未提交的修改。请先运行 startBuild2.sh，保存并合并两端修改。');
  if (status && action === 'publish') {
    git(['add', '--all']);
    if (output(['diff', '--cached', '--name-only'])) {
      var c = git(['commit', '-m', 'Update notes from desktop']);
      log(c.stdout.trim());
    }
  }
  log('正在读取手机／网页端的最新内容……');
  git(['fetch', 'origin', 'notes-source']);
  var merge = git(['merge', '--no-edit', 'FETCH_HEAD'], true);
  if (merge.status !== 0) {
    var conflicts = output(['diff', '--name-only', '--diff-filter=U']);
    var mergeHead = git(['rev-parse', '-q', '--verify', 'MERGE_HEAD'], true);
    if (!mergeHead.status) git(['merge', '--abort']);
    throw new Error('两端修改存在冲突，已保留本地提交并停止发布，请协助合并：\n' + (conflicts || merge.stderr || merge.stdout));
  }
  if (action === 'publish') {
    log('正在提交源文件，云端随后自动更新网页……');
    git(['push', 'origin', 'HEAD:notes-source']);
    log('源文件已同步。网页构建进度：https://github.com/KentTJ/markdownbook/actions');
  } else log('网页端修改已同步到本地 MD。');
}
module.exports = synchronize;
if (require.main === module) {
  try { synchronize(path.resolve(__dirname, '..'), process.argv[2] || 'sync', 'git@github.com:KentTJ/markdownbook.git'); }
  catch (e) { console.error(e.message); process.exitCode = 1; }
}
