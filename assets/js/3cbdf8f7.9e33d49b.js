"use strict";(self.webpackChunkcomputer_architecture=self.webpackChunkcomputer_architecture||[]).push([[2840],{5680:(e,t,a)=>{a.d(t,{xA:()=>s,yg:()=>p});var r=a(6540);function i(e,t,a){return t in e?Object.defineProperty(e,t,{value:a,enumerable:!0,configurable:!0,writable:!0}):e[t]=a,e}function o(e,t){var a=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),a.push.apply(a,r)}return a}function n(e){for(var t=1;t<arguments.length;t++){var a=null!=arguments[t]?arguments[t]:{};t%2?o(Object(a),!0).forEach((function(t){i(e,t,a[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(a)):o(Object(a)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(a,t))}))}return e}function c(e,t){if(null==e)return{};var a,r,i=function(e,t){if(null==e)return{};var a,r,i={},o=Object.keys(e);for(r=0;r<o.length;r++)a=o[r],t.indexOf(a)>=0||(i[a]=e[a]);return i}(e,t);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);for(r=0;r<o.length;r++)a=o[r],t.indexOf(a)>=0||Object.prototype.propertyIsEnumerable.call(e,a)&&(i[a]=e[a])}return i}var u=r.createContext({}),l=function(e){var t=r.useContext(u),a=t;return e&&(a="function"==typeof e?e(t):n(n({},t),e)),a},s=function(e){var t=l(e.components);return r.createElement(u.Provider,{value:t},e.children)},m="mdxType",A={inlineCode:"code",wrapper:function(e){var t=e.children;return r.createElement(r.Fragment,{},t)}},g=r.forwardRef((function(e,t){var a=e.components,i=e.mdxType,o=e.originalType,u=e.parentName,s=c(e,["components","mdxType","originalType","parentName"]),m=l(a),g=i,p=m["".concat(u,".").concat(g)]||m[g]||A[g]||o;return a?r.createElement(p,n(n({ref:t},s),{},{components:a})):r.createElement(p,n({ref:t},s))}));function p(e,t){var a=arguments,i=t&&t.mdxType;if("string"==typeof e||i){var o=a.length,n=new Array(o);n[0]=g;var c={};for(var u in t)hasOwnProperty.call(t,u)&&(c[u]=t[u]);c.originalType=e,c[m]="string"==typeof e?e:i,n[1]=c;for(var l=2;l<o;l++)n[l]=a[l];return r.createElement.apply(null,n)}return r.createElement.apply(null,a)}g.displayName="MDXCreateElement"},8326:(e,t,a)=>{a.r(t),a.d(t,{assets:()=>u,contentTitle:()=>n,default:()=>A,frontMatter:()=>o,metadata:()=>c,toc:()=>l});var r=a(8168),i=(a(6540),a(5680));const o={},n="Memorie",c={unversionedId:"Laboratoare/5 Verilog Secven\u021bial/Memorie/Teorie/README",id:"Laboratoare/5 Verilog Secven\u021bial/Memorie/Teorie/README",title:"Memorie",description:"Registrul",source:"@site/docs/Laboratoare/5 Verilog Secven\u021bial/Memorie/Teorie/README.md",sourceDirName:"Laboratoare/5 Verilog Secven\u021bial/Memorie/Teorie",slug:"/Laboratoare/5 Verilog Secven\u021bial/Memorie/Teorie/",permalink:"/computer-architecture/Laboratoare/5 Verilog Secven\u021bial/Memorie/Teorie/",draft:!1,tags:[],version:"current",frontMatter:{},sidebar:"sidebar",previous:{title:"Memorie",permalink:"/computer-architecture/Laboratoare/5 Verilog Secven\u021bial/Memorie/"},next:{title:"Practice: Memory",permalink:"/computer-architecture/Laboratoare/5 Verilog Secven\u021bial/Memorie/Practic\u0103/"}},u={},l=[{value:"Registrul",id:"registrul",level:2},{value:"Memorie cu acces aleatoriu (RAM)",id:"memorie-cu-acces-aleatoriu-ram",level:2}],s={toc:l},m="wrapper";function A(e){let{components:t,...o}=e;return(0,i.yg)(m,(0,r.A)({},s,o,{components:t,mdxType:"MDXLayout"}),(0,i.yg)("h1",{id:"memorie"},"Memorie"),(0,i.yg)("h2",{id:"registrul"},"Registrul"),(0,i.yg)("p",null,"Bistabilul este o celul\u0103 de memorie av\xe2nd capacitate de un bit, care poate fi utilizat\u0103 pentru a stoca date digitale. Pentru a extinde capacitatea de stocare \xeen ceea ce prive\u0219te num\u0103rul de bi\u021bi, se va utiliza un grup de bistabili, cunoscut \u0219i sub termenul de ",(0,i.yg)("strong",{parentName:"p"},"registru"),". Registrul de ",(0,i.yg)("strong",{parentName:"p"},"n")," bi\u021bi este alc\u0103tuit din ",(0,i.yg)("strong",{parentName:"p"},"n")," bistabili \u0219i are capacitate de stocare de ",(0,i.yg)("strong",{parentName:"p"},"n")," bi\u021bi."),(0,i.yg)("p",null,"Un registru, ca orice alt circuit secven\u021bial este sensibil la schimbarea de front a semnalelor ",(0,i.yg)("em",{parentName:"p"},"clk")," \u0219i ",(0,i.yg)("em",{parentName:"p"},"reset"),". De asemenea, pentru a putea fi conectat la o magistral\u0103, acesta are nevoie s\u0103 execute dou\u0103 opera\u021bii simple:"),(0,i.yg)("ul",null,(0,i.yg)("li",{parentName:"ul"},"citire - informa\u021bia deja existent\u0103 \xeen registru este preluat\u0103 \u0219i eliberat\u0103 pe ie\u0219irea registrului"),(0,i.yg)("li",{parentName:"ul"},"scriere - informa\u021bia aflat\u0103 pe magistral\u0103 la un moment de timp se scrie \xeen registru")),(0,i.yg)("p",null,"Pentru o vizualizare mai clar\u0103 a specifica\u021biilor unui astfel de circuit digital secven\u021bial, studia\u021bi interfa\u021ba acestuia:"),(0,i.yg)("p",null,(0,i.yg)("img",{alt:"Registrul",src:a(6193).A,width:"434",height:"242"})),(0,i.yg)("p",null,(0,i.yg)("em",{parentName:"p"},"Figure: Registrul")),(0,i.yg)("h2",{id:"memorie-cu-acces-aleatoriu-ram"},"Memorie cu acces aleatoriu (RAM)"),(0,i.yg)("p",null,"Memoria poate fi asociat\u0103 cu creierul uman, fiind folosit\u0103 pentru a stoca date \u0219i instruc\u021biuni. Memoria unui calculator este spa\u021biul de stocare din calculator unde sunt p\u0103strate datele care urmeaz\u0103 s\u0103 fie procesate \u0219i instruc\u021biunile necesare pentru procesare. Aceasta se \xeemparte \xeen mai multe elemente cu caracteristici similare, numite celule. Fiecare celul\u0103 are o adres\u0103 unic\u0103 numerotat\u0103 de la 0 la N-1, unde N este dimensiunea blocului de memorie (num\u0103rul de celule din memorie)."),(0,i.yg)("p",null,"Componenta hardware de tip memorie a unui calculator unde sunt stocate sistemul de operare, programele de baz\u0103 \u0219i datele utilizate la momentul curent, pentru a fi accesate cu u\u0219urin\u021b\u0103 de procesor se nume\u0219te ",(0,i.yg)("strong",{parentName:"p"},"RAM")," (Random Access Memory). RAM-ul este o memorie volatil\u0103, \xeensemn\xe2nd c\u0103 toate informa\u021biile stocate \xeen acesta vor fi pierdute la deconectarea calculatorului de la sursa electric\u0103, urm\xe2nd s\u0103 fie recuperate la repornirea sistemului de pe HDD/SSD. RAM-ul este mic, at\xe2t ca dimensiune fizic\u0103, c\xe2t \u0219i din punct de vedere al capacit\u0103\u021bii de stocare de date."),(0,i.yg)("p",null,"\xcen compara\u021bie cu registrele, memoria de tip RAM este mai greu de accesat de c\u0103tre procesor. Fiind un circuit secven\u021bial complex sunt necesari mai mul\u021bi cicli de ceas pentru a citi/scrie informa\u021bia necesar\u0103. Totodat\u0103, ofer\u0103 o capacitate mult mai mare de stocare, de care registrele nu dispun. Prin urmare, pentru implementarea eficient\u0103 a unui circuit digital, este foarte important\u0103 gestionarea resurselor \xeentre memorie \u0219i registre, astfel \xeenc\xe2t s\u0103 se permit\u0103 stocarea \u0219i accesul la toate informa\u021biile necesare \xeentr-un timp c\xe2t mai scurt."))}A.isMDXComponent=!0},6193:(e,t,a)=>{a.d(t,{A:()=>r});const r="data:image/png;base64,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"}}]);