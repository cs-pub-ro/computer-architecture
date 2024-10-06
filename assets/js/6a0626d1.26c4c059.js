"use strict";(self.webpackChunkcomputer_architecture=self.webpackChunkcomputer_architecture||[]).push([[7571],{5680:(e,A,t)=>{t.d(A,{xA:()=>o,yg:()=>m});var r=t(6540);function i(e,A,t){return A in e?Object.defineProperty(e,A,{value:t,enumerable:!0,configurable:!0,writable:!0}):e[A]=t,e}function a(e,A){var t=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);A&&(r=r.filter((function(A){return Object.getOwnPropertyDescriptor(e,A).enumerable}))),t.push.apply(t,r)}return t}function n(e){for(var A=1;A<arguments.length;A++){var t=null!=arguments[A]?arguments[A]:{};A%2?a(Object(t),!0).forEach((function(A){i(e,A,t[A])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(t)):a(Object(t)).forEach((function(A){Object.defineProperty(e,A,Object.getOwnPropertyDescriptor(t,A))}))}return e}function l(e,A){if(null==e)return{};var t,r,i=function(e,A){if(null==e)return{};var t,r,i={},a=Object.keys(e);for(r=0;r<a.length;r++)t=a[r],A.indexOf(t)>=0||(i[t]=e[t]);return i}(e,A);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);for(r=0;r<a.length;r++)t=a[r],A.indexOf(t)>=0||Object.prototype.propertyIsEnumerable.call(e,t)&&(i[t]=e[t])}return i}var u=r.createContext({}),c=function(e){var A=r.useContext(u),t=A;return e&&(t="function"==typeof e?e(A):n(n({},A),e)),t},o=function(e){var A=c(e.components);return r.createElement(u.Provider,{value:A},e.children)},s="mdxType",g={inlineCode:"code",wrapper:function(e){var A=e.children;return r.createElement(r.Fragment,{},A)}},d=r.forwardRef((function(e,A){var t=e.components,i=e.mdxType,a=e.originalType,u=e.parentName,o=l(e,["components","mdxType","originalType","parentName"]),s=c(t),d=i,m=s["".concat(u,".").concat(d)]||s[d]||g[d]||a;return t?r.createElement(m,n(n({ref:A},o),{},{components:t})):r.createElement(m,n({ref:A},o))}));function m(e,A){var t=arguments,i=A&&A.mdxType;if("string"==typeof e||i){var a=t.length,n=new Array(a);n[0]=d;var l={};for(var u in A)hasOwnProperty.call(A,u)&&(l[u]=A[u]);l.originalType=e,l[s]="string"==typeof e?e:i,n[1]=l;for(var c=2;c<a;c++)n[c]=t[c];return r.createElement.apply(null,n)}return r.createElement.apply(null,t)}d.displayName="MDXCreateElement"},720:(e,A,t)=>{t.r(A),t.d(A,{assets:()=>u,contentTitle:()=>n,default:()=>g,frontMatter:()=>a,metadata:()=>l,toc:()=>c});var r=t(8168),i=(t(6540),t(5680));const a={},n="Structura limbajului Verilog",l={unversionedId:"Laboratoare/1 Verilog Combina\u021bional/Descriere structurala/Teorie/README",id:"Laboratoare/1 Verilog Combina\u021bional/Descriere structurala/Teorie/README",title:"Structura limbajului Verilog",description:"\xcen laboratorul curent ne vom concentra asupra asimil\u0103rii limbajului Verilog, \xeencep\xe2nd cu descrierea structural\u0103 a unui circuit combina\u021bional.",source:"@site/docs/Laboratoare/1 Verilog Combina\u021bional/Descriere structurala/Teorie/README.md",sourceDirName:"Laboratoare/1 Verilog Combina\u021bional/Descriere structurala/Teorie",slug:"/Laboratoare/1 Verilog Combina\u021bional/Descriere structurala/Teorie/",permalink:"/computer-architecture/Laboratoare/1 Verilog Combina\u021bional/Descriere structurala/Teorie/",draft:!1,tags:[],version:"current",frontMatter:{},sidebar:"sidebar",previous:{title:"Descriere structurala",permalink:"/computer-architecture/Laboratoare/1 Verilog Combina\u021bional/Descriere structurala/"},next:{title:"Practic\u0103:",permalink:"/computer-architecture/Laboratoare/1 Verilog Combina\u021bional/Descriere structurala/Practic\u0103/"}},u={},c=[{value:"Module",id:"module",level:2},{value:"Exemplu declarare modul",id:"exemplu-declarare-modul",level:3},{value:"Primitive",id:"primitive",level:2},{value:"Wires",id:"wires",level:2}],o={toc:c},s="wrapper";function g(e){let{components:A,...a}=e;return(0,i.yg)(s,(0,r.A)({},o,a,{components:A,mdxType:"MDXLayout"}),(0,i.yg)("h1",{id:"structura-limbajului-verilog"},"Structura limbajului Verilog"),(0,i.yg)("p",null,"\xcen laboratorul curent ne vom concentra asupra asimil\u0103rii limbajului ",(0,i.yg)("strong",{parentName:"p"},"Verilog"),", \xeencep\xe2nd cu ",(0,i.yg)("strong",{parentName:"p"},"descrierea structural\u0103 a unui circuit combina\u021bional"),"."),(0,i.yg)("p",null,"Atunci c\xe2nd proiect\u0103m un circuit digital folosind un HDL, \xeencepem prin a face o descriere textual\u0103 a circuitului, adic\u0103 scriem cod. Acesta este compilat, iar \xeen urma procesului va rezulta un model al circuitului care poate fi apoi rulat \xeentr-un simulator cu scopul de a verifica func\u021bionalitatea descrierii. O alternativ\u0103 la simulare este folosirea unui utilitar de sintetizare, care preia codul HDL \u0219i genereaz\u0103 fi\u0219iere de configurare pentru FPGA."),(0,i.yg)("p",null,"\xcens\u0103 proiectarea circuitelor poate deveni complex\u0103. Datorit\u0103 acestui motiv, se prefer\u0103 proiectarea de tip top-down, o modalitate de parti\u021bionare sistematic\u0103 \u0219i repetat\u0103 a unui sistem complex \xeen unit\u0103\u021bi func\u021bionale mai simple, a c\u0103ror implementare poate fi f\u0103cut\u0103 mai facil. O parti\u021bionare \u0219i organizare la nivel \xeenalt a unui sistem reprezint\u0103 arhitectura acestuia. Unit\u0103\u021bile func\u021bionale individuale ce rezult\u0103 \xeen urma parti\u021bion\u0103rii sunt mai u\u0219or de proiectat \u0219i de testat dec\xe2t \xeentregul sistem. Strategia divide-et-impera a proiect\u0103rii top-down ne permite proiectarea de circuite care con\u021bin milioane de por\u021bi."),(0,i.yg)("h2",{id:"module"},"Module"),(0,i.yg)("p",null,"Modulul este unitatea de baz\u0103 a limbajului Verilog, element ce \xeencapsuleaz\u0103 inferfa\u021ba \u0219i comportamentul unui circuit. Modelul ",(0,i.yg)("em",{parentName:"p"},"black-box")," este cel mai apropiat de defini\u021bia unui modul, \xeentruc\xe2t se cunosc elementele de leg\u0103tur\u0103: intr\u0103rile \u0219i ie\u0219irile din modul precum \u0219i func\u021bionalitatea precis\u0103 a modulului, cu un accent mai redus asupra detaliilor de implementare \u0219i a modului \xeen care acesta func\u021bioneaz\u0103."),(0,i.yg)("p",null,"Pentru declararea unui modul, se folosesc cuvintele cheie ''module'' \u0219i ''endmodule''. Pe l\xe2ng\u0103 aceste cuvinte cheie, declara\u021bia unui modul mai con\u021bine: "),(0,i.yg)("ul",null,(0,i.yg)("li",{parentName:"ul"},"numele acestuia,"),(0,i.yg)("li",{parentName:"ul"},"lista de porturi (pentru interfa\u021ba cu exteriorul): pot fi de intrare (input), ie\u0219ire (output) sau intrare - ie\u0219ire (inout) \u0219i pot avea unul sau mai mul\u021bi bi\u021bi, "),(0,i.yg)("li",{parentName:"ul"},"\u0219i, desigur, implementarea func\u021bionalit\u0103\u021bii modulului.")),(0,i.yg)("p",null,"Ordinea porturilor unui modul nu este restric\u021bionat\u0103. Intr\u0103rile \u0219i ie\u0219irile pot fi declarate \xeen orice ordine, \xeens\u0103, pentru consisten\u021b\u0103, o regul\u0103 de bun\u0103 practic\u0103 este folosirea conven\u021biei (obligatorie la primitive): prima dat\u0103 se declar\u0103 ie\u0219irile, apoi intr\u0103rile."),(0,i.yg)("h3",{id:"exemplu-declarare-modul"},"Exemplu declarare modul"),(0,i.yg)("pre",null,(0,i.yg)("code",{parentName:"pre",className:"language-verilog"},"module my_beautiful_module (\n    output out,\n    input [3:0] a, \n    input b);        \n/* descrierea func\u021bionalit\u0103\u021bii */\nendmodule\n")),(0,i.yg)("p",null,"Pentru implementarea modului avem la dispozi\u021bie c\xe2teva elemente, care sunt descrise \xeen ceea ce urmeaz\u0103."),(0,i.yg)("h2",{id:"primitive"},"Primitive"),(0,i.yg)("p",null,"Element ce st\u0103 la baza descrierii structurale a circuitelor, primitiva este o func\u021bie asociat\u0103 unei por\u021bi logice de baz\u0103. Verilog are o suit\u0103 de primitive predefinite:"),(0,i.yg)("ul",null,(0,i.yg)("li",{parentName:"ul"},"primitive asociate por\u021bilor logice: and, or, nand, nor, xor, xnor;"),(0,i.yg)("li",{parentName:"ul"},"primitive asociate por\u021bilor de transmisie: not, buf, etc;"),(0,i.yg)("li",{parentName:"ul"},"primitive asociate tranzistorilor: pmos, tranif, etc.")),(0,i.yg)("p",null,"Fiecare primitiv\u0103 are porturi, prin care este conectat\u0103 \xeen exterior. Primitivele predefinite ofer\u0103 posibilitatea conect\u0103rii mai multor intr\u0103ri (ex. or, and, xor etc.) sau mai multor ie\u0219iri (ex. buf, not). Folosirea unei primitive se face prin instan\u021bierea sa cu lista de semnale care vor fi conectate la porturile ei. Pentru primitivele predefinite porturile de ie\u0219ire sunt declarate ",(0,i.yg)("strong",{parentName:"p"},"\xeenaintea")," porturilor de intrare."),(0,i.yg)("p",null,"Tabelul de mai jos ofer\u0103 c\xe2teva exemple de instan\u021biere a unor por\u021bi \xeen Verilog. Pentru primitivele predefinite numele instan\u021bei este op\u021bional."),(0,i.yg)("table",null,(0,i.yg)("thead",{parentName:"table"},(0,i.yg)("tr",{parentName:"thead"},(0,i.yg)("th",{parentName:"tr",align:null},"Simbol"),(0,i.yg)("th",{parentName:"tr",align:null},"Cod"))),(0,i.yg)("tbody",{parentName:"table"},(0,i.yg)("tr",{parentName:"tbody"},(0,i.yg)("td",{parentName:"tr",align:null},(0,i.yg)("img",{alt:"OR Gate",src:t(967).A,width:"746",height:"266"})),(0,i.yg)("td",{parentName:"tr",align:null},(0,i.yg)("inlineCode",{parentName:"td"},"or(out, a, b, c);")," ",(0,i.yg)("em",{parentName:"td"},"sau"),"  ",(0,i.yg)("inlineCode",{parentName:"td"},"or o1(out, a, b, c);"))),(0,i.yg)("tr",{parentName:"tbody"},(0,i.yg)("td",{parentName:"tr",align:null},(0,i.yg)("img",{alt:"NOT Gate",src:t(7053).A,width:"1004",height:"348"})),(0,i.yg)("td",{parentName:"tr",align:null},(0,i.yg)("inlineCode",{parentName:"td"},"not(out, in);")," ",(0,i.yg)("em",{parentName:"td"},"sau"),"  `",(0,i.yg)("inlineCode",{parentName:"td"},"not my_not(out, in);`    "))),(0,i.yg)("tr",{parentName:"tbody"},(0,i.yg)("td",{parentName:"tr",align:null},(0,i.yg)("img",{alt:"NAND Gate",src:t(5957).A,width:"691",height:"266"})),(0,i.yg)("td",{parentName:"tr",align:null},(0,i.yg)("inlineCode",{parentName:"td"},"nand (z, x, y);"),"  ",(0,i.yg)("em",{parentName:"td"},"sau"),"  ",(0,i.yg)("inlineCode",{parentName:"td"},"nand n(z, x, y);"))))),(0,i.yg)("p",null,(0,i.yg)("em",{parentName:"p"},"Table: Exemple de instan\u021biere a primitivelor")),(0,i.yg)("h2",{id:"wires"},"Wires"),(0,i.yg)("p",null,"Un singur modul sau o singur\u0103 primitiv\u0103 nu poate \xeendeplini singur\u0103 func\u021bia cerut\u0103. Astfel, apare necesitatea interconect\u0103rii modulelor sau a primitivelor. Specificarea semnalelor dintr-o diagram\u0103 se face prin ",(0,i.yg)("strong",{parentName:"p"},"wires"),", care se declar\u0103 prin cuv\xe2ntul cheie ''wire''."),(0,i.yg)("table",null,(0,i.yg)("thead",{parentName:"table"},(0,i.yg)("tr",{parentName:"thead"},(0,i.yg)("th",{parentName:"tr",align:null},"Simbol"),(0,i.yg)("th",{parentName:"tr",align:null},"Cod"))),(0,i.yg)("tbody",{parentName:"table"},(0,i.yg)("tr",{parentName:"tbody"},(0,i.yg)("td",{parentName:"tr",align:null},(0,i.yg)("img",{alt:"Gates",src:t(7122).A,width:"2026",height:"936"})),(0,i.yg)("td",{parentName:"tr",align:null},(0,i.yg)("inlineCode",{parentName:"td"},"wire y1, y2; xor(out, y1, y2); and(y1, in1, in2); nand(y2, in3, in4, in5);"))))),(0,i.yg)("p",null,(0,i.yg)("em",{parentName:"p"},"Table: Exemplu de fromare a unei porti complexe din primitive")),(0,i.yg)("p",null,"\xcen exemplul anterior y1 \u0219i y2 sunt semnale de c\xe2te 1 bit care leag\u0103 ie\u0219irile por\u021bilor and (y1) \u0219i nand (y2) la intr\u0103rile por\u021bii xor."),(0,i.yg)("p",null,"Pentru a declara semnale pe mai mul\u021bi bi\u021bi se pot folosi vectori precum \xeen declara\u021biile urm\u0103toare: m reprezint\u0103 un semnal de 8 bi\u021bi, iar n reprezint\u0103 un semnal de 5 bi\u021bi. Bitul cel mai semnificativ (eng. most significant bit - MSB) este situat \xeentotdeauna \xeen st\xe2nga, iar bitul cel mai pu\u021bin semnificativ (eng. least significant bit - LSB) \xeen dreapta."),(0,i.yg)("p",null,"\xcen mod implicit semnalele care nu sunt declarate sunt considerate ca fiind de tip wire \u0219i av\xe2nd 1 bit (ex. in1, in2, \u2026 din codul de mai sus). Putem accesa individual bi\u021bii dintr-un wire sau putem accesa un grup consecutiv de bi\u021bi specific\xe2nd intervalul (ex. m","[0]",", m","[3:1]",", m","[7:2]",")."),(0,i.yg)("pre",null,(0,i.yg)("code",{parentName:"pre",className:"language-verilog"},"wire[7:0] m; _ 8 biti, MSB este bitul 7, LSB bitul 0 \nwire[0:4] n;  _ 5 biti, MSB este bitul 0, LSB bitul 4\nwire[7:0] a [9:0]; _ array multidimensional cu 10 elemente de 8 biti\n")))}g.isMDXComponent=!0},7122:(e,A,t)=>{t.d(A,{A:()=>r});const r=t.p+"assets/images/gates-fb4d47200c8ef0047eff299f5db5ee1c.png"},5957:(e,A,t)=>{t.d(A,{A:()=>r});const r="data:image/png;base64,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"},7053:(e,A,t)=>{t.d(A,{A:()=>r});const r="data:image/png;base64,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"},967:(e,A,t)=>{t.d(A,{A:()=>r});const r=t.p+"assets/images/or-gate-dc0109fa49442849e2b3e08abf78e5e3.png"}}]);