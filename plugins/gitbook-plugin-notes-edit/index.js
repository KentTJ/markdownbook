'use strict';
var crypto = require('crypto');
function escapeHtml(value) {
  return String(value).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}
function entryName(sourcePath) {
  return 'note-' + crypto.createHash('sha256').update(sourcePath).digest('hex').slice(0, 16);
}
module.exports = {
  book: { assets: './assets', css: ['edit.css'] },
  hooks: {
    page: function (page) {
      var config = this.config.get('pluginsConfig.notes-edit') || {};
      var relative = String(page.path || '').replace(/\\/g, '/');
      if (!/\.md$/i.test(relative) || /(^|\/)(README|SUMMARY)\.md$/i.test(relative)) return page;
      var sourcePath = config.sourcePrefix + '/' + relative;
      var cms = 'https://app.pagescms.org/' + config.repository + '/' + config.branch;
      var editUrl = cms + '/file/' + entryName(sourcePath);
      var previewUrl = 'https://github.com/' + config.repository + '/actions';
      page.content = '<nav class="notes-edit-bar" aria-label="笔记编辑">' +
        '<a class="notes-edit-primary" href="' + escapeHtml(editUrl) + '" target="_blank" rel="noopener noreferrer">编辑本文</a>' +
        '<a href="' + escapeHtml(cms) + '" target="_blank" rel="noopener noreferrer">全部笔记</a>' +
        '<a href="' + escapeHtml(previewUrl) + '" target="_blank" rel="noopener noreferrer">更新进度</a>' +
        '</nav>' + page.content;
      return page;
    }
  },
  entryName: entryName
};
