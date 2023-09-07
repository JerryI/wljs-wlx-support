class WLXCell {
    dispose() {
      
    }
    
    constructor(parent, data) {
      let string = data;

      const r = {
        fe: new RegExp(/FrontEndExecutable\[([^\[|\]]+)\]/g),
        feh: new RegExp(/FrontEndExecutableHold\[([^\[|\]]+)\]/g)
      };
      
      const fe = [];


      const feReplacer = (fe, offset=0) => {
        return function (match, index) {
          const uid = match.slice(19 + offset,-1);
          fe.push(uid);
          return `<div id="${uid}" class="wlx-frontend-object"></div>`;
        }
      } 

      //extract FE objects
      string = string.replace(r.fe, feReplacer(fe));
      string = string.replace(r.feh, feReplacer(fe, 4));

      setInnerHTML(parent.element, string);
      parent.element.classList.add('padding-fix');

      fe.forEach((obj, i) => {
        setTimeout(async () => {
          const cuid = Date.now() + Math.floor(Math.random() * 10009);
          var global = {call: cuid};
      
          let env = {global: global, element: document.getElementById(obj)}; //Created in CM6
          console.log("CM6: creating an object with key "+this.name);
          const fobj = new ExecutableObject(obj, env);
          fobj.execute()     
      
          self.ref.push(fobj);          
        }, (i+1) * 200)
      });

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

