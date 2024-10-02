"use strict";(self.webpackChunkcomputer_architecture=self.webpackChunkcomputer_architecture||[]).push([[635],{5680:(e,t,a)=>{a.d(t,{xA:()=>s,yg:()=>m});var r=a(6540);function i(e,t,a){return t in e?Object.defineProperty(e,t,{value:a,enumerable:!0,configurable:!0,writable:!0}):e[t]=a,e}function n(e,t){var a=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),a.push.apply(a,r)}return a}function c(e){for(var t=1;t<arguments.length;t++){var a=null!=arguments[t]?arguments[t]:{};t%2?n(Object(a),!0).forEach((function(t){i(e,t,a[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(a)):n(Object(a)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(a,t))}))}return e}function o(e,t){if(null==e)return{};var a,r,i=function(e,t){if(null==e)return{};var a,r,i={},n=Object.keys(e);for(r=0;r<n.length;r++)a=n[r],t.indexOf(a)>=0||(i[a]=e[a]);return i}(e,t);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);for(r=0;r<n.length;r++)a=n[r],t.indexOf(a)>=0||Object.prototype.propertyIsEnumerable.call(e,a)&&(i[a]=e[a])}return i}var l=r.createContext({}),p=function(e){var t=r.useContext(l),a=t;return e&&(a="function"==typeof e?e(t):c(c({},t),e)),a},s=function(e){var t=p(e.components);return r.createElement(l.Provider,{value:t},e.children)},u="mdxType",g={inlineCode:"code",wrapper:function(e){var t=e.children;return r.createElement(r.Fragment,{},t)}},d=r.forwardRef((function(e,t){var a=e.components,i=e.mdxType,n=e.originalType,l=e.parentName,s=o(e,["components","mdxType","originalType","parentName"]),u=p(a),d=i,m=u["".concat(l,".").concat(d)]||u[d]||g[d]||n;return a?r.createElement(m,c(c({ref:t},s),{},{components:a})):r.createElement(m,c({ref:t},s))}));function m(e,t){var a=arguments,i=t&&t.mdxType;if("string"==typeof e||i){var n=a.length,c=new Array(n);c[0]=d;var o={};for(var l in t)hasOwnProperty.call(t,l)&&(o[l]=t[l]);o.originalType=e,o[u]="string"==typeof e?e:i,c[1]=o;for(var p=2;p<n;p++)c[p]=a[p];return r.createElement.apply(null,c)}return r.createElement.apply(null,a)}d.displayName="MDXCreateElement"},4490:(e,t,a)=>{a.r(t),a.d(t,{assets:()=>l,contentTitle:()=>c,default:()=>g,frontMatter:()=>n,metadata:()=>o,toc:()=>p});var r=a(8168),i=(a(6540),a(5680));const n={},c="Tutorial creare proiect Vivado",o={unversionedId:"Tutoriale/Creare proiect Vivado/README",id:"Tutoriale/Creare proiect Vivado/README",title:"Tutorial creare proiect Vivado",description:"Pentru a crea un proiect \xeen Vivado cu ajutorul c\u0103ruia pute\u021bi sintetiza cod pe FPGA urma\u021bi pa\u0219ii de mai jos:",source:"@site/docs/Tutoriale/Creare proiect Vivado/README.md",sourceDirName:"Tutoriale/Creare proiect Vivado",slug:"/Tutoriale/Creare proiect Vivado/",permalink:"/computer-architecture/Tutoriale/Creare proiect Vivado/",draft:!1,tags:[],version:"current",frontMatter:{},sidebar:"sidebar",previous:{title:"Instalare Vivado",permalink:"/computer-architecture/Tutoriale/Instalare Vivado/"},next:{title:"Simulare modul \xeen Vivado",permalink:"/computer-architecture/Tutoriale/Simulare Vivado/"}},l={},p=[],s={toc:p},u="wrapper";function g(e){let{components:t,...n}=e;return(0,i.yg)(u,(0,r.A)({},s,n,{components:t,mdxType:"MDXLayout"}),(0,i.yg)("h1",{id:"tutorial-creare-proiect-vivado"},"Tutorial creare proiect Vivado"),(0,i.yg)("p",null,"Pentru a crea un proiect \xeen Vivado cu ajutorul c\u0103ruia pute\u021bi sintetiza cod pe FPGA urma\u021bi pa\u0219ii de mai jos:"),(0,i.yg)("ol",null,(0,i.yg)("li",{parentName:"ol"},"Deschide\u021bi programul Vivado \u0219i selecta\u021bi Create Project\n",(0,i.yg)("img",{alt:"Create Project",src:a(2325).A,width:"1925",height:"1037"})),(0,i.yg)("li",{parentName:"ol"},"Apasa\u021bi Next\n",(0,i.yg)("img",{alt:"Next1",src:a(526).A,width:"992",height:"700"})),(0,i.yg)("li",{parentName:"ol"},"Scrie\u021bi numele proiectului \u0219i selecta\u021bi loca\u021bia acestuia.\n",(0,i.yg)("img",{alt:"exemplu1",src:a(3543).A,width:"989",height:"697"})),(0,i.yg)("li",{parentName:"ol"},"Selecta\u021bi ",(0,i.yg)("a",{parentName:"li",href:"https://en.wikipedia.org/wiki/Register-transfer_level"},"RTL"),' Project, deselecta\u021bi "Do not specify sources at this time" \u0219i ap\u0103sa\u021bi Next\n',(0,i.yg)("img",{alt:"Next2",src:a(8376).A,width:"989",height:"698"})),(0,i.yg)("li",{parentName:"ol"},'Ap\u0103sa\u021bi "Create File" \u0219i alege\u021bi un nume pentru fisierul surs\u0103. Asigura\u021bi-v\u0103 c\u0103 Target Language este "Verilog" \u0219i ap\u0103sa\u021bi Next.\n',(0,i.yg)("img",{alt:"exemplu2",src:a(6641).A,width:"985",height:"696"})),(0,i.yg)("li",{parentName:"ol"},"[Op\u021bional - doar pentru programarea unui FPGA - pute\u021bi ap\u0103sa pe Next pentru a s\u0103ri peste acest pas]"," Ad\u0103uga\u021bi un constraint file (",(0,i.yg)("a",{parentName:"li",href:"https://digilent.com/reference/programmable-logic/guides/vivado-xdc-file"},"Ce reprezint\u0103 un astfel de fi\u0219ier?"),") pentru placa FPGA pe care o folosi\u021bi (De exemplu ",(0,i.yg)("a",{parentName:"li",href:"https://github.com/Digilent/digilent-xdc/blob/77d88001d51ba54b33ed0b4b34bcc19c979be5ff/Nexys-A7-100T-Master.xdc"},"Nexys-A7-100T-Master.xdc"),' - descarca\u021bi acest fisier!) (Add Files -> Cautati si selectati fisierul "Nexys-A7-100T-Master.xdc" -> Next)\n',(0,i.yg)("img",{alt:"exemplu3",src:a(7658).A,width:"1359",height:"635"})),(0,i.yg)("li",{parentName:"ol"},"Selecta\u021bi caracteristicile pl\u0103cii FPGA: Category, Familiy, Package, Speed (Le ve\u021bi g\u0103si pe cutia pl\u0103cu\u021bei sau \xeen ",(0,i.yg)("a",{parentName:"li",href:"https://digilent.com/reference/_media/reference/programmable-logic/nexys-a7/nexys-a7_rm.pdf"},"reference manual"),") - Exemplu pentru\n",(0,i.yg)("img",{alt:"pl\u0103cu\u021ba folosit\u0103 \xeen laborator",src:a(2867).A,width:"990",height:"696"})),(0,i.yg)("li",{parentName:"ol"},"Revizui\u021bi informa\u021biile proiectului\n",(0,i.yg)("img",{alt:"exemplu",src:a(596).A,width:"989",height:"696"})),(0,i.yg)("li",{parentName:"ol"},"La acest pas pute\u021bi defini numele modulului \u0219i porturile acestuia:\n",(0,i.yg)("img",{alt:"exemplu",src:a(8077).A,width:"607",height:"439"})),(0,i.yg)("li",{parentName:"ol"},"\xcen final, \xeen Vivado ve\u021bi putea vizualiza proiectul astfel\n",(0,i.yg)("img",{alt:"astfel",src:a(9697).A,width:"1918",height:"1039"}),".")),(0,i.yg)("p",null,"\xcen st\xe2nga ecranului putem vedea pa\u0219ii de simulare, sintetizare, implementare \u0219i generare a bitstream-ului ce va fi folosit pentru configurarea interna a FPGA-ului."),(0,i.yg)("p",null,(0,i.yg)("img",{alt:"Proiect Vivado",src:a(9697).A,width:"1918",height:"1039"})),(0,i.yg)("p",null,"Dac\u0103 ave\u021bi sugestii de \xeembun\u0103t\u0103\u021bire a acestei pagini v\u0103 rog s\u0103 trimite\u021bi sugestiile pe mail la ",(0,i.yg)("a",{parentName:"p",href:"mailto:dosarudaniel@gmail.com"},"dosarudaniel@gmail.com"),"."))}g.isMDXComponent=!0},2325:(e,t,a)=>{a.d(t,{A:()=>r});const r=a.p+"assets/images/create_project_1-f365c610a9b3ab0528dec71ac9bfb9e5.png"},9697:(e,t,a)=>{a.d(t,{A:()=>r});const r=a.p+"assets/images/create_project_10-04176f5f07567088fd13305c1139d043.png"},526:(e,t,a)=>{a.d(t,{A:()=>r});const r=a.p+"assets/images/create_project_2-788026f9eec4c5040c67f29fec3808fc.png"},3543:(e,t,a)=>{a.d(t,{A:()=>r});const r=a.p+"assets/images/create_project_3-be56b592eb78121fecc75f86358b2f85.png"},8376:(e,t,a)=>{a.d(t,{A:()=>r});const r=a.p+"assets/images/create_project_4-4ecb90c763aae9421a01374d1539d450.png"},6641:(e,t,a)=>{a.d(t,{A:()=>r});const r=a.p+"assets/images/create_project_5-4d8146767fead97a47124c1bbe2819b3.png"},7658:(e,t,a)=>{a.d(t,{A:()=>r});const r=a.p+"assets/images/create_project_6-08b0d7706e83df937d0d3c01246a595a.png"},2867:(e,t,a)=>{a.d(t,{A:()=>r});const r=a.p+"assets/images/create_project_7-b31cb6868ec24d3ebfcfe067701a00d4.png"},596:(e,t,a)=>{a.d(t,{A:()=>r});const r=a.p+"assets/images/create_project_8-3be64ae6aa88e2ef7cfa4520aa1a8f02.png"},8077:(e,t,a)=>{a.d(t,{A:()=>r});const r=a.p+"assets/images/create_project_9-34c143efbebee67b3b1a20507507da5a.png"}}]);