"use strict";(self.webpackChunkcomputer_architecture=self.webpackChunkcomputer_architecture||[]).push([[5248],{5680:(e,a,r)=>{r.d(a,{xA:()=>c,yg:()=>m});var i=r(6540);function n(e,a,r){return a in e?Object.defineProperty(e,a,{value:r,enumerable:!0,configurable:!0,writable:!0}):e[a]=r,e}function t(e,a){var r=Object.keys(e);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);a&&(i=i.filter((function(a){return Object.getOwnPropertyDescriptor(e,a).enumerable}))),r.push.apply(r,i)}return r}function l(e){for(var a=1;a<arguments.length;a++){var r=null!=arguments[a]?arguments[a]:{};a%2?t(Object(r),!0).forEach((function(a){n(e,a,r[a])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(r)):t(Object(r)).forEach((function(a){Object.defineProperty(e,a,Object.getOwnPropertyDescriptor(r,a))}))}return e}function o(e,a){if(null==e)return{};var r,i,n=function(e,a){if(null==e)return{};var r,i,n={},t=Object.keys(e);for(i=0;i<t.length;i++)r=t[i],a.indexOf(r)>=0||(n[r]=e[r]);return n}(e,a);if(Object.getOwnPropertySymbols){var t=Object.getOwnPropertySymbols(e);for(i=0;i<t.length;i++)r=t[i],a.indexOf(r)>=0||Object.prototype.propertyIsEnumerable.call(e,r)&&(n[r]=e[r])}return n}var s=i.createContext({}),u=function(e){var a=i.useContext(s),r=a;return e&&(r="function"==typeof e?e(a):l(l({},a),e)),r},c=function(e){var a=u(e.components);return i.createElement(s.Provider,{value:a},e.children)},p="mdxType",d={inlineCode:"code",wrapper:function(e){var a=e.children;return i.createElement(i.Fragment,{},a)}},g=i.forwardRef((function(e,a){var r=e.components,n=e.mdxType,t=e.originalType,s=e.parentName,c=o(e,["components","mdxType","originalType","parentName"]),p=u(r),g=n,m=p["".concat(s,".").concat(g)]||p[g]||d[g]||t;return r?i.createElement(m,l(l({ref:a},c),{},{components:r})):i.createElement(m,l({ref:a},c))}));function m(e,a){var r=arguments,n=a&&a.mdxType;if("string"==typeof e||n){var t=r.length,l=new Array(t);l[0]=g;var o={};for(var s in a)hasOwnProperty.call(a,s)&&(o[s]=a[s]);o.originalType=e,o[p]="string"==typeof e?e:n,l[1]=o;for(var u=2;u<t;u++)l[u]=r[u];return i.createElement.apply(null,l)}return i.createElement.apply(null,r)}g.displayName="MDXCreateElement"},1448:(e,a,r)=>{r.r(a),r.d(a,{assets:()=>s,contentTitle:()=>l,default:()=>d,frontMatter:()=>t,metadata:()=>o,toc:()=>u});var i=r(8168),n=(r(6540),r(5680));const t={},l="Blocul always@ edge-triggered",o={unversionedId:"Laboratoare/4 Verilog Secven\u021bial/Always-Edge/Teorie/README",id:"Laboratoare/4 Verilog Secven\u021bial/Always-Edge/Teorie/README",title:"Blocul always@ edge-triggered",description:"\xcen afar\u0103 de circuitele care depind doar schimbarea nivelului semnalului, exist\u0103 \u0219i circuite al c\u0103ror comportament depinde de tranzi\u021biile semnalului (activ pe front cresc\u0103tor sau front descresc\u0103tor). Starea bistabililor, de exemplu, se modific\u0103 pe frontul cresc\u0103tor sau descresc\u0103tor al unui semnal de ceas. \xcen cazul acesta, blocul ''always@'' trebuie s\u0103 se execute la detec\u021bia unui astfel de front (eng. edge-triggered). Pentru a modela un astfel de comportament Verilog ofer\u0103 cuv\xe2ntul cheie posedge ce poate fi al\u0103turat numelui semnalului unui semnal din lista de senzitivit\u0103\u021bi pentru a indica activarea blocului ''always'' la un front al semnalului. De exemplu blocul \"always @(posedge clk)\" se activeaz\u0103 pe frontul cresc\u0103tor al semnalului clk.",source:"@site/docs/Laboratoare/4 Verilog Secven\u021bial/Always-Edge/Teorie/README.md",sourceDirName:"Laboratoare/4 Verilog Secven\u021bial/Always-Edge/Teorie",slug:"/Laboratoare/4 Verilog Secven\u021bial/Always-Edge/Teorie/",permalink:"/computer-architecture/Laboratoare/4 Verilog Secven\u021bial/Always-Edge/Teorie/",draft:!1,tags:[],version:"current",frontMatter:{},sidebar:"sidebar",previous:{title:"Always-Edge",permalink:"/computer-architecture/Laboratoare/4 Verilog Secven\u021bial/Always-Edge/"},next:{title:"Debouncer",permalink:"/computer-architecture/Laboratoare/4 Verilog Secven\u021bial/Debouncer/"}},s={},u=[{value:"Sensitivity list",id:"sensitivity-list",level:2},{value:"Exemplu sensitivity list",id:"exemplu-sensitivity-list",level:3},{value:"Atribuiri non-blocante",id:"atribuiri-non-blocante",level:2},{value:"Exemplu atribuiri non-blocante ==",id:"exemplu-atribuiri-non-blocante-",level:3},{value:"Bistabilul D",id:"bistabilul-d",level:2},{value:"Bistabilul D - reset verificat sincron",id:"bistabilul-d---reset-verificat-sincron",level:3},{value:"Informa\u021bii adi\u021bionale despre always asincron",id:"informa\u021bii-adi\u021bionale-despre-always-asincron",level:3},{value:"Bistabilul D - reset verificat asincron",id:"bistabilul-d---reset-verificat-asincron",level:3},{value:"Bistabilul D - reset verificat sincron (modul nesintetizabil)",id:"bistabilul-d---reset-verificat-sincron-modul-nesintetizabil",level:3}],c={toc:u},p="wrapper";function d(e){let{components:a,...r}=e;return(0,n.yg)(p,(0,i.A)({},c,r,{components:a,mdxType:"MDXLayout"}),(0,n.yg)("h1",{id:"blocul-always-edge-triggered"},"Blocul always@ edge-triggered"),(0,n.yg)("p",null,"\xcen afar\u0103 de circuitele care depind doar schimbarea nivelului semnalului, exist\u0103 \u0219i circuite al c\u0103ror comportament depinde de tranzi\u021biile semnalului (activ pe ",(0,n.yg)("em",{parentName:"p"},"front cresc\u0103tor")," sau ",(0,n.yg)("em",{parentName:"p"},"front descresc\u0103tor"),"). Starea bistabililor, de exemplu, se modific\u0103 pe frontul cresc\u0103tor sau descresc\u0103tor al unui semnal de ceas. \xcen cazul acesta, blocul ''always@'' trebuie s\u0103 se execute la detec\u021bia unui astfel de front (eng. ",(0,n.yg)("em",{parentName:"p"},"edge-triggered"),"). Pentru a modela un astfel de comportament Verilog ofer\u0103 cuv\xe2ntul cheie ",(0,n.yg)("strong",{parentName:"p"},"posedge")," ce poate fi al\u0103turat numelui semnalului unui semnal din lista de senzitivit\u0103\u021bi pentru a indica activarea blocului ''always'' la un front al semnalului. De exemplu blocul \"always @(posedge clk)\" se activeaz\u0103 pe frontul cresc\u0103tor al semnalului ",(0,n.yg)("em",{parentName:"p"},"clk"),"."),(0,n.yg)("h2",{id:"sensitivity-list"},"Sensitivity list"),(0,n.yg)("p",null,"Cuvintele cheie ",(0,n.yg)("strong",{parentName:"p"},"posedge")," (pentru front cresc\u0103tor) \u0219i ",(0,n.yg)("strong",{parentName:"p"},"negedge")," (pentru front descresc\u0103tor) indic\u0103 activarea blocului ",(0,n.yg)("em",{parentName:"p"},"always@ edge-triggered")," la schimbarea frontului semnalului."),(0,n.yg)("h3",{id:"exemplu-sensitivity-list"},"Exemplu sensitivity list"),(0,n.yg)("pre",null,(0,n.yg)("code",{parentName:"pre",className:"language-verilog"},"always @(posedge sig)   // frontul cresc\u0103tor al semnalului 'sig'\nalways @(negedge sig)   // frontul descresc\u0103tor al semnalului 'sig'\nalways @(posedge sig1, posedge sig2)    // frontul crescator al \n// semnalului 'sig1' sau frontul cresc\u0103tor al semnalului 'sig2'\nalways @(posedge sig1, negedge sig2)    // frontul cresc\u0103tor al\n// semnalului 'sig1' sau frontul descresc\u0103tor al semnalului 'sig2'\n")),(0,n.yg)("h2",{id:"atribuiri-non-blocante"},"Atribuiri non-blocante"),(0,n.yg)("p",null,"\xcen blocurile ''always@'' din laboratoarele precedente au fost folosite atribuirile ce utilizeaz\u0103 operatorul \"=\", numite ",(0,n.yg)("em",{parentName:"p"},"atribuiri blocante"),', deoarece se execut\u0103 secven\u021bial, ca \xeen limbajele de programare procedurale (C, Java etc). Verilog ofer\u0103 \u0219i un alt tip de atribuiri, care sunt executate toate \xeen acela\u0219i timp, \xeen paralel, indiferent de ordinea lor \xeen bloc. Pentru a descrie un astfel de comportament se folose\u0219te operatorul "<=", iar atribuirile se numesc ',(0,n.yg)("em",{parentName:"p"},"atribuiri non-blocante"),". Acest nou tip de atribuire ",(0,n.yg)("strong",{parentName:"p"},"modeleaz\u0103 concuren\u021ba care poate fi \xeent\xe2lnit\u0103 \xeen hardware la transferarea datelor \xeentre registre"),". "),(0,n.yg)("p",null,"Variabilele c\u0103rora li se atribuie o valoare trebuie s\u0103 fie de tip registru (",(0,n.yg)("em",{parentName:"p"},"reg, integer"),") at\xe2t \xeen cazul blocant c\xe2t \u0219i \xeen cel non-blocant. Simulatorul evalueaz\u0103 \xeent\xe2i partea dreapt\u0103 a atribuirilor \u0219i apoi atribuie valorile c\u0103tre partea st\xe2ng\u0103. Acest lucru face ca ordinea atribuirilor non-blocante s\u0103 nu conteze, deoarece rezultatul lor va depinde de ce valori aveau variabilele din partea dreapt\u0103 \xeenainte de execu\u021bie."),(0,n.yg)("h3",{id:"exemplu-atribuiri-non-blocante-"},"Exemplu atribuiri non-blocante =="),(0,n.yg)("pre",null,(0,n.yg)("code",{parentName:"pre",className:"language-verilog"},"always @(posedge sig) // executat pe frontul cresc\u0103tor al semnalului sig\nbegin  \n    a <= b;\n    b <= a;     // se interschimba valoarea lui a cu cea a lui b\n    c <= d;     // toate trei atribuirile au loc \xeen acela\u0219i timp\nend\n")),(0,n.yg)("p",null,"\xcen cadrul blocurilor always care modeleaz\u0103 logic\u0103 ",(0,n.yg)("strong",{parentName:"p"},"combina\u021bional\u0103")," se folosesc ",(0,n.yg)("strong",{parentName:"p"},"atribuiri blocante"),' ("="), iar \xeen blocurile care modeleaz\u0103 logic\u0103 ',(0,n.yg)("strong",{parentName:"p"},"secven\u021bial\u0103")," se folosesc ",(0,n.yg)("strong",{parentName:"p"},"atribuiri non-blocante"),' ("<=")'),(0,n.yg)("h2",{id:"bistabilul-d"},"Bistabilul D"),(0,n.yg)("p",null,'Exemplele urm\u0103toare reprezint\u0103 implementarea unui bistabil D, prezentat \xeen laboratorul 0, care men\u021bine valoarea de intrare ("D") \xeentre dou\u0103 fronturi cresc\u0103toare ale semnalului de ceas ("clk"). Circuitului prezentat \xeen laboratorul 0 i s-a ad\u0103ugat \u0219i un semnal de reset ("rst_n"). Numele semnalului de reset se termin\u0103 cu "_n", \xeen mod conven\u021bional, pentru a sugera c\u0103 acesta este activ pe negedge.'),(0,n.yg)("p",null,"\xcen exemplul de mai jos, semnalul de reset este verificat ",(0,n.yg)("strong",{parentName:"p"},"sincron"),", atribuirile f\u0103cute ie\u0219irii Q fiind ",(0,n.yg)("strong",{parentName:"p"},"non-blocante"),'. Observa\u021bi c\u0103 opera\u021bia de reset este condi\u021bionat\u0103 de valoarea "0" a semnalului "rst_n".'),(0,n.yg)("h3",{id:"bistabilul-d---reset-verificat-sincron"},"Bistabilul D - reset verificat sincron"),(0,n.yg)("pre",null,(0,n.yg)("code",{parentName:"pre",className:"language-verilog"},"module D_flip_flop(output reg Q, input D, clk, rst_n);\n \nalways @(posedge clk) begin\n    if(!rst_n)\n      Q <= 0;\n    else\n      Q <= D;\nend\n \nendmodule\n")),(0,n.yg)("p",null,"Verificarea resetului se poate realiza \u0219i \xeen mod asincron."),(0,n.yg)("h3",{id:"informa\u021bii-adi\u021bionale-despre-always-asincron"},"Informa\u021bii adi\u021bionale despre always asincron"),(0,n.yg)("p",null,"\xcen cel de-al doilea exemplu, semnalul este verificat ",(0,n.yg)("strong",{parentName:"p"},"asincron"),". Modulul este sintetizabil \u0219i are un comportament asem\u0103n\u0103tor cu modulul asincron din al treilea exemplu. Pentru a fi sintetizabil este necesar ca toate atribuirile asupra registrului Q s\u0103 fie realizate \xeen acela\u0219i bloc ",(0,n.yg)("em",{parentName:"p"},"always"),", iar blocul ",(0,n.yg)("em",{parentName:"p"},"always")," s\u0103 fie activat pe ",(0,n.yg)("em",{parentName:"p"},"frontul cresc\u0103tor")," al semnalului ",(0,n.yg)("em",{parentName:"p"},"clk")," sau pe ",(0,n.yg)("em",{parentName:"p"},"frontul cresc\u0103tor")," al semnalului ",(0,n.yg)("em",{parentName:"p"},"!rst_n"),"."),(0,n.yg)("h3",{id:"bistabilul-d---reset-verificat-asincron"},"Bistabilul D - reset verificat asincron"),(0,n.yg)("pre",null,(0,n.yg)("code",{parentName:"pre",className:"language-verilog"},"module D_flip_flop(output reg Q, input D, clk, rst_n);\n \nalways @(posedge clk or negedge rst_n) begin\n    if(!rst_n)\n      Q <= 0;\n    else\n      Q <= D;\nend\n \nendmodule\n")),(0,n.yg)("p",null,"Un ",(0,n.yg)("strong",{parentName:"p"},"modul")," este ",(0,n.yg)("strong",{parentName:"p"},"nesintetizabil")," dac\u0103 acesta con\u021bine atribuiri asupra aceluia\u0219i registru \xeen mai mult de un bloc ",(0,n.yg)("strong",{parentName:"p"},"always"),"."),(0,n.yg)("p",null,"\xcen cel de-al treilea exemplu, este prezentat cazul \xeen care semnalul de reset este verificat ",(0,n.yg)("strong",{parentName:"p"},"asincron"),", iar atribuirile f\u0103cute ie\u0219irii Q sunt ",(0,n.yg)("strong",{parentName:"p"},"blocante"),' \xeen cazul \xeen care semnalul "!rst_n" devine 1 logic sau ',(0,n.yg)("strong",{parentName:"p"},"non-blocante"),' pe frontul cresc\u0103tor al semnalului "clk". \xcen acest caz, se ob\u021bine un modul nesintetizabil.'),(0,n.yg)("h3",{id:"bistabilul-d---reset-verificat-sincron-modul-nesintetizabil"},"Bistabilul D - reset verificat sincron (modul nesintetizabil)"),(0,n.yg)("pre",null,(0,n.yg)("code",{parentName:"pre",className:"language-verilog"},"always @(posedge clk) begin\n    if(rst_n)\n       Q <= D;\nend\n\nalways @(*) begin\n    if(!rst_n)\n       Q <= 0;\nend\n \nendmodule\n")))}d.isMDXComponent=!0}}]);