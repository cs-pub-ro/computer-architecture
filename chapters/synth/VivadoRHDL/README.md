# Folosirea RHDL in Vivado

In mare parte, noi cand scriem codul RHDL, o sa il convertim in Verilog, XDC si TCL. TCL-ul va fi rulat cu Vivado pentru a sintetiza codul in un bitstream si flashui placuta de laborator.

## Fixture
Un Fixture este un wrapper peste circuitele noastre. El ne da posibilitatea de a redenumi semnalele (dupa cum ati observat, pana acuma mereu erau in VCD puse toate semnalele la gramada in porturile input/output)


Pentru a putea crea un Fixture, trebuie ca structura noastra sa implementeze ``Circuit``.
### Circuit
Un trait care reprezinta cea mai pura forma a unui circuit RHDL. Acesta trebuie sa respecte anumite conditii, anume sa aibe inputuri si outputuri sa fie Timed. Acest trait il are doar tipul ``Signal<T: Digital, D: Domain>`` by default. Interfetele Synchronous abstractizeaza inputurile si outputurile sale astfel incat sa fie nevoie doar de Digital, deoarece ele opereaza in acelasi Clock Domain. Totusi acestea nu implementeaza ``Circuit``.

Pentru a face asta, ne trebuie un ``Adapter``
#### Adapter
Adapterul ia un circuit Synchronous si ne face sa il putem folosi in un context Asynchronous pe un domain oarecare.
```rust
struct Adapter<T: Synchronous, D: Domain> { ... }
```
unde T e circuitul nostru, si D e un clock domain. In general vom lucra cu un singur Clock Domain in toata ierarhia noastra de module.

Sintaxa de declarare este
```rust
let x: Adapter<MyCircuit, Red> = Adapter::new(MyCircuit::default())
```
unde Red e un Clock Domain oarecare declarat in prelude.
### Driver
Un fixture poate sa aibe mai multe drivere. In general, un circuit inner
poate sa aibe aceste valori redenumite, chiar si wrapped in functionalitate printr-un driver.

Acesta tine minte si constrangerile fiecarui pin imparte cu care are de a face.

Metodele de baza sunt
```rust
// Adds a driver for an inner input
fn pass_through_input(&mut self, name: &str, path: &Path);
// Adds a driver for an inner output
fn pass_through_output(&mut self, name: &str, path: &Path);
// Drives an inner input with a constant value of choice
fn constant_driver<S: Digital>(&mut self, val: S, path: &Path);
// Adds a custom driver
fn add_driver(&mut self, driver: Driver<T>);
```

Drivere custom gasiti in ``chapters/rhdl/nexys-a7`` pentru placuta noastra

acestea se pot declara in felul urmator:
```rust
    // Driver de clock pentru nexys a7, stie exact ce pin se foloseste, se bazeaza ca dai clock mereu, altfel da RHDLError
    fixture.add_driver(nexys_a7::drivers::sys_clk::sys_clock(
        &path!(.clock_reset.val().clock),
    )?);
    fixture.constant_input(reset(false), &path!(.clock_reset.val().reset))?;
    // Driver de output, primeste un name, path si optiuni, analog pentru input
    fixture.add_driver(nexys_a7::drivers::output::build(
        "rst",
        &path!(.val()),
        &lvcmos33_out(&LEDS, 0..8)
    )?);
```

### rhdl_bsp
In acest crate, avem utilitare pentru a putea crea constrangeri si scripturi pentru Vivado. Dar pentru asta, trebuie sa intelegem workflow-ul acestuia

#### Constrangeri
Trebuie sa declaram intrarile si iesirile mapate la fire din design-ul nostru, acest lucru se face prin un fisier XDC care contine linii de genul acesta:
```tcl
set_property -dict { PACKAGE_PIN E1    IOSTANDARD LVCMOS33 } [get_ports { led0_b }]; #IO_L18N_T2_35 Sch=led0_b
```

spre exemplu, led0_b este un fir de output din design-ul nostru top, E1 reprezinta placementul din ``Ball Grid Array``-ul de pe spatele chipului FPGA. E e randul, 1 e coloana. Acesta se poate declara folosind macro-ul bga_pin!(E,1). Mai e si IOSTANDARD-ul, care in cazul nostru e LowVoltageCMOS3v3. Acesta reprezinta tehnologia folosita pentru IO.

Dupa cum a fost povestit in sectiunea anterioara, avem mai multe IO Bank-uri. Se doreste ca IOSTANDARD-ul pe un bank IO sa fie comun. Pe placuta noastra de dezvoltare, perifericele sunt proiectate cu LVCMOS33, deci nu vom schimba nimic aici. Exista un enum numit IOStandard care contine cateva standarde comune(toate le gasiti in datasheet)
#### TCL
Scurt pentru Tool Command Line, este limbajul de scripting folosit de Vivado. Pentru a nu fi nevoiti sa deschidem IDE-ul Vivado, putem rula un script tcl cu comanda ```vivado -mode batch -source run.tcl```

Acest script este facut de Builder-ul de Vivado aflat tot in crate-ul rhdl_bsp, iar in schelet tot ce facem e sa cream un proiect, adaugam fixture-ul nostru si generam bitstreamul.
