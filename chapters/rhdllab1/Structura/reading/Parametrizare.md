### Parametrizare lungime

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
<!-- are sens sa povestesc de bound-urile cu Unsigned si BitWidth
ele doar trebuie sa apara daca decid sa faca un modul parametrizabil
ca sa fie compliant cu Ux ala de le genereaza un amcro din spate -->
