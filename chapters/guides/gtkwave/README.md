# 🌟 Template IcarusVerilog

Acesta este un **template gata de folosit**, care include **Makefile-ul** și setările / task-urile necesare pentru a putea rula cod **Verilog** pe orice calculator care folosește **Windows**.

> https://github.com/arhitectura-calculatoarelor-resources/IcarusVerilog_Template.git

## Pașii de instalare

### Cerințe

- `Windows 10/11` x64
- `~ 2 GB` spatiu liber
- `Drepturi de instalare

## 1. Instalează MSYS2

### 1.1. Descarcă și instalează

Descarcă și instalează [MSYS2](https://www.msys2.org/) (locație implicită recomandată: `C:\msys64`).

### 1.2. Deschide terminalul corect

Din Start, deschide **MSYS2 MinGW 64-bit**
❗ NU folosi **MSYS** sau **UCRT64**.

### 1.3. Actualizează pachetele

```bash
 pacman  -Syu
```

Daca ți se cere, închide fereastra, apoi redeschide **MSYS2 MinGW 64-bit** și rulează din nou:

```bash
 pacman  -Syu
```

### 1.4. Instalează uneltele necesare

```bash
 pacman -S --needed make mingw-w64-x86_64-iverilog mingw-w64-x86_64-gtkwave
```

### 1.5. Verifică instalarea

```bash
 which  make
 which  iverilog
 which  vvp
 which  gtkwave
```

**Rezultat așteptat:**

- `/usr/bin/make`
- `/mingw64/bin/{iverilog, vvp, gtkwave}`

## 2. Instalează VS Code + extensii

### 2.1. Instaleaza Visual Studio Code

Descarca si instaleaza [Visual Studio Code](https://code.visualstudio.com/).

### 2.2. Extensii recomandate

În VS Code → **View → Extensions**, caută și instalează:

- `mshr-h.veriloghdl` (Verilog/SystemVerilog)
- `ms-vscode.makefile-tools` _(opțional, dar util)_
- `streetsidesoftware.code-spell-checker` _(opțional)_

#### Instalare prin CLI (daca `code` este în PATH):

```bash
 code  --install-extension  mshr-h.veriloghdl
 code  --install-extension  ms-vscode.makefile-tools
 code  --install-extension  streetsidesoftware.code-spell-checker
```

## 3. Clonează repository-ul „starter”

Înlocuiește `<REPO_URL>` cu adresa repository-ului.

### Varianta PowerShell / CMD:

```powershell
 cd %USERPROFILE%\Desktop
 git clone <REPO_URL>
 code verilog-starter
```

### Varianta MSYS2 (opțional):

```bash
 cd  /c/Users/%USERNAME%/Desktop
 git  clone <REPO_URL>
```

> 💡 La prima deschidere, VS Code va propune „Install recommended extensions”. Apasă **Accept**.

## 4. Ce conține repository-ul

- `.vscode/tasks.json` – Task „one-click” care rulează: **compilează (iverilog) → rulează (vvp) → deschide GTKWave**
- `.vscode/settings.json` – Configurare linter, calea către iverilog și setări cSpell
- **Makefile** – alternativă la task pentru compilare, rulare și deschidere GTKWave

## 5. Rulează primul exemplu

1. In VS Code: **File → Open Folder...** și deschide folderul repository-ului.
2. Deschide `examples/tb_counter.v`.
3. Apasă **Ctrl + Shift + B** → alege sau rulează direct **Verilog: Build + Run + GTKWave**.

**Ce se întamplă:**

- Se compilează (`sim.vvp`)
- Se rulează simularea
- Se generează `waves.vcd`
- Se deschide GTKWave

> Daca apare „Select default build task”, alege **Verilog: Build + Run + GTKWave**.

## 6. Reguli standard pentru testbench

Pentru a vizualiza semnalele în GTKWave, adaugă în testbench urmatorul bloc:

```verilog
 initial begin
	 $dumpfile("waves.vcd");
	 $dumpvars(0, tb_dut); // inlocuieste "tb_dut" cu numele modulului TB
 end
```

De asemenea, adauga o conditie de terminare a simularii:

```verilog
 #100 $finish; // opreste simularea dupa 100 unitati de timp
```

## 7. Rulare manuală din MSYS2 (opțional)

```bash
 iverilog -g2012  -Wall  -o  sim.vvp $(find  .  -name  '*.v'  -o  -name  '*.sv')
 vvp sim.vvp
 gtkwave waves.vcd &
```

Dacă folosești Makefile:

```bash
 make wave
```

## 8. Probleme frecvente

| Problema                                   | Soluția                                                                                                                                       |
| ------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------- |
| **Se deschide alt terminal MSYS2**         | Deschide **MSYS2 MinGW 64-bit**, apoi rulează: <br /> `which iverilog` <br /> Trebuie să afișeze: <br /> `/mingw64/bin/iverilog`              |
| **make: command not found**                | Instalează make: <br /> `pacman -S make`                                                                                                      |
| **GTKWave nu se deschide**                 | Verifică dacă fișierul `waves.vcd` există. <br /> Asigură-te că ai în testbench instrucțiunile `$dumpfile` și `$dumpvars`.                    |
| **No top level modules, and no -s option** | Deschide testbench-ul și rulează din nou. <br /> Makefile-ul detectează automat top-ul curent.                                                |
| **VS Code pornește msbuild**               | În VS Code mergi la: <br /> **Terminal → Configure Default Build Task** <br /> Alege **Verilog: Build + Run + GTKWave**.                      |
| **Linter nu găsește iverilog**             | În fișierul `.vscode/settings.json`, confirmă că ai calea corectă: <br /> `"verilog.iverilog.path": "C:\\msys64\\mingw64\\bin\\iverilog.exe"` |
| **MSYS2 nu este în `C:\msys64`**           | În fișierul `.vscode/tasks.json`, editează: <br /> `"command": "C:\\msys64\\usr\\bin\\bash.exe"` <br /> și pune calea reală.                  |

## 9. Acum ești pregătit îți simulezi propriile proiecte 🚀

1. Pune fisierele `.v` / `.sv` in folderul repo-ului (`examples/` sau alt subfolder).
2. Deschide testbench-ul.
3. Apasa **Ctrl + Shift + B**.
4. GTKWave iti va afisa semnalele din `waves.vcd`.

> 💡 Poți salva o vizualizare GTKWave ca `view.gtkw` pentru a fi încarcată automat la urmatoarea rulare.

## Concluzie

Ai obținut un mediu complet configurat pentru:

- Simulare **Verilog**
- Vizualizare semnale cu **GTKWave**
- Flux rapid și portabil
