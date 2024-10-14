"use strict";(self.webpackChunkcomputer_architecture=self.webpackChunkcomputer_architecture||[]).push([[2169],{5680:(e,a,n)=>{n.d(a,{xA:()=>p,yg:()=>g});var r=n(6540);function i(e,a,n){return a in e?Object.defineProperty(e,a,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[a]=n,e}function t(e,a){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);a&&(r=r.filter((function(a){return Object.getOwnPropertyDescriptor(e,a).enumerable}))),n.push.apply(n,r)}return n}function l(e){for(var a=1;a<arguments.length;a++){var n=null!=arguments[a]?arguments[a]:{};a%2?t(Object(n),!0).forEach((function(a){i(e,a,n[a])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):t(Object(n)).forEach((function(a){Object.defineProperty(e,a,Object.getOwnPropertyDescriptor(n,a))}))}return e}function o(e,a){if(null==e)return{};var n,r,i=function(e,a){if(null==e)return{};var n,r,i={},t=Object.keys(e);for(r=0;r<t.length;r++)n=t[r],a.indexOf(n)>=0||(i[n]=e[n]);return i}(e,a);if(Object.getOwnPropertySymbols){var t=Object.getOwnPropertySymbols(e);for(r=0;r<t.length;r++)n=t[r],a.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(i[n]=e[n])}return i}var c=r.createContext({}),u=function(e){var a=r.useContext(c),n=a;return e&&(n="function"==typeof e?e(a):l(l({},a),e)),n},p=function(e){var a=u(e.components);return r.createElement(c.Provider,{value:a},e.children)},s="mdxType",d={inlineCode:"code",wrapper:function(e){var a=e.children;return r.createElement(r.Fragment,{},a)}},m=r.forwardRef((function(e,a){var n=e.components,i=e.mdxType,t=e.originalType,c=e.parentName,p=o(e,["components","mdxType","originalType","parentName"]),s=u(n),m=i,g=s["".concat(c,".").concat(m)]||s[m]||d[m]||t;return n?r.createElement(g,l(l({ref:a},p),{},{components:n})):r.createElement(g,l({ref:a},p))}));function g(e,a){var n=arguments,i=a&&a.mdxType;if("string"==typeof e||i){var t=n.length,l=new Array(t);l[0]=m;var o={};for(var c in a)hasOwnProperty.call(a,c)&&(o[c]=a[c]);o.originalType=e,o[s]="string"==typeof e?e:i,l[1]=o;for(var u=2;u<t;u++)l[u]=n[u];return r.createElement.apply(null,l)}return r.createElement.apply(null,n)}m.displayName="MDXCreateElement"},8096:(e,a,n)=>{n.r(a),n.d(a,{assets:()=>c,contentTitle:()=>l,default:()=>d,frontMatter:()=>t,metadata:()=>o,toc:()=>u});var r=n(8168),i=(n(6540),n(5680));const t={},l="Utilizare imagine Docker Linux",o={unversionedId:"Tutoriale/Docker/Linux/README",id:"Tutoriale/Docker/Linux/README",title:"Utilizare imagine Docker Linux",description:"Cerin\u021be necesare",source:"@site/docs/Tutoriale/Docker/Linux/README.md",sourceDirName:"Tutoriale/Docker/Linux",slug:"/Tutoriale/Docker/Linux/",permalink:"/computer-architecture/Tutoriale/Docker/Linux/",draft:!1,tags:[],version:"current",frontMatter:{},sidebar:"sidebar",previous:{title:"Utilizare imagine docker Windows",permalink:"/computer-architecture/Tutoriale/Docker/Windows/"},next:{title:"Utilizare imagine docker MacOS",permalink:"/computer-architecture/Tutoriale/Docker/MacOS/"}},c={},u=[{value:"Cerin\u021be necesare",id:"cerin\u021be-necesare",level:2},{value:"Rulare",id:"rulare",level:2},{value:"Op\u021biunea 1 din Visual Studio Code",id:"op\u021biunea-1-din-visual-studio-code",level:3},{value:"Op\u021biunea 2 prin docker",id:"op\u021biunea-2-prin-docker",level:3},{value:"Troubleshooting",id:"troubleshooting",level:2},{value:"Primesc eroare c\xe2nd scriu \xeen shell <code>vivado</code> / nu apare GUI-ul",id:"primesc-eroare-c\xe2nd-scriu-\xeen-shell-vivado--nu-apare-gui-ul",level:3},{value:"Devcontainer f\u0103r\u0103 GUI",id:"devcontainer-f\u0103r\u0103-gui",level:4},{value:"Setup manual de Docker f\u0103r\u0103 GUI",id:"setup-manual-de-docker-f\u0103r\u0103-gui",level:4},{value:"Am wayland. Ce fac?",id:"am-wayland-ce-fac",level:3},{value:"Am ecran alb c\xe2nd deschid cu Wayland",id:"am-ecran-alb-c\xe2nd-deschid-cu-wayland",level:3},{value:"Stuck la deschiderea hardware managerului",id:"stuck-la-deschiderea-hardware-managerului",level:3}],p={toc:u},s="wrapper";function d(e){let{components:a,...n}=e;return(0,i.yg)(s,(0,r.A)({},p,n,{components:a,mdxType:"MDXLayout"}),(0,i.yg)("h1",{id:"utilizare-imagine-docker-linux"},"Utilizare imagine Docker Linux"),(0,i.yg)("h2",{id:"cerin\u021be-necesare"},"Cerin\u021be necesare"),(0,i.yg)("ol",null,(0,i.yg)("li",{parentName:"ol"},"S\u0103 ave\u021bi VSCode instalat"),(0,i.yg)("li",{parentName:"ol"},"S\u0103 ave\u021bi un Desktop Environment sau un Window Manager ce ruleaz\u0103 cu X Server."),(0,i.yg)("li",{parentName:"ol"},"Asigura\u021bi-v\u0103 c\u0103 ave\u021bi instalat Docker CE (Aten\u021bie, nu Docker Desktop! Va fi nevoie de execu\u021bie cu privilegii pentru a redirec\u021biona folderul ",(0,i.yg)("inlineCode",{parentName:"li"},"/dev"),", ceea ce complic\u0103 \u0219i \xeengreuneaz\u0103 procesul)",(0,i.yg)("ul",{parentName:"li"},(0,i.yg)("li",{parentName:"ul"},(0,i.yg)("a",{parentName:"li",href:"https://docs.docker.com/engine/install/"},"Ubuntu/Fedora")),(0,i.yg)("li",{parentName:"ul"},"Arch: ",(0,i.yg)("inlineCode",{parentName:"li"},"sudo pacman -S docker"),(0,i.yg)("ul",{parentName:"li"},(0,i.yg)("li",{parentName:"ul"},"Dac\u0103 ave\u021bi deja Docker Desktop instalat de pe AUR, o s\u0103 v\u0103 apar\u0103 conflicte.\nV\u0103 apar pachetele conflictuale, e alegerea voastr\u0103 ce pachete p\u0103stra\u021bi.")))))),(0,i.yg)("h2",{id:"rulare"},"Rulare"),(0,i.yg)("h3",{id:"op\u021biunea-1-din-visual-studio-code"},"Op\u021biunea 1 din Visual Studio Code"),(0,i.yg)("ol",null,(0,i.yg)("li",{parentName:"ol"},"Deschide\u021bi directorul repo-ului \xeen Visual Studio Code.")),(0,i.yg)("pre",null,(0,i.yg)("code",{parentName:"pre",className:"language-bash"},"code computer-architecture\n")),(0,i.yg)("ol",{start:2},(0,i.yg)("li",{parentName:"ol"},(0,i.yg)("p",{parentName:"li"},"Instala\u021bi extensia ",(0,i.yg)("a",{parentName:"p",href:"https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers"},"Dev Containers"),".")),(0,i.yg)("li",{parentName:"ol"},(0,i.yg)("p",{parentName:"li"},'Dup\u0103 ve\u021bi avea op\u021biunea "Dev Containers: Reopen in container" (',(0,i.yg)("inlineCode",{parentName:"p"},"CTRL+SHIFT+P"),")."))),(0,i.yg)("h3",{id:"op\u021biunea-2-prin-docker"},"Op\u021biunea 2 prin docker"),(0,i.yg)("ol",null,(0,i.yg)("li",{parentName:"ol"},"Desc\u0103rca\u021bi imaginea cu docker")),(0,i.yg)("pre",null,(0,i.yg)("code",{parentName:"pre",className:"language-bash"},"docker pull gitlab.cs.pub.ro:5050/ac/ac-public/vivado-slim:1.0.0\n")),(0,i.yg)("ol",{start:2},(0,i.yg)("li",{parentName:"ol"},"Rula\u021bi un container cu imaginea")),(0,i.yg)("pre",null,(0,i.yg)("code",{parentName:"pre",className:"language-bash"},"docker run --rm -it -v /dev:/dev gitlab.cs.pub.ro:5050/ac/ac-public/vivado-slim:1.0.0 /bin/bash\n")),(0,i.yg)("ol",{start:3},(0,i.yg)("li",{parentName:"ol"},"Rula\u021bi vivado din imagine")),(0,i.yg)("pre",null,(0,i.yg)("code",{parentName:"pre",className:"language-bash"},"vivado\n")),(0,i.yg)("h2",{id:"troubleshooting"},"Troubleshooting"),(0,i.yg)("h3",{id:"primesc-eroare-c\xe2nd-scriu-\xeen-shell-vivado--nu-apare-gui-ul"},"Primesc eroare c\xe2nd scriu \xeen shell ",(0,i.yg)("inlineCode",{parentName:"h3"},"vivado")," / nu apare GUI-ul"),(0,i.yg)("p",null,"\xcenainte de a rula urm\u0103toarele solu\u021bii, ",(0,i.yg)("strong",{parentName:"p"},"asigura\u021bi-v\u0103 c\u0103 ",(0,i.yg)("inlineCode",{parentName:"strong"},".devcontainer/{sshd_config, Dockerfile, devcontainer.json}")," respect\u0103 cerin\u021bele de securitate impuse de voi"),".\nUrm\u0103toarea metod\u0103 o s\u0103 expun\u0103 un port la SSH pe un container privilegiat, neparolat, care are expus ",(0,i.yg)("inlineCode",{parentName:"p"},"/dev"),"-ul vostru. Asigureaz\u0103-te c\u0103 nu exist\u0103 posibilitatea ca o ma\u0219in\u0103 remote s\u0103 se poat\u0103 conecta la acel port sau modific\u0103 ",(0,i.yg)("inlineCode",{parentName:"p"},"sshd_config"),"-ul astfel \xeenc\xe2t s\u0103 respecte cerin\u021bele de securitate, sau schimb\u0103 parola de root (\xeen Dockerfile)."),(0,i.yg)("h4",{id:"devcontainer-f\u0103r\u0103-gui"},"Devcontainer f\u0103r\u0103 GUI"),(0,i.yg)("p",null,"Trebuie s\u0103 editezi fi\u0219ierul ",(0,i.yg)("inlineCode",{parentName:"p"},"devcontainer.json")," (liniile necesare sunt deja comentate, decomenteaz\u0103 ",(0,i.yg)("inlineCode",{parentName:"p"},"image"),") pentru a-l aduce \xeen urm\u0103torul format:"),(0,i.yg)("pre",null,(0,i.yg)("code",{parentName:"pre",className:"language-json"},'{\n    "name": "Vivado Slim Dev",\n    "build": { "dockerfile": "Dockerfile" },\n    // "image": "gitlab.cs.pub.ro:5050/ac/ac-public/vivado-slim:1.0.0",\n    "runArgs": [\n        "--rm",\n        "--privileged"\n    ],\n    "appPort": "2222:22",\n    "mounts": ["type=bind,source=/dev,target=/dev"],\n    //"otherPortsAttributes": {"requireLocalPort": "true", "elevateIfNeeded" : "true"},\n    "postStartCommand": "/usr/local/sbin/sshd",\n    "customizations": {\n        "vscode": {\n            "extensions": [\n                "mshr-h.veriloghdl"\n            ]\n        }\n    }\n}\n')),(0,i.yg)("p",null,"Dup\u0103, apas\u0103 ",(0,i.yg)("inlineCode",{parentName:"p"},"Ctrl+Shift+P")," \u0219i alege ",(0,i.yg)("inlineCode",{parentName:"p"},"Dev Containers: Rebuild and Reopen in Container"),"."),(0,i.yg)("p",null,"Pentru a putea accesa ",(0,i.yg)("inlineCode",{parentName:"p"},"GUI"),"-ul, deschide-\u021bi un terminal (nu cel din VSCode) \u0219i scrie ",(0,i.yg)("inlineCode",{parentName:"p"},"ssh -XY -p 2222 root@localhost"),".\nNu ar trebui s\u0103 introduci nicio parol\u0103.\nPo\u021bi modifica portul cu ce dore\u0219ti tu, at\xe2t timp c\xe2t modifici acest lucru \u0219i \xeen ",(0,i.yg)("inlineCode",{parentName:"p"},"devcontainer.json")," la ",(0,i.yg)("inlineCode",{parentName:"p"},"appPort"),"."),(0,i.yg)("h4",{id:"setup-manual-de-docker-f\u0103r\u0103-gui"},"Setup manual de Docker f\u0103r\u0103 GUI"),(0,i.yg)("p",null,"\xcen r\u0103d\u0103cina proiectului ",(0,i.yg)("inlineCode",{parentName:"p"},"computer-architecture"),", execut\u0103:"),(0,i.yg)("pre",null,(0,i.yg)("code",{parentName:"pre"},"cd .devcontainer\ndocker build -t vivado-slim-sshx .\ncd ..\ndocker run -it -v /dev:/dev -p 2222:22 -v $PWD:/workspaces/computer-architecture vivado-slim-sshx\n")),(0,i.yg)("h3",{id:"am-wayland-ce-fac"},"Am wayland. Ce fac?"),(0,i.yg)("p",null,"Va trebui s\u0103 faci ",(0,i.yg)("a",{parentName:"p",href:"#primesc-eroare-cand-scriu-in-shell-vivadonu-apare-gui-ul"},"pasul asta"),"."),(0,i.yg)("p",null,"Exist\u0103 2 op\u021biuni rapide:"),(0,i.yg)("ol",null,(0,i.yg)("li",{parentName:"ol"},"Instaleaz\u0103 Xwayland \u0219i urmeaz\u0103 setup-ul/configurarea pentru DE-ul/WM-ul t\u0103u."),(0,i.yg)("li",{parentName:"ol"},"Instaleaz\u0103 Xephyr \u0219i folose\u0219te comanda aceasta: ",(0,i.yg)("inlineCode",{parentName:"li"},"Xephyr -br -ac -noreset -screen 1920x1080 :1"),".\n\xcenlocuie\u0219te ",(0,i.yg)("inlineCode",{parentName:"li"},"1920x1080")," cu rezolu\u021bia folosit\u0103 de tine, o s\u0103 se deschid\u0103 o fereastr\u0103.\nDup\u0103, scrii ",(0,i.yg)("inlineCode",{parentName:"li"},"DISPLAY=:1 ssh -X -p 2222 root@localhost"),".\nGUI-ul de la Vivado va ap\u0103rea \xeen noua fereastr\u0103 deschis\u0103.\nS-ar putea s\u0103 fie nevoie \u0219i de un ",(0,i.yg)("inlineCode",{parentName:"li"},"unset XDG_SEAT")," ",(0,i.yg)("a",{parentName:"li",href:"https://unix.stackexchange.com/questions/690782/mouse-and-keyboard-not-getting-captured-by-xephyr"},"\xeen cazul \xeen care nu toate inputurile tastaturii sau mouse-ului sunt luate \xeen considerare"))),(0,i.yg)("p",null,"Mai multe detalii ",(0,i.yg)("a",{parentName:"p",href:"https://www.dbts-analytics.com/notesxfwdgb.html"},"aici")),(0,i.yg)("h3",{id:"am-ecran-alb-c\xe2nd-deschid-cu-wayland"},"Am ecran alb c\xe2nd deschid cu Wayland"),(0,i.yg)("p",null,"Scrie \xeen ",(0,i.yg)("inlineCode",{parentName:"p"},"shell"),", \xeenainte s\u0103 execu\u021bi Vivado, ",(0,i.yg)("inlineCode",{parentName:"p"},"export _JAVA_AWT_WM_NONREPARENTING=1"),".",(0,i.yg)("br",{parentName:"p"}),"\n","O alt\u0103 variant\u0103 este s\u0103 decommentezi linia din Dockerfile care d\u0103 ",(0,i.yg)("inlineCode",{parentName:"p"},"echo")," la aceast\u0103 linie \xeen ",(0,i.yg)("inlineCode",{parentName:"p"},".bashrc"),"."),(0,i.yg)("h3",{id:"stuck-la-deschiderea-hardware-managerului"},"Stuck la deschiderea hardware managerului"),(0,i.yg)("p",null,"\xcen terminalul din VSCode, scrie ",(0,i.yg)("inlineCode",{parentName:"p"},"hw_server"),".\nDac\u0103 o s\u0103 func\u021bioneze, o s\u0103 apar\u0103 un output sub urm\u0103torul format:"),(0,i.yg)("pre",null,(0,i.yg)("code",{parentName:"pre"},"****** Xilinx hw_server v2022.1\n  **** Build date : Apr 18 2022 at 16:10:30\n    ** Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.\n\nINFO: hw_server application started\nINFO: Use Ctrl-C to exit hw_server application\n\nINFO: To connect to this hw_server instance use url: TCP:ba86b6047b8c:3121\n")),(0,i.yg)("p",null,"Copiaz\u0103 ce este \xeentre ",(0,i.yg)("inlineCode",{parentName:"p"},"TCP:")," \u0219i ",(0,i.yg)("inlineCode",{parentName:"p"},":3121")," \u0219i folose\u0219te-l ca 'url' la conexiunea remote."))}d.isMDXComponent=!0}}]);