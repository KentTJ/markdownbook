'use strict';
var fs = require('fs');
var path = require('path');
var Q = require('q');
var outputRoot = path.resolve(process.argv[3]);
// GitBook 3's cpr@1.1.1 confirms copied files on the read stream's "end",
// before the write stream finishes. This causes intermittent ENOENT errors.
// Only its two plugin-asset copy calls use copyDir. Complete those writes
// synchronously, without altering any installed package or source document.
require('gitbook/lib/utils/fs').copyDir = function (from, to, options) {
  return Q.fcall(function () {
    var relative = path.relative(path.join(outputRoot, 'gitbook'), path.resolve(to));
    if (relative === '..' || relative.indexOf('..' + path.sep) === 0 || path.isAbsolute(relative)) {
      throw new Error('Plugin asset output escaped the build directory');
    }
    if (options.deleteFirst || options.overwrite !== true) throw new Error('Unexpected plugin copy options');
    function copyDir(source, destination) {
      fs.mkdirSync(destination, { recursive: true });
      fs.readdirSync(source, { withFileTypes: true }).forEach(function (entry) {
        var src = path.join(source, entry.name), dst = path.join(destination, entry.name);
        if (entry.isSymbolicLink()) throw new Error('Unexpected symlink in plugin assets');
        if (entry.isDirectory()) copyDir(src, dst);
        else fs.copyFileSync(src, dst);
      });
    }
    copyDir(from, to);
  });
};
require('gitbook/lib/cli/build').exec(process.argv.slice(2), {
  log: 'info', format: 'website', timing: false
}).then(function () {
  console.log('BOOK_BUILD_OK');
}).catch(function (error) {
  console.error(error.stack || error.message || String(error));
  process.exitCode = 1;
});
