class WLXCell {
    dispose() {
      
    }
    
    constructor(parent, data) {
      setInnerHTML(parent.element, data);
      parent.element.classList.add('padding-fix');
      return this;
    }
  }
  
  window.SupportedLanguages.push({
    check: (r) => {return(r[0] === '.wlx')},
    plugins: [window.html()],
    name: window.htmlLanguage.name
  });

  window.SupportedCells['wlx'] = {
    view: WLXCell
  };
