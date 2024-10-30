# Practice: Memory

  Soluția se află în repo-ul materiei [GitHub](https://github.com/cs-pub-ro/computer-architecture/tree/main/chapters/verilog/memory/drills/tasks). 

 -Modulul `Register` reprezinta cun functioneaza un registru real.Semnalele oe și we reprezintă Output Enable, respectiv Write Enable.
    - `oe` controlează ieșirea registrului. Când oe este `high` ieșirea este activă având valoarea memorată de registru. Când oe este low ieșirea va fi 0. Acest semnal trebuie să fie asincron: modificarea lui va avea efect imediat asupra ieșirii și nu se va aștepta tranziția semnalului de ceas.
    - `we` controlează scrierea în registru. Când we este high registrul va memora valoarea aflată în semnalul de intrare. Când we este low valoarea registrului nu se va modifica, ignorând practic semnalul de intrare. Acest semnal trebuie să fie sincron: modificarea valorii memorate de registru se face doar în momentul tranziției semnalului de ceas.
    - Semnalul `disp_out` este folosit pentru afișare/debugging pe display, iar valoarea acestuia trebuie să fie cea memorată de registru în momentul curent. În mod normal acest semnal nu este prezent într-un calculator. Acest semnal nu trebuie să fie afectat de oe, valoarea disponibilă pe disp_out fiind în orice moment egală cu valoarea memorată de registru.
    - Semnalul de reset `rst_n` este activ pe low (0).
    - Hint: Puteți folosi operatorul condiţional.
- Pornind de la interfața modulului `sequential_multiplier` din scheletul de cod, implementați un automat de stări care să folosească instanțe parametrizate ale modulului `register` pentru a îndeplini următoarele funcționalități:
   - La activarea semnalului `write`, valorile semnalelor `a` și `b` sunt scrise în registre parametrizate corespunzător.
   - La activarea semnalului `multiply`, valorile din cele două registre sunt extrase, înmulțite și rezultatul adăugat într-un al treilea registru.
   - La activarea semnalului `display`, semnalul `out` va primi valoarea aflată în al treilea registru.
   - Prioritatea celor trei semnale este dată de ordinea în care au fost descrise:
      - Dacă `write` este activ, se ignoră semnalele `multiply` și `display`.
      - Dacă `multiply` este activ, se ignoră semnalul `display`.
   
- Modulul `ram_reader` este o interfață simplă pentru RAM care permite citirea și scrierea în RAM. Utilizează semnalul `i_w_we` pentru a controla operațiile de scriere și semnalul `i_w_oe` pentru a controla operațiile de citire. De asemenea se specifica si adresa de la care sa fie citita/scrisa valoarea cu semnalul `i_w_address`