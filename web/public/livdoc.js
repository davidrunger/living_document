document.addEventListener('keydown', event => {
  if (event.key === 'Enter') {
    if (event.metaKey) {
      // The user has hit `Cmd + Enter`; evaluate the code and update the document.
      const frontmatterEl = document.getElementById('frontmatter')
      const scratchpadEl = document.getElementById('scratchpad')
      let caretPosition = Cursor.getCurrentCursorPosition(scratchpadEl);
      postData('/run_code', {
        frontmatter: frontmatterEl.innerText,
        code: scratchpadEl.innerText,
      }).then(data => {
        scratchpadEl.innerText = data.evaluated_code;
        Cursor.setCurrentCursorPosition(caretPosition, scratchpadEl);
        const renderedMarkdownEl = document.getElementById('rendered-markdown');
        renderedMarkdownEl.innerHTML = data.rendered_markdown
      });
    } else {
      // The user has hit Enter to add a newline.
      // Avoid adding extra newlines (https://stackoverflow.com/a/61237402/4009384).
      document.execCommand('insertLineBreak');
      event.preventDefault();
    }
  }
});
