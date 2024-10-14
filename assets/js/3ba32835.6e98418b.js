"use strict";(self.webpackChunkcomputer_architecture=self.webpackChunkcomputer_architecture||[]).push([[3006],{5680:(e,a,i)=>{i.d(a,{xA:()=>p,yg:()=>d});var r=i(6540);function t(e,a,i){return a in e?Object.defineProperty(e,a,{value:i,enumerable:!0,configurable:!0,writable:!0}):e[a]=i,e}function n(e,a){var i=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);a&&(r=r.filter((function(a){return Object.getOwnPropertyDescriptor(e,a).enumerable}))),i.push.apply(i,r)}return i}function l(e){for(var a=1;a<arguments.length;a++){var i=null!=arguments[a]?arguments[a]:{};a%2?n(Object(i),!0).forEach((function(a){t(e,a,i[a])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(i)):n(Object(i)).forEach((function(a){Object.defineProperty(e,a,Object.getOwnPropertyDescriptor(i,a))}))}return e}function o(e,a){if(null==e)return{};var i,r,t=function(e,a){if(null==e)return{};var i,r,t={},n=Object.keys(e);for(r=0;r<n.length;r++)i=n[r],a.indexOf(i)>=0||(t[i]=e[i]);return t}(e,a);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);for(r=0;r<n.length;r++)i=n[r],a.indexOf(i)>=0||Object.prototype.propertyIsEnumerable.call(e,i)&&(t[i]=e[i])}return t}var u=r.createContext({}),c=function(e){var a=r.useContext(u),i=a;return e&&(i="function"==typeof e?e(a):l(l({},a),e)),i},p=function(e){var a=c(e.components);return r.createElement(u.Provider,{value:a},e.children)},m="mdxType",s={inlineCode:"code",wrapper:function(e){var a=e.children;return r.createElement(r.Fragment,{},a)}},g=r.forwardRef((function(e,a){var i=e.components,t=e.mdxType,n=e.originalType,u=e.parentName,p=o(e,["components","mdxType","originalType","parentName"]),m=c(i),g=t,d=m["".concat(u,".").concat(g)]||m[g]||s[g]||n;return i?r.createElement(d,l(l({ref:a},p),{},{components:i})):r.createElement(d,l({ref:a},p))}));function d(e,a){var i=arguments,t=a&&a.mdxType;if("string"==typeof e||t){var n=i.length,l=new Array(n);l[0]=g;var o={};for(var u in a)hasOwnProperty.call(a,u)&&(o[u]=a[u]);o.originalType=e,o[m]="string"==typeof e?e:t,l[1]=o;for(var c=2;c<n;c++)l[c]=i[c];return r.createElement.apply(null,l)}return r.createElement.apply(null,i)}g.displayName="MDXCreateElement"},1522:(e,a,i)=>{i.r(a),i.d(a,{assets:()=>u,contentTitle:()=>l,default:()=>s,frontMatter:()=>n,metadata:()=>o,toc:()=>c});var r=i(8168),t=(i(6540),i(5680));const n={},l="Descriere comportamental\u0103",o={unversionedId:"Laboratoare/2 Verilog Combina\u021bional/Operatori/Teorie/README",id:"Laboratoare/2 Verilog Combina\u021bional/Operatori/Teorie/README",title:"Descriere comportamental\u0103",description:"Laboratorul curent va prezenta elementele Verilog folosite pentru descrierea comportamental\u0103. Aceasta poate descrie ce face circuitul \u0219i nu cum va fi acesta implementat. Mai mult, vom completa un modul func\u021bional cu un modul de testare, astfel \xeenc\xe2t s\u0103 avem posibilitatea de a verifica implementarea pe care o concepem.",source:"@site/docs/Laboratoare/2 Verilog Combina\u021bional/Operatori/Teorie/README.md",sourceDirName:"Laboratoare/2 Verilog Combina\u021bional/Operatori/Teorie",slug:"/Laboratoare/2 Verilog Combina\u021bional/Operatori/Teorie/",permalink:"/computer-architecture/Laboratoare/2 Verilog Combina\u021bional/Operatori/Teorie/",draft:!1,tags:[],version:"current",frontMatter:{},sidebar:"sidebar",previous:{title:"Operatori",permalink:"/computer-architecture/Laboratoare/2 Verilog Combina\u021bional/Operatori/"},next:{title:"Practice: Operators",permalink:"/computer-architecture/Laboratoare/2 Verilog Combina\u021bional/Operatori/Practic\u0103/"}},u={},c=[{value:"Assign",id:"assign",level:2},{value:"Exemplu atribuire continu\u0103",id:"exemplu-atribuire-continu\u0103",level:3},{value:"Constante",id:"constante",level:2},{value:"Operatori",id:"operatori",level:2}],p={toc:c},m="wrapper";function s(e){let{components:a,...n}=e;return(0,t.yg)(m,(0,r.A)({},p,n,{components:a,mdxType:"MDXLayout"}),(0,t.yg)("h1",{id:"descriere-comportamental\u0103"},"Descriere comportamental\u0103"),(0,t.yg)("p",null,"Laboratorul curent va prezenta elementele Verilog folosite pentru descrierea comportamental\u0103. Aceasta poate descrie ",(0,t.yg)("strong",{parentName:"p"},"ce face")," circuitul \u0219i nu ",(0,t.yg)("strong",{parentName:"p"},"cum")," va fi acesta implementat. Mai mult, vom completa un modul func\u021bional cu un modul de testare, astfel \xeenc\xe2t s\u0103 avem posibilitatea de a verifica implementarea pe care o concepem."),(0,t.yg)("h2",{id:"assign"},"Assign"),(0,t.yg)("p",null,"De\u0219i parti\u021bionarea circuitelor \xeen cadrul unei arhitecturi duce la simplificarea implement\u0103rii unui modul, implementarea acestuia la nivel de por\u021bi logice este rareori folosit\u0103, \xeentruc\xe2t aceasta devine complicat\u0103 \u0219i dificil de \xeen\u021beles."),(0,t.yg)("p",null,"Primul pas este reprezentat de u\u0219urarea modalit\u0103\u021bii de scriere a unei func\u021bii logice. Pentru aceasta, Verilog ofer\u0103 o instruc\u021biune numit\u0103 ",(0,t.yg)("strong",{parentName:"p"},"atribuire continu\u0103"),". Aceasta folose\u0219te cuv\xe2ntul cheie ''assign'' \u0219i \u201catribuie\u201d unei variabile de tip ''wire'', valoarea expresiei aflat\u0103 \xeen partea dreapt\u0103 a semnului egal. Atribuirea are loc la fiecare moment de timp, deci orice schimbare a valorii expresiei din partea dreapt\u0103 se va propaga imediat.\n\xcen partea st\xe2ng\u0103 a unei atribuiri continue se poate afla orice variabil\u0103 declarat\u0103 de tip wire sau orice ie\u0219ire a modulului care nu are alt\u0103 declara\u021bie (ex. reg). Expresiile din partea dreapt\u0103 pot fi formate din orice variabile sau porturi de intrare \u0219i de ie\u0219ire \u0219i orice operatori suporta\u021bi de Verilog. "),(0,t.yg)("p",null,"Baz\xe2ndu-ne pe circuitul descris \xeen figura de mai jos, acesta se poate scrie sub form\u0103 de atribuiri continue \xeen urm\u0103toarea form\u0103:"),(0,t.yg)("table",null,(0,t.yg)("thead",{parentName:"table"},(0,t.yg)("tr",{parentName:"thead"},(0,t.yg)("th",{parentName:"tr",align:null},"Simbol"),(0,t.yg)("th",{parentName:"tr",align:null},"Cod"))),(0,t.yg)("tbody",{parentName:"table"},(0,t.yg)("tr",{parentName:"tbody"},(0,t.yg)("td",{parentName:"tr",align:null},(0,t.yg)("img",{alt:"Gates",src:i(3968).A,width:"2026",height:"936"})),(0,t.yg)("td",{parentName:"tr",align:null},(0,t.yg)("inlineCode",{parentName:"td"},"wire y1, y2; xor(out, y1, y2); and(y1, in1, in2); nand(y2, in3, in4, in5); "))))),(0,t.yg)("h3",{id:"exemplu-atribuire-continu\u0103"},"Exemplu atribuire continu\u0103"),(0,t.yg)("pre",null,(0,t.yg)("code",{parentName:"pre",className:"language-verilog"},"module my_beautiful_module (\n    output out,\n    input  i1,i2,i3,i4,i5);        \n\n          assign y1 = i1 & i2;\n          assign y2 = ~(i3 & i4 & i5);\n\n          assign out = y1 ^ y2;\n\nendmodule\n")),(0,t.yg)("p",null,"sau, mai concis:"),(0,t.yg)("pre",null,(0,t.yg)("code",{parentName:"pre",className:"language-verilog"},"module my_beautiful_module (\n    output out,\n    input  i1,i2,i3,i4,i5);        \n\n          assign out = (i1 & i2) ^  (~(i3 & i4 & i5));\n\nendmodule\n")),(0,t.yg)("p",null,"Se poate observa c\u0103 o atribuire continu\u0103 este mult mai u\u0219or de scris, de \xeen\u021beles \u0219i de modificat dec\xe2t o descriere echivalent\u0103 bazat\u0103 pe instan\u021bierea de primitive. Circuitul descris de o atribuire continu\u0103 poate fi \xeens\u0103 relativ u\u0219or sintetizat ca o serie de por\u021bi logice care implementeaz\u0103 expresia dorit\u0103, unii operatori av\xe2nd o coresponden\u021b\u0103 direct\u0103 cu o poart\u0103 logic\u0103."),(0,t.yg)("p",null,"Este o eroare s\u0103 folosi\u021bi aceea\u0219i variabil\u0103 destina\u021bie pentru mai multe atribuiri continue. Ele vor \xeencerca simultan s\u0103 modifice variabila, lucru ce nu este posibil \xeen hardware."),(0,t.yg)("h2",{id:"constante"},"Constante"),(0,t.yg)("p",null,"Pentru specificarea valorilor \xeentregi este folosit\u0103 urm\u0103toarea sintax\u0103:"),(0,t.yg)("p",null,"''","[size]['radix]"," constant_value''"),(0,t.yg)("ul",null,(0,t.yg)("li",{parentName:"ul"},"numerele con\u021bin doar caracterele bazei lor \u0219i caracterul '_' "),(0,t.yg)("li",{parentName:"ul"},"pentru a u\u0219ura citirea, se poate folosi caracterul '_' ca delimitator "),(0,t.yg)("li",{parentName:"ul"},"caracterul '?' specific\u0103 impedan\u021b\u0103 mare (z) "),(0,t.yg)("li",{parentName:"ul"},"caracterul 'x' specific\u0103 valoare necunoscut\u0103 "),(0,t.yg)("li",{parentName:"ul"},"se poate specifica dimensiunea num\u0103rului \xeen bi\u021bi, dar \u0219i baza acestuia (b,B,d,D,h,H,o,O - binar, zecimal, hexa, octal) ")),(0,t.yg)("pre",null,(0,t.yg)("code",{parentName:"pre",className:"language-verilog"},"8'b1;         //binar, pe 8 biti, echivalent cu 1 sau 8'b00000001\n8'b1010_0111; //binar, echivalent cu 167 sau 8'b10100111\n4'b10;        //binar, pe 4 biti, echivalent cu 2 sau 4'b0010 etc. \n126;          //scriere in decimal\n16'habcd;     //scriere in hexazecimal\n")),(0,t.yg)("h2",{id:"operatori"},"Operatori"),(0,t.yg)("p",null,"Descrierea comportamental\u0103 la nivelul fluxului de date, descris\u0103 anterior, presupune \xeen continuare cunoa\u0219terea schemei hardware la nivelul por\u021bilor logice sau, m\u0103car, expresia logic\u0103. De\u0219i reprezint\u0103 o variant\u0103 mai simpl\u0103 dec\xe2t utilizarea primitivelor, nu este cea mai facil\u0103. "),(0,t.yg)("p",null,"Pentru a u\u0219ura implementarea, Verilog pune la dispozi\u021bie mai multe tipuri de operatori. Unii dintre ace\u0219tia sunt cunoscu\u021bi din limbajele de programare precum C, C++, Java \u0219i au aceea\u0219i func\u021bionalitate. Al\u021bii sunt specifici limbajului Verilog \u0219i sunt folosi\u021bi \xeen special pentru a descrie u\u0219or circuite logice. Cu ajutorul acestora putem simplifica implementarea, apel\xe2nd la construc\u021bii folosind limbajul de nivel \xeenalt."),(0,t.yg)("p",null,"Tabelul de mai jos con\u021bine operatorii suporta\u021bi de Verilog, \xeempreun\u0103 cu nivelul lor de preceden\u021b\u0103."),(0,t.yg)("table",null,(0,t.yg)("thead",{parentName:"table"},(0,t.yg)("tr",{parentName:"thead"},(0,t.yg)("th",{parentName:"tr",align:null},"Simbol"),(0,t.yg)("th",{parentName:"tr",align:null},"Func\u021bie"),(0,t.yg)("th",{parentName:"tr",align:null},"Preceden\u021b\u0103"))),(0,t.yg)("tbody",{parentName:"table"},(0,t.yg)("tr",{parentName:"tbody"},(0,t.yg)("td",{parentName:"tr",align:null},(0,t.yg)("inlineCode",{parentName:"td"},"! ~ + -")," (unari)"),(0,t.yg)("td",{parentName:"tr",align:null},"Complement, Semn"),(0,t.yg)("td",{parentName:"tr",align:null},"1")),(0,t.yg)("tr",{parentName:"tbody"},(0,t.yg)("td",{parentName:"tr",align:null},(0,t.yg)("inlineCode",{parentName:"td"},"**")),(0,t.yg)("td",{parentName:"tr",align:null},"Ridicare la putere"),(0,t.yg)("td",{parentName:"tr",align:null},"2")),(0,t.yg)("tr",{parentName:"tbody"},(0,t.yg)("td",{parentName:"tr",align:null},(0,t.yg)("inlineCode",{parentName:"td"},"* / %")),(0,t.yg)("td",{parentName:"tr",align:null},"\xcenmul\u021bire, \xcemp\u0103r\u021bire, Modulo"),(0,t.yg)("td",{parentName:"tr",align:null},"3")),(0,t.yg)("tr",{parentName:"tbody"},(0,t.yg)("td",{parentName:"tr",align:null},(0,t.yg)("inlineCode",{parentName:"td"},"+ -")," (binari)"),(0,t.yg)("td",{parentName:"tr",align:null},"Adunare, Sc\u0103dere"),(0,t.yg)("td",{parentName:"tr",align:null},"4")),(0,t.yg)("tr",{parentName:"tbody"},(0,t.yg)("td",{parentName:"tr",align:null},(0,t.yg)("inlineCode",{parentName:"td"},"<< >> <<< >>>")),(0,t.yg)("td",{parentName:"tr",align:null},"Shiftare"),(0,t.yg)("td",{parentName:"tr",align:null},"5")),(0,t.yg)("tr",{parentName:"tbody"},(0,t.yg)("td",{parentName:"tr",align:null},(0,t.yg)("inlineCode",{parentName:"td"},"< <= > >= == !=")),(0,t.yg)("td",{parentName:"tr",align:null},"Rela\u021bionali"),(0,t.yg)("td",{parentName:"tr",align:null},"6")),(0,t.yg)("tr",{parentName:"tbody"},(0,t.yg)("td",{parentName:"tr",align:null},"`& ~& ^ ~^ ^~"),(0,t.yg)("td",{parentName:"tr",align:null},"~"),(0,t.yg)("td",{parentName:"tr",align:null},"`")),(0,t.yg)("tr",{parentName:"tbody"},(0,t.yg)("td",{parentName:"tr",align:null},"`&&"),(0,t.yg)("td",{parentName:"tr",align:null}),(0,t.yg)("td",{parentName:"tr",align:null},"`")),(0,t.yg)("tr",{parentName:"tbody"},(0,t.yg)("td",{parentName:"tr",align:null},(0,t.yg)("inlineCode",{parentName:"td"},"?:")),(0,t.yg)("td",{parentName:"tr",align:null},"Condi\u021bional"),(0,t.yg)("td",{parentName:"tr",align:null},"9")),(0,t.yg)("tr",{parentName:"tbody"},(0,t.yg)("td",{parentName:"tr",align:null},(0,t.yg)("inlineCode",{parentName:"td"},"{,}")),(0,t.yg)("td",{parentName:"tr",align:null},"Concatenare"),(0,t.yg)("td",{parentName:"tr",align:null})))),(0,t.yg)("p",null,"\xcen continuare sunt prezenta\u021bi operatorii mai neobi\u0219nui\u021bi suporta\u021bi de Verilog:"),(0,t.yg)("ul",null,(0,t.yg)("li",{parentName:"ul"},(0,t.yg)("p",{parentName:"li"},"Operatorii de shiftare aritmetic\u0103; realizeaz\u0103 shiftarea cu p\u0103strarea bitului de semn, pentru variabilele declarate ca fiind cu semn."),(0,t.yg)("pre",{parentName:"li"},(0,t.yg)("code",{parentName:"pre",className:"language-verilog"},"wire signed[7:0] a, x, y;\nassign x = a >>> 1;  // dac\u0103 bitul de semn al lui a este 0, bitul nou\n                     //introdus este 0 \n                     // dac\u0103 bitul de semn al lui a este 1, bitul nou\n                     // introdus este 1\nassign y = a <<< 1;  // bitul nou introdus este tot timpul 0,\n                     //asem\u0103n\u0103tor cu operatorul << \n"))),(0,t.yg)("li",{parentName:"ul"},(0,t.yg)("p",{parentName:"li"},"Operatorii de reducere; se aplic\u0103 pe un semnal de mai mul\u021bi bi\u021bi \u0219i realizeaz\u0103 opera\u021bia logic\u0103 \xeentre to\u021bi bi\u021bii semnalului"),(0,t.yg)("pre",{parentName:"li"},(0,t.yg)("code",{parentName:"pre",className:"language-verilog"},"wire[7:0] a; \nwire x, y, z;\nassign x = &a;  // realizeaza AND \xeentre to\u021bi bi\u021bii lui a \nassign y = ~&a; // realizeaz\u0103 NAND \xeentre to\u021bi bi\u021bii lui a \nassign z = ~^a; // realizeaza XNOR \xeentre to\u021bi bi\u021bii lui a, \n                // echivalent cu ^~\n"))),(0,t.yg)("li",{parentName:"ul"},(0,t.yg)("p",{parentName:"li"},"Operatorul de concatenare; realizeaz\u0103 concatenarea a dou\u0103 sau mai multe semnale, \xeentr-un semnal de l\u0103\u021bime mai mare."),(0,t.yg)("pre",{parentName:"li"},(0,t.yg)("code",{parentName:"pre",className:"language-verilog"},"wire[3:0] a, b;\nwire[9:0] x; \n\n// bi\u021bii 9:6 din x vor fi egali cu bi\u021bii 3:0 ai lui b\n// bi\u021bii 5:4 din x vor fi egali cu 01\n// bi\u021bii 3:2 din x vor fi egali cu bi\u021bii 2:1 ai lui a \n// bi\u021bii 1:0 din x vor fi egali cu 00\nassign x = {b, 2'b01, a[2:1], 2'b00};\n")))))}s.isMDXComponent=!0},3968:(e,a,i)=>{i.d(a,{A:()=>r});const r=i.p+"assets/images/gates-fb4d47200c8ef0047eff299f5db5ee1c.png"}}]);