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
      var advancedUrl = 'https://github.dev/' + config.repository + '/blob/' + encodeURIComponent(config.branch) + '/' +
        sourcePath.split('/').map(encodeURIComponent).join('/');
      var previewUrl = 'https://github.com/' + config.repository + '/actions';
      page.content = '<nav class="notes-edit-bar" aria-label="笔记编辑">' +
        '<a class="notes-edit-primary" href="' + escapeHtml(editUrl) + '" target="_blank" rel="noopener noreferrer">编辑本文</a>' +
        '<a class="notes-edit-advanced" href="' + escapeHtml(advancedUrl) + '" target="_blank" rel="noopener noreferrer" title="电脑端：章节目录、全文搜索和 Markdown 预览">目录 / 搜索编辑</a>' +
        '<a href="' + escapeHtml(cms) + '" target="_blank" rel="noopener noreferrer">全部笔记</a>' +
        '<a href="' + escapeHtml(previewUrl) + '" target="_blank" rel="noopener noreferrer">更新进度</a>' +
        '<details class="notes-edit-help"><summary>高级编辑怎么用？</summary><div>' +
        '<p>在左侧大纲（Outline）点击章节标题，或在编辑区按 <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>O</kbd> 搜索标题；' +
        '<kbd>Ctrl</kbd> + <kbd>F</kbd> 搜索正文；<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>V</kbd> 打开排版预览。</p>' +
        '<p>改完后，在左侧源代码管理（Source Control）写一句修改说明，点击 <strong>Commit &amp; Push</strong> 提交并推送，网页随后自动更新。' +
        '仅按 Ctrl + S 会保留浏览器中的修改，不会发布到网站。</p>' +
        '</div></details></nav>' + page.content;
      return page;
    }
  },
  entryName: entryName
};
