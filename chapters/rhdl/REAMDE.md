# Circuite secventiale
## Concept
Circuitele secventiale sunt circuite care nu neaparat mapeaza un set
de inputuri la un alt set de outputuri fix. Acest comportament
poate fi realizat numai cu un mecanism de memorie/stare interna, pe care noi ca
mediu exterior o putem afecta doar intr-un mod controlat de logica
interna a acelui circuit. in general nu putem nici sa setam
si nici sa vedem starea interna a unui circuit secvential, dar
putem sa controlam/estimam noi acea stare pe baza specificatiilor
de le avem a acelui circuit.

Exista mai multe tipuri de circuite secventiale:
- Latchuri, care poate sa lucreze in regim de modificare continua
a starii interne, sau un regim in care starea interna ramane nemodificata.
Acest regim este determinat pe baza a unuia sau a mai multor semnale de intrare
- Circuite secventiale asincrone, a caror stare interioara se poate
modifica doar in cadrul unor evenimente instantanee ale unuia sau
a mai multor semnale. Aceste evenimente pot fi trecerea de la 0 la 1 (posedge) sau trecerea de la 1 la 0 (negedge)
- Circuitele secventiale sincrone, care sunt un caz particular al
circuitelor asincrone, starea lor interna se poate modifica doar pe
baza unui semnal periodic stabil numit clock. In general aceste circuite au cel mai mare grad de stabilitate, si desi par limitate,
putem emula comportamentul celorlaltor 2 tipuri de circuite intr-un mod stabil atata timp cat e frecventa clockului suficient de mare

De aceea in general se doreste, si chiar este si optimizat la nivel
de HDL, ca circuitele secventiale sa fie de tip sincron

Un alt aspect important al unui circuit secvential este ca nu putem
sa presupunem ca la start-up vom avea mereu aceeasi stare initiala,
de aceea s-a mai adaugat la majoritatea circuitelor un semnal
numit reset, al carui rol este pur si simplu sa puna circuitul in starea default cat timp e activ.
Acest semnal de reset desi are comportament asincron, nu ne deranjeaza caracteristicile circuitului deoarece este folosit foarte rar,
iar in cazurile in care chiar este activ circuitul nostru nu putem
sa zicem ca se afla in un regim util de functionare
## Implementare
Noi ne vom atinge doar de circuite secventiale sincrone la laborator.
Pentru a putea implementa un astfel de circuit secvential, ne trebuie un struct care implementeaza traiturile `Synchronous`, `SynchronousIO` si `SynchronousDQ`.
### SynchronousDQ
Reprezinta tipurile de date lui `D` si `Q`.
Pentru a intelege ce reprezinta denumirile, ne vom uita la un bistabil D:
// TODO imagine bistabil D
`Q` reprezinta iesirea bistabilului, iar `D` intrarea.
Dar de fapt `Q` este legat direct de continutul memoriei bistabilului, deci putem
sa il interpretam ca si starea curenta.
Iar `D` se leaga de intrarea in bistabil la care cand se va intampla urmatorul eveniment de update,
bistabilul va prelua ca starea valoarea respectiva. Deci putem sa interpretam pe `D` ca si starea urmatoare.

La fel cum putem reprezenta un circuit sincron prin tabelul de adevar cu I,Q/O,D functia noastra `kernel` va lua ca inputuri tipurile I si Q si ca outputuri (O,D)

Acest trait se poate implementa direct, si asta ar presupune ca
doar definesti tipurile `D` si `Q`, sau se poate deriva.

Derivarea traitului SynchronousDQ asupra unui struct va adauga la
```rust
struct CircSecvTop {
    circ1: CircSecv1,
    circ2: CircSecv2,
    ...
}
```
aceste 2 tipuri D si Q
```rust
struct D {
    circ1: <CircSecv1 as rhdl::core::SynchronousIO>::I,
    circ2: <CircSecv2 as rhdl::core::SynchronousIO>::I,
    ...
}
struct Q {
    circ1: <CircSecv1 as rhdl::core::SynchronousIO>::O,
    circ2: <CircSecv2 as rhdl::core::SynchronousIO>::O,
    ...
}
```
:::tip
Observam ca in felul acesta nu avem acces la starea interna a unui
circuit intern, iar starea noastra interna se bazeaza pe outputurile circuitelor secventiale interne
:::

### SynchronousIO
Reprezinta tipurile de date ale lui `I` si `O` cat si functia `kernel` asociata circuitului descris.

Functia `kernel` va avea urmatoarea semnatura:
```rust
#[kernel]
fn my_circuit(cr: ClockReset, i: I, q: Q) -> (O, D);
```
### Synchronous

Avem 2 modalitati de a implementa `Synchronous`.
#### #[derive(Synchronous, SyncronousDQ)]
Se poate face asta automat cu o functie `kernel` care se foloseste de un `Synchronous` si `SynchronousDQ` derivat:
```rust
#[derive(PartialEq, Debug, Clone, Synchronous, SynchronousDQ)]
struct MyCircuit {
    state1: MyOtherCircuit // Circuitul acesta trebuie sa fie si el Synchronous
}
```
#### Manual Synchronous impl
Pentru a implementa manual ne trebuie urmatoarele functii:
```rust
trait Synchronous {
    // Tipul care contine toate informatiile necesare
    type S;
    
    fn init(&self) -> Self::S;

    // Ce se foloseste la simulare.
    fn sim(&self, clock_reset: ClockReset, input: Self::I, state: &mut Self::S) -> Self::O;

    // Template pentru generarea cod hdl (cum ar fi verilog)
    fn hdl(&self, name: &str) -> Result<HDLDescriptor, RHDLError>;

    // Contine nume, tipurile(compatibile hdl) ale i/o si d/q, submodulele, cat si informatii de netlist si rtl
    fn descriptor(&self, name: &str) -> Result<CircuitDescriptor, RHDLError>;
}
```
Din pacate, trebuie sa depindem de un circuit `Synchronous` pentru a face implementare automata la circuitele ulterioare, acesta trebuind
implementat cu functiile de mai sus. Din fericire, exista deja un astfel de circuit de baza.

### rhdl_fpga::DFF
Este un bistabil D generic pe un tip `T` (il putem numi chiar un `register`), care poate primi orice tip de date atata timp cat implementeaza traitul `Digital` si `Default`.
:::warning
Este *obligatoriu* ca tipul nostru sa implementeze traitul `Default`. De ce? Deoarece cand se va da reset pe 1, se va folosi fix acea valoare default.
:::

## Exemplu de implementare, automatul ab
Se cere sa se creeze un automat care sa recunoasca secventa(sa se termine in) 'ab'. Automatul va avea $\Sigma=\{a,b\}$

```rust
#[derive(Debug,PartialEq,Eq,Digital,Clone,Copy)]
enum In {
    a,
    b
}
```

Definim si starile:
```rust
#[derive(Debug,PartialEq,Digital,Default)]
enum StateAB {
    #[default]
    Initial,
    a,
    ab
}
```

Acuma ne vom defini si circuitul cu starile lui interne:
```rust
// Ne folosim de derive sa ne genereze el automat ce ne trebuie
// pentru un circuit secvential. D = Q = FsmAB', unde FsmAB' este
// FsmAB alterat in asa fel incat sa aibe aceleasi campuri ca
// FsmAB doar ca tipurile de date vor fi I-urile de la
// circuitele Synchronous care sunt copii directi ai lui FsmAB
#[derive(Synchronous,SynchronousDQ,Clone,Debug)]
struct FsmAB {
    s: DFF<StateAB>
}

impl Default for FsmAB {
    fn default() -> Self {
        Self {
            s: DFF::new(StateAB::Initial)
        }
    }
}

impl SynchronousIO for FsmAB {
    type I = In,
    type O = bool,
    type Kernel = fsm_ker
}
```

Acesta e un boilerplate necesar pentru fiecare circuit secvential. Acuma logica automatului:
```rust
#[kernel]
fn fsm_ker(_cr: ClockReset, i: I, q: Q) -> (O, D) {
    let (o,d) = match (q.state, i) {
        (StateAB::Initial, In::a) => (false, StateAB::a),
        (StateAB::a, In::b) => (false, StateAB::ab),
        (StateAB::ab, In::a) => (true, StateAB::a),
        (StateAB::ab, In::b) => (true, StateAB::Initial),
        (StateAB::Initial, In::b) => (false, StateAB::Initial),
        (StateAB::a, In::a) => (false, StateAB::a)
    };
    (o, D {s: d} )
}
```
Observati cum nu folosim `ClockReset`-ul, resetul este facut automat pentru noi deoarece am implementat `Default`
