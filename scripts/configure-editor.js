'use strict';
var fs = require('fs');
var path = require('path');
var plugin = require('../plugins/gitbook-plugin-notes-edit');
var root = path.resolve(__dirname, '..');
var sourceRoot = path.resolve(process.env.NOTES_SOURCE_ROOT || root);
var labels = {
  'ReadingAndThinking.md': '思考与学习',
  'Investment.md': '投资',
  'communication.md': '沟通与管理',
  'debugSkills.md': '调试技巧',
  'HowToReadCode.md': '阅读代码与定位问题',
  'HowWritecode.md': '编写代码',
  'Input.md': '输入系统',
  '性能_.md': '性能优化'
};
function walk(folder, prefix) {
  var result = [];
  fs.readdirSync(folder, { withFileTypes: true }).forEach(function (e) {
    if (['_book', 'node_modules', '.git'].indexOf(e.name) >= 0 || /\.assets$/.test(e.name)) return;
    var rel = prefix + '/' + e.name;
    if (e.isDirectory()) result = result.concat(walk(path.join(folder, e.name), rel));
    else if (e.isFile() && /\.md$/i.test(e.name) && !/^(README|SUMMARY)\.md$/i.test(e.name)) {
      result.push({
        name: plugin.entryName(rel),
        label: (labels[e.name] || e.name.slice(0, -3)),
        type: 'file', path: rel,
        format: 'yaml-frontmatter',
        operations: { rename: false, delete: false },
        fields: [{ name: 'body', label: '正文（Markdown）', type: 'text', description: '修改后点击 Save 保存。网页会在自动构建成功后更新；代码块、图片链接和原有格式请保留。' }]
      });
    }
  });
  return result.sort(function (a, b) { return a.path.localeCompare(b.path, 'zh-CN'); });
}
var content = [
  { name: 'book1', label: '技术与思考', type: 'group', items: walk(path.join(sourceRoot, 'markdownsFile/markdownsFiles'), 'markdownsFile/markdownsFiles') },
  { name: 'book2', label: '投资、生活与工具', type: 'group', items: walk(path.join(sourceRoot, 'markdownsFile2/markdownsFiles'), 'markdownsFile2/markdownsFiles') }
];
var config = { content: content };
// JSON is also valid YAML; this avoids changing Chinese paths or quoting rules.
fs.writeFileSync(path.join(root, '.pages.yml'), JSON.stringify(config, null, 2) + '\n');
console.log('Configured ' + content.reduce(function (sum, g) { return sum + g.items.length; }, 0) + ' editable articles.');
