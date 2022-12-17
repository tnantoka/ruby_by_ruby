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
    editors[id] = editor = ace.edit(elements[id], {
      mode: 'ace/mode/ruby',
      maxLines: Infinity,
      wrap: true,
      showPrintMargin: false,
      fontSize: 14,
    })
  });

  [...document.querySelectorAll('.ace_editor')]
    .forEach((element) => element.classList.add('border'));
})();

elements.run.addEventListener('click', () => {
  rubyVM.eval(editors.interpreter.getValue());
  rubyVM.eval(editors.example.getValue());
});

window.example = {
  reset: (value) => {
    elements.output.innerHTML = ''; 
  },
  log: (value) => {
    elements.output.innerHTML += `${value}\n`;
  }
};
