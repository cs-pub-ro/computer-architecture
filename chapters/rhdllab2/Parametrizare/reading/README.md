# Parametrizare
Pana acuma, noi am facut doar circuite de marime statica. Un adder care este hardcodat la 4 biti poate avea o utilitate nisata, doar ca in general nu este util daca vrem sa adunam numere de N biti.

Pentru a putea reutiliza circuitele pe care le scriem, pentru mai multe cazuri de utilizare, este o idee bună să le facem parametrizabile.
Acest lucru îl putem face folosindu-ne de *generics*. 


```rust 
#[kernel]
fn my_parameterized_circuit<U: Unsigned>(_cr: ClockReset, i: (Bits<U>, Bits<U>)) -> Bits<U>
where
    U: Unsigned + BitWidth + Eq + Copy,
{
    // your logic here
}

type MyParameterizedCircuit<U> = Func<(Bits<U>, Bits<U>), Bits<U>>;

fn new<U>() -> Result<MyParameterizedCircuit<U>, RHDLError>
where
    U: Unsigned + BitWidth + Eq + Copy,
{
    Func::try_new::<my_parameterized_circuit<U>>()
}
```

Pentru a crea instanțe pentru aceste circuite:

```rust
let circuit4: MyParameterizedCircuit<U4> = new::<U4>()?;
let circuit8: MyParameterizedCircuit<U8> = new::<U8>()?;
```

Sunt de mentionat 2 fapte totusi, 
in primul rand, parametrii generici, mai ales care vor fi folositi la width-ul unei structuri `Bits`, va fi obligatorie sa fie un `Type` (in cazul la `Bits` acel type va fi si obligat sa implementeze `BitWidth`).
In al 2lea rand, orice semnatura de functie trebuie sa poata sa aibe lungimile
deduse la compile-time.

## Parametrizare derivata
:::warning
*NU* putem face operatii de genul ``Bits<U+T>``, cel putin nu cu metode conventionale. Putem totusi sa emulam asftel de operatii cu wrappere de type
:::
In ``rhdl_typenum`` avem mai multe tipuri auxiliare care ne pot ajuta sa facem operatii la nivel generic, spre exemplu:
- `Add1`
- `Sum`
- `Diff`
- `Maximum`
- `Minimum`

E de mentionat ca fiecare are conditii aditionale, spre exemplu pe langa ca toate trebuie sa fie BitWidth, trebuie ca
- La `Add1<T>` trebuie ca `T: Add<U1>`
- La `Sum<T1,T2>` trebuie ca `T1: Add<T2>`
- La `Diff<T1,T2>` trebuie ca `T1: Sub<T2>`
si asa mai departe...

Daca vreau sa implementez un adder generic, stim ca
outputul mereu va da cu 1 bit mai mult decat inputurile, spre exemplu
```rust
#[kernel]
fn adder_param<T:BitWidth>(_cr:ClockReset, i:(Bits<T>,Bits<T>)) -> Add1<T>
where
    T: Add<U1>,
    Add1<T>: BitWidth; // Nu are cum sa isi dea seama rustc ca se implementeaza BitWidth automat pentru orice caz posibil folosit ulterior de aceasta functie, trebuie noi sa ii explicam manual ca este asa
```

In prelude la rhdl, avem toate aceste tipuri auxiliare, mai putin `Diff`, acesta trebuie sa il importam in mod special din rhdl_typenum

### Macro-ul op!()
exista posibilitatea sa se foloseasca macro-ul ``op!()``, care mapeaza spre exemplu ``op!(U5+U3)`` in ``Sum<U5,U3>`` sau ``op!(U5-U3)`` in ``Diff<U5,U3>`. Desi acest macro pare ca ne face viata mai usoara,
din pacate tot trebuie sa stim ce se intampla in spate pentru a ii da compilatorului hinturi despre trait implementation se fac.

## Crate-ul bitops_rhdl
:::warning
Acest crate e inca work in progress, orice vi se pare ca ar fi trebuit sa mearga si
nu merge, anuntati asistentul de laborator sau faceti un issue pe [Github](https://github.com/cs-pub-ro/computer-architecture)
:::
Este un crate auxiliar creat pentru a emula 2 operatii din verilog cu o sintaxa comoda, acelea fiind bit selection si bit packing
### Motivatie
Daca ati explorat un pic, ati observat probabil ca nu exista vreo cale comoda de a indexa un bit sau o sectiune de biti anume din structura Bits, analog pentru a le concatena.
### Usage
deasupra fiecarei functie kernel la care vrei sa folosesti helperele, pune
```rust
#[bitops] // Mereu se pune aceasta prima
#[kernel]
fn my_ker(...) -> ...
```
### Indexing
Se poate folosi in felul acesta sintaxa de a indexa un bit, sau un slice de biti:
```rust
#[bitops] // Mereu se pune aceasta prima
#[kernel]
fn my_ker(_cr: ClockReset, i: Bits<U8>) -> ... {
    ...
    let u = i[3..0]; // Ultimii 4 biti, va da un Bits<U4>
    let u2 = i[3]; // Al 4lea bit
    let u3 = i[0..3]; // Nepermis, in i[a..b] va trebui ca a >= b
}
```
### Packing
```rust
#[bitops] // Mereu se pune aceasta prima
#[kernel]
fn my_ker(_cr: ClockReset, i: (Bits<U8>,Bits<U8>)) -> ... {
    ...
    // Orice tuplu care are numai indexari in el poate fi folosit
    let u = (i.0[7], i.0[1..0], i.1[7..0]);  // u va fi Bits<U11>, si va avea ca MSB = MSB-ul lui i.0
    let u = (i.0[7], i.0); // Nu are doar indexari, deci va fi pastrat ca atare
}
```
