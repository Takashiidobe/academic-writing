window.addEventListener('load', (_) => {
  new PagefindUI({ element: "#search" });
});

const targetNode = document.body;
const config = { attributes: false, childList: true, subtree: true };
const callback = (mutationList, observer) => {
  var links = document.querySelectorAll('.pagefind-ui__result-link');
  for (const link of links) {
    link.href = link.href.replace('/file:', 'file:');
  }
};


const observer = new MutationObserver(callback);
observer.observe(targetNode, config);

function appendCss(link, filepath) {
  var protocol = window.location.protocol;
  if (protocol === 'file:') {
    link.href = filepath;
  }
}

var newStyles = document.querySelector('#new-styles');
var pagefindStyles = document.querySelector('#pagefind-styles');

appendCss(newStyles, "/home/takashi/monorepo/notes/site/new.css", "/new.css");
appendCss(pagefindStyles, "/home/takashi/monorepo/notes/site/pagefind/pagefind-ui.css", "/pagefind/pagefind-ui.css");

var possibleLinks = Array.from(document.querySelectorAll('p > a')) || []

if (possibleLinks.length > 0) {
  var previousLinks = possibleLinks.map(a => a?.previousSibling?.textContent?.includes('Prev:') && a.href).filter(a => a);

  var nextLinks = possibleLinks.map(a => a?.previousSibling?.textContent?.includes('Next:') && a.href).filter(a => a);

  if (previousLinks.length > 0) {
    document.addEventListener('keydown', (e) => {
      if (e.keyCode == '104' || e.keyCode == '37') {
        window.location = previousLinks[0];
      }
    });
  }

  if (nextLinks.length > 0) {
    document.addEventListener('keydown', (e) => {
      if (e.keyCode == '108' || e.keyCode == '39') {
        window.location = nextLinks[0];
      }
    });
  }
}

const hidePageNode = document.head.querySelector('#hide-page');
hidePageNode.remove();
