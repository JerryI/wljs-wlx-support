let count = 0;

class WLXCell {
    envs = []

    dispose() {
      console.warn('WLX cell dispose...');
      for (const env of this.envs) {
        for (const obj of Object.values(env.global.stack))  {
          console.log('dispose');
          obj.dispose();
        }
      }
    }
    
    constructor(parent, data) {
      let string = data;
      count++;

      const r = {
        fe: new RegExp(/FrontEndExecutable\[([^\[|\]]+)\]/g),
        feh: new RegExp(/FrontEndExecutableHold\[([^\[|\]]+)\]/g)
      };
      
      const fe = [];

      const self = this;

      const feReplacer = (fe, offset=0) => {
        return function (match, index) {
          const uid = match.slice(19 + offset,-1);
          count++;
          fe.push([uid, count]);
          return `<div id="wlx-${count}-${uid}" class="wlx-frontend-object"></div>`;
        }
      } 

      //extract FE objects
      string = string.replace(r.fe, feReplacer(fe));
      string = string.replace(r.feh, feReplacer(fe, 4));

      setInnerHTML(parent.element, string);
      parent.element.classList.add('padding-fix');

      const runOverFe = async function () {
        for (const o of fe) {
          const uid = o[0];
          const c   = o[1];

          const cuid = Date.now() + Math.floor(Math.random() * 10009);
          var global = {call: cuid};
      
          let env = {global: global, element: document.getElementById(`wlx-${c}-${uid}`)}; 
          console.log("WLX: creating an object with key "+self.name);


          console.log('forntend executable');

          let obj;
          console.log('check cache');
          if (ObjectHashMap[uid]) {
              obj = ObjectHashMap[uid];
          } else {
              obj = new ObjectStorage(uid);
          }
          console.log(obj);
      
          const copy = env;
          const store = await obj.get();
          const instance = new ExecutableObject('wlx-stored-'+uuidv4(), copy, store);
          instance.assignScope(copy);
          obj.assign(instance);
      
          instance.execute();          
      
          self.envs.push(env);          
      };
    };

    runOverFe();

      return this;
    }
  }

  const codemirror = window.SupportedCells['codemirror'].context; 
  
  window.SupportedLanguages.push({
    check: (r) => {return(r[0] === '.wlx')},
    plugins: [codemirror.html()],
    name: codemirror.htmlLanguage.name
  });

  window.SupportedCells['wlx'] = {
    view: WLXCell
  };

