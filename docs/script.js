const elements = [
  'interpreter',
  'example',
  'run',
  'output',
].reduce(
  (result, id) => ({ ...result, [id]: document.querySelector(`[data-id="${id}"]`) }),
  {}
);

const editors = {};

(async () => {
  elements.interpreter.value = await (await fetch(`lib/ruby_by_ruby/interpreter.rb`)).text();
  elements.example.value = await (await fetch(`docs/example.rb`)).text();

  ace.config.set('basePath', 'https://cdn.jsdelivr.net/npm/ace-builds@1.14.0/src-noconflict/');

  ['interpreter', 'example'].forEach((id) => {
    const editor = ace.edit(elements[id], {
      mode: 'ace/mode/ruby',
      maxLines: Infinity,
      wrap: true,
      showPrintMargin: false,
      fontSize: 14,
    })
    editor.container.classList.add('border');
    editors[id] = editor;
  });
})();

elements.run.addEventListener('click', () => {
  rubyVM.eval(editors.interpreter.getValue());
  rubyVM.eval(editors.example.getValue());
});
