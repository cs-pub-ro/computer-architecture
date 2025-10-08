---
---

# 00 – Introducere în Rust

Vom folosi limbajul de programare [Rust](https://www.rust-lang.org/) pentru laboratoare.

## Resurse
1. The Rust Programming Language, capitolele [1](https://doc.rust-lang.org/book/ch01-00-getting-started.html), [2](https://doc.rust-lang.org/book/ch02-00-guessing-game-tutorial.html), [3](https://doc.rust-lang.org/book/ch03-00-common-programming-concepts.html), [4](https://doc.rust-lang.org/book/ch04-00-understanding-ownership.html) și [5](https://doc.rust-lang.org/book/ch05-00-structs.html)
2. [Tour of Rust](https://tourofrust.com) – tutorial pas cu pas
3. *Let's Get Rusty* – [The Rust Lang Book](https://www.youtube.com/playlist?list=PLai5B987bZ9CoVR-QEIN9foz4QCJ0H2Y8)
   - [Structuri în Rust](https://www.youtube.com/watch?v=n3bPhdiJm9I)
   - [Enum și Pattern Matching](https://www.youtube.com/watch?v=DSZqIJhkNCM)
   - [Gestionarea erorilor în Rust](https://www.youtube.com/watch?v=wM6o70NAWUI)
   - [Colecții comune în Rust](https://www.youtube.com/watch?v=Zs-pS-egQSs)
   - [Înțelegerea Ownership în Rust](https://www.youtube.com/watch?v=VFIOSWy93H0)

:::tip
Acest laborator este destul de lung, dar încearcă să fie o introducere rapidă în Rust. Îți sugerăm să mergi direct la [Exerciții](#exercises), să le rezolvi pe rând și să citești documentația necesară pe parcurs.
:::

## Biblioteca standard

Biblioteca standard este împărțită în trei niveluri:

| Nivel | Descriere | Necesită |
|-------|:-----------|:---------|
| [`core`](https://doc.rust-lang.org/core/index.html) | Oferă elementele esențiale de limbaj necesare compilării, precum trăsăturile [`Display`](https://doc.rust-lang.org/core/fmt/trait.Display.html) și [`Debug`](https://doc.rust-lang.org/core/fmt/trait.Debug.html). Datele pot fi doar elemente globale (stocate în *.data*) sau pe *stack*. | Hardware |
| [`alloc`](https://doc.rust-lang.org/alloc/index.html) | Include tot ce oferă `core`, plus structuri de date alocate pe *heap*, precum [`Box`](https://doc.rust-lang.org/alloc/boxed/struct.Box.html) și [`Vec`](https://doc.rust-lang.org/std/vec/struct.Vec.html). Dezvoltatorul trebuie să furnizeze un alocator de memorie, cum ar fi [embedded_alloc](https://docs.rs/embedded-alloc/latest/embedded_alloc/). | Alocator de memorie |
| [`std`](https://doc.rust-lang.org/std/index.html) | Include tot din `alloc`, plus multe funcționalități dependente de platformă, inclusiv fire (threads) și I/O. Acesta este nivelul implicit pentru aplicații pe Windows, Linux, macOS și sisteme similare. | Sistem de operare |

Implicit, Rust are un set de elemente definite în biblioteca standard care sunt importate în programul fiecărei aplicații. Acest set se numește *prelude* și îl poți consulta în [documentație](https://doc.rust-lang.org/std/prelude/index.html).

Dacă un tip pe care vrei să îl folosești nu se află în *prelude*, trebuie să îl aduci explicit în *scope* cu o instrucțiune `use`.
Folosirea modulului `std::io` îți oferă mai multe funcționalități utile, inclusiv posibilitatea de a accepta input de la utilizator.

```rust
use std::io; 
```

## Funcția `main`

Funcția `main` este punctul de intrare al programului.

```rust
fn main() {
    println!("Hello, world!");
}
```

Folosim macro‑ul `println!` pentru a afișa mesaje pe ecran.

:::info
Pentru a afișa variabile mai complexe, poți folosi `{:?}`, care asigură că orice tip care implementează trăsătura `Debug` poate fi afișat.
:::

Pentru a insera un placeholder în macro‑ul `println!`, folosește o *pereche de acolade* `{}`. Variabila sau expresia care înlocuiește placeholderul este furnizată în afara șirului.

```rust
fn main() {

    let name = "Mary";
    let age = 26;

    println!("Hello, {}. You are {} years old", name, age);
    // dacă înlocuirile sunt doar variabile, se poate folosi versiunea inline
    println!("Hello, {name}. You are {age} years old");
}
```

## Variabile și mutabilitate

Folosim cuvântul cheie `let` pentru a crea o variabilă.

```rust
let a = 5;
```

Implicit, în Rust variabilele sunt **imutabile**, adică odată ce o valoare este legată de un nume, nu poți schimba acea valoare.

Exemplu:

```rust
fn main() {
    let x = 5;
    println!("The value of x is: {x}");
    x = 6;
    println!("The value of x is: {x}");
}
```

În acest caz, vom obține o eroare de compilare deoarece încercăm să modificăm valoarea lui `x` din `5` în `6`, însă `x` este imutabil, deci nu putem face această modificare.

Deși variabilele sunt imutabile în mod implicit, le poți face **mutabile** adăugând `mut` în fața numelui variabilei. Adăugarea lui `mut` transmite și intenția către cititorii viitori ai codului, indicând că alte părți ale codului vor modifica valoarea acestei variabile.

```rust
fn main() {
    let mut x = 5;
    println!("The value of x is: {x}");
    x = 6;
    println!("The value of x is: {x}");
}
```

Acum valoarea lui `x` poate deveni `6`.


## Constante

La fel ca variabilele imutabile, constantele sunt valori asociate unui nume și au o **valoare cunoscută la momentul compilării**.

Nu este permis să folosești `mut` cu constante. Constantele nu sunt doar imutabile implicit — ele sunt întotdeauna imutabile. Se declară folosind cuvântul cheie `const` în loc de `let`.  
Tipul de date al constantei trebuie specificat la momentul declarației.

```rust
const THREE_HOURS_IN_SECONDS: u32 = 60 * 60 * 3;
```

:::info 
Pentru o înțelegere mai bună, citește [capitolul 3](https://doc.rust-lang.org/book/ch03-00-common-programming-concepts.html) din documentație.
:::

## Tipuri de date

### Tipuri scalare

Un tip scalar reprezintă o singură valoare. Rust are patru tipuri scalare principale: întregi, numere în virgulă mobilă, valori booleene și caractere.

**Întregi** → Fiecare variantă poate fi cu semn sau fără semn și are o dimensiune explicită.
```rust
let x: i8 = -2;
let y: u16 = 25;
```

| Lungime | Cu semn | Fără semn| Echivalent Java | Echivalent C[^c_equivalent] |
|:--------:|:------:|:---------:|:----------------:|:----------------:|
| 8-bit | `i8` | `u8` | `byte` / `Byte`[^java_unsigned] | `char` / `unsigned char` |
| 16-bit | `i16` | `u16` | `short` / `Short`[^java_unsigned] | `short` / `unsigned short` |
| 32-bit | `i32` | `u32` | `int` / `Integer`[^java_unsigned] | `int` / `unsigned int` |
| 64-bit | `i64` | `u64` | `long` / `Long`[^java_unsigned] | `long long` / `unsigned long long` |
| 128-bit | `i128` | `u128` | N/A | N/A |
| arch | `isize` | `usize` | N/A | `intptr_t` / `uintptr_t` |

**Numere în virgulă mobilă** → Tipurile numerelor în virgulă mobilă în Rust sunt `f32` și `f64`, care au dimensiuni de 32, respectiv 64 de biți. Tipul implicit este `f64`, deoarece pe procesoarele moderne este la fel de rapid ca `f32`, dar oferă o precizie mai mare. Toate tipurile cu virgulă mobilă sunt **cu semn**.

| Lungime | Tip | Echivalent Java | Echivalent C |
|:--------:|:----:|:----------------:|:----------------:|
| 32-bit | `f32` | `float` | `float` |
| 64-bit | `f64` | `double` | `double` |
| 128-bit | `f128` | N/A | N/A |

```rust
fn main() {
    let x = 2.0; // f64
    let y1: f32 = 3.0; // f32
    let y2 = 3.0f32; // f32
}
```

**Boolean** → Tipul boolean ocupă un octet. Tipul se specifică prin `bool`.

```rust
let t = true;
let f: bool = false; // cu adnotare de tip explicită
```

**Caractere** → Tipul `char` din Rust este cel mai elementar tip pentru reprezentarea caracterelor alfabetice.

```rust
let c = 'z';
let z: char = 'ℤ'; // cu adnotare explicită
let heart_eyed_cat = '😻';
```

### Structuri

Structurile sunt un tip de date care conțin alte tipuri de date sub formă de câmpuri. Structurile din Rust sunt similare cu structurile din C și cu clasele din Java.

Pentru a defini o structură, folosim cuvântul cheie `struct` urmat de numele structurii. Apoi, între acolade, definim numele și tipurile câmpurilor

```rust
struct User {
    active: bool,
    username: String,
    email: String,
    sign_in_count: u64,
}
```

Pentru a folosi o structură după ce a fost definită, creăm o **instanță** a acesteia, specificând valori concrete pentru fiecare câmp. Creăm o instanță **alocată pe stack** specificând numele structurii, urmat de acolade ce conțin perechi `cheie: valoare`, unde cheile sunt numele câmpurilor, iar valorile sunt datele care vor fi stocate.

```rust
fn main() {
    let user1 = User {
        active: true,
        username: String::from("someusername123"),
        email: String::from("someone@example.com"),
        sign_in_count: 1,
    };
}
```

Pentru a accesa un anumit membru al structurii, folosim această sintaxă:

```rust
fn main() {
    let mut user1 = User {
        active: true,
        username: String::from("someusername123"),
        email: String::from("someone@example.com"),
        sign_in_count: 1,
    };

    user1.email = String::from("anotheremail@example.com")
}
```

:::warning 
Reține că întreaga instanță trebuie să fie **mutabilă**; Rust **nu permite** marcarea doar a unor câmpuri ca mutabile!
:::


#### Implementarea structurii

Structurile în Rust sunt similare cu clasele din programarea orientată pe obiecte (OOP). Pe lângă operațiile de bază, structurile pot avea implementări și metode specifice. Metodele sunt definite în blocul `impl` al structurii.

```rust
struct User {
    active: bool,
    username: String,
    email: String,
    sign_in_count: u64,
}

impl User {
    // metodă statică (fără parametru self)
    // se apelează cu User::new()
    fn new() -> User {
        // ...
    }
    // metodă de instanță
    // se apelează cu user.is_active()
    fn is_active(&self) -> bool {
        return self.active;
    }
}
```

#### Afișarea structurilor

Dacă încercăm să afișăm o instanță a structurii `User` folosind macro-ul `println!` ca mai devreme, nu va funcționa.

```rust
fn main() {
    let user1 = User {
        active: true,
        username: String::from("someusername123"),
        email: String::from("someone@example.com"),
        sign_in_count: 1,
    };

    println!("User is: {}", user1);
}
```

Vom primi următorul mesaj de eroare:
```
error[E0277]: `User` doesn't implement `std::fmt::Display`
```

Pentru a putea afișa o structură, trebuie să folosim `{:?}` în loc de `{}` și să implementăm trăsătura `Debug` pentru structură, folosind `#[derive(Debug)]`.

:::note
Trăsătura `Debug` este folosită pentru a afișa structuri, tablouri, enumuri sau orice alt tip care nu implementează `Display`.
:::

```rust
#[derive(Debug)]
struct User {
    active: bool,
    username: String,
    email: String,
    sign_in_count: u64,
}

fn main() {
    let user1 = User {
        active: true,
        username: String::from("someusername123"),
        email: String::from("someone@example.com"),
        sign_in_count: 1,
    };

    println!("User is: {:?}", user1);
}
```

Rezultat:
```
User is: User { active: true, username: "someusername123", email: "someone@example.com", sign_in_count: 1 }
```

:::tip
Pentru o formatare mai lizibilă a `Debug`, folosește `{:#?}`.
:::

### Structuri tuple

Structurile tuple sunt similare cu structurile obișnuite, dar în loc de a folosi nume pentru câmpuri, folosesc indici (numere).

```rust
struct Color(i32, i32, i32);
struct Device(String, u8);

fn main() {
    let black = Color(0, 0, 0);
    let device = Device(String::from("Raspberry Pi Pico"), 2);

    println!("Tipul dispozitivului este {} și versiunea este {}", device.0, device.1);
}
```

Tuplurile pot fi *cu nume* (ca în exemplul de mai sus) sau *anonime*.  
Exemplul următor arată cum funcțiile pot folosi tupluri anonime pentru a returna mai multe valori.

```rust
fn get_item_and_index(value: &str) -> (String, usize) {
    // de obicei se caută valoarea aici
    (String::from("the name"), 0)
}

let value = get_item_and_index("...");
// folosește value.0 și value.1
```

:::info 
Pentru o înțelegere mai bună, citește [capitolul 5](https://doc.rust-lang.org/book/ch05-00-structs.html) din documentație.
:::

### Enumuri

Enumurile (enumerations) permit definirea unui tip prin enumerarea variantelor posibile.  
Cum definim un `enum`:

```rust
enum IpAddrKind {
    V4,
    V6,
}
```


#### Enumul `Option`

`Option` este un alt `enum` definit în biblioteca standard. Tipul `Option` reprezintă scenariul comun în care o valoare poate fi prezentă sau absentă.

Rust **nu are conceptul de null**, așa cum au alte limbaje. Null reprezintă o valoare care înseamnă „nu există valoare aici”. În limbajele care permit `null`, variabilele pot fi fie `null`, fie non‑null.

Rust nu are valori `null`, dar oferă o enumerare care poate reprezenta prezența sau absența unei valori. Aceasta este `Option<T>`, definită în biblioteca standard astfel:

```rust
enum Option<T> {
    None,
    Some(T),
}
```

Aici `<T>` indică faptul că varianta `Some` a enumului poate conține date de **orice tip**.

```rust
fn integer_division(a: isize, b: isize) -> Option<isize> {
    if b == 0 {
        None
    } else {
        Some(a / b)
    }
}
```

Când avem o valoare `Some`, știm că există o valoare validă în interior. Când avem `None`, înseamnă că nu avem o valoare validă — similar cu `null` în alte limbaje.

:::note
Trebuie să convertești un `Option<T>` într-un `T` înainte de a putea efectua operații specifice pe el.
:::

#### `match`

Rust oferă o construcție de control foarte puternică numită `match`, care permite compararea unei valori cu o serie de modele și executarea codului corespunzător modelului potrivit.  
Modelele pot fi valori literale, nume de variabile, wildcard‑uri etc.

```rust
enum Coin {
    Penny,
    Nickel,
    Dime,
    Quarter,
}

fn value_in_cents(coin: Coin) -> u8 {
    match coin {
        Coin::Penny => 1,
        Coin::Nickel => 5,
        Coin::Dime => 10,
        Coin::Quarter => 25,
    }
}
```

Când expresia `match` rulează, valoarea este comparată cu fiecare braț în ordine. Dacă un model se potrivește, codul asociat acelui model este executat. Dacă nu, se continuă la următorul braț.

Codul din fiecare braț este o **expresie**, iar valoarea rezultată devine **valoarea returnată** a întregii expresii `match`.

În secțiunea anterioară am dorit să extragem valoarea internă `T` din varianta `Some` a lui `Option<T>`. Putem face asta și folosind `match`, exact ca în exemplul cu `Coin`.

```rust
fn main() {
    let x = 120;
    let y = 7;
    match integer_division(x, y) {
        Some(d) => println!("{}:{} = {}", x, y, d),
        None => println!("division by 0")
    };
}
```

#### Enumul `Result`

`Result` este un `enum` folosit pentru a reprezenta rezultatul unei operații care poate eșua.

- Varianta `Ok` indică faptul că operația a fost reușită, iar valoarea se află în `Ok`.
- Varianta `Err` indică faptul că a apărut o eroare, iar în interior se află informații despre acea eroare.

Definiția din biblioteca standard este:

```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

unde `T` și `E` sunt tipuri generice — `T` pentru valoarea de succes, `E` pentru eroare.

Exemplu:

```rust
use std::fs::File;

fn main() {
    let greeting_file_result = File::open("hello.txt");

    let greeting_file = match greeting_file_result {
        Ok(file) => {
            // utilizăm variabila file aici
        }
        Err(error) => panic!("Problem opening the file: {:?}", error),
    };
}
```

##### Operatorul `?`

Poți plasa `?` după o expresie care returnează un `Result`. Dacă rezultatul este `Err`, eroarea este propagată imediat către apelant; altfel, se continuă cu valoarea din `Ok`.

Exemplu:

```rust
use std::fs::File;
use std::io::{self, Read};

fn read_username_from_file() -> Result<String, io::Error> {
    let mut username = String::new();

    File::open("hello.txt")?.read_to_string(&mut username)?;

    Ok(username)
}
```

:::info 
Pentru o înțelegere mai bună, citește [capitolul 6](https://doc.rust-lang.org/book/ch06-00-enums.html) din documentație.
:::


**Tuple** → Un tuple este o structură folosită pentru a grupa mai multe valori de tipuri diferite într-un singur tip compus. Tuplurile au o lungime **fixă**: odată declarate, dimensiunea lor nu se poate modifica.

```rust
let tup: (i32, f64, u8) = (500, 6.4, 1);
```

**Array** → Spre deosebire de tuple, toate elementele unui array trebuie să aibă **același tip**. În plus, array‑urile în Rust au o lungime **fixă**.

```rust
let a = [1, 2, 3, 4, 5];
```

:::info 
Pentru o înțelegere mai bună, citește [capitolul 3](https://doc.rust-lang.org/book/ch03-00-common-programming-concepts.html) din documentație.
:::

## Funcții

Definim o funcție în Rust folosind cuvântul cheie `fn`, urmat de numele funcției și paranteze. Acoladele definesc începutul și sfârșitul corpului funcției.

```rust
fn main() {
    println!("Hello, world!");

    another_function();
}

fn another_function() {
    println!("Another function.");
}
```

#### Parametri

Putem defini funcții cu parametri — variabile speciale care fac parte din semnătura funcției. Când o funcție are parametri, îi putem furniza *valori concrete*, numite *argumente*.

```rust
fn main() {
    // apelul funcției `another_function` are un singur argument, valoarea 5
    another_function(5);
}

// funcția `another_function` are un singur parametru `x` de tip `i32`
fn another_function(x: i32) {
    println!("The value of x is: {x}");
}
```

:::note 
În semnătura funcțiilor trebuie declarat tipul fiecărui parametru!
:::

#### Funcții cu valori de retur

Funcțiile pot returna valori către codul care le apelează. Nu este nevoie să denumim valoarea returnată, dar trebuie să îi declarăm tipul după o *săgeată* (`->`).  
În Rust, valoarea returnată a funcției este echivalentă cu valoarea **ultimei expresii** din corpul funcției. Putem returna anticipat dintr-o funcție folosind cuvântul cheie `return`, dar de obicei ultima expresie este suficientă.

```rust
fn five() -> i32 {
    5
}

fn main() {
    let x = five();
    println!("The value of x is: {x}"); // "The value of x is: 5"
}
```

:::info 
Pentru o înțelegere mai bună, citește [capitolul 3](https://doc.rust-lang.org/book/ch03-00-common-programming-concepts.html) din documentație.
:::

## Flux de control

### if‑else

Toate expresiile `if` încep cu cuvântul cheie `if`, urmat de o condiție. Opțional, putem include și o ramură `else`.

```rust
fn main() {
    let number = 3;

    if number < 5 {
        println!("condition was true");
    } else {
        println!("condition was false");
    }
}
```

Putem combina mai multe condiții folosind `else if`:

```rust
fn main() {
    let number = 6;

    if number % 4 == 0 {
        println!("number is divisible by 4");
    } else if number % 3 == 0 {
        println!("number is divisible by 3");
    } else if number % 2 == 0 {
        println!("number is divisible by 2");
    } else {
        println!("number is not divisible by 4, 3, or 2");
    }
}
```

Pentru că `if` este o expresie, o putem folosi **în partea dreaptă** a unei declarații `let` pentru a atribui rezultatul unei variabile.

```rust
fn main() {
    let condition = true;
    let number = if condition { 5 } else { 6 };

    println!("The value of number is: {number}"); // "The value of number is: 5"
}
```

### loop

Cuvântul cheie `loop` spune lui Rust să ruleze un bloc de cod în mod repetat, la infinit, până când îi spunem **explicit** să se oprească.

```rust
fn main() {
    loop {
        println!("again!");
    }
}
```

Un caz de utilizare al `loop` este reîncercarea unei operații care poate eșua, cum ar fi verificarea dacă un fir de execuție și‑a terminat munca.  
Putem de asemenea returna o valoare dintr‑un `loop` folosind `break` urmat de expresia dorită.

```rust
fn main() {
    let mut counter = 0;

    let result = loop {
        counter += 1;

        if counter == 10 {
            break counter * 2;
        }
    };

    println!("The result is {result}");
}
```

### while

```rust
fn main() {
    let mut number = 3;

    while number != 0 {
        println!("{number}!");

        number -= 1;
    }

    println!("LIFTOFF!!!");
}
```

### for

În Rust, structura **for** este folosită pentru a itera peste o listă de elemente (de exemplu, un `vec`).  
La fiecare iterație, se returnează o referință către un element din listă.

```rust
fn main() {
    let a = [10, 20, 30, 40, 50];

    for element in a {
        println!("the value is: {element}");
    }
}
```

:::info 
Pentru o înțelegere mai bună, citește [capitolul 3](https://doc.rust-lang.org/book/ch03-00-common-programming-concepts.html) din documentație.
:::


## Tipuri de date complexe

### Vec

Tipul de date pe care Rust îl oferă pentru stocarea unei liste de date este `Vec`. Este similar cu `vector` din C++ sau `ArrayList` din Java.

Tipul unui vector este `Vec<T>`, unde `T` poate fi orice tip de date.

Pentru a crea un vector nou, Rust oferă macro‑ul `vec!`. O formă mai lungă este `Vec::new()`.

```rust
let v = vec![];
// sau
let v = Vec::new();
```

Tipul efectiv al lui `T` este de obicei dedus de compilator.

:::warning
Uneori compilatorul nu poate deduce tipul, și atunci trebuie să îl specificăm explicit.

```rust
let v: Vec<String> = vec![];
// sau
let v = Vec::<String>::new();
```
:::

Tipul `Vec` oferă mai multe funcții pentru a insera, accesa și elimina elemente.

| Metodă | Descriere | Tip de date returnat |
|-|-|-|
| `len()` | Numărul de elemente din vector | `usize` |
| `push(t: T)` | Adaugă un element de tip `T` la finalul vectorului | `()` |
| `get(index: usize)` | Obține o referință către un element al vectorului | `Option<&T>` |
| `get_mut(index: usize)` | Obține o referință mutabilă către un element al vectorului | `Option<&mut T>` |
| `remove(index: usize)` | Elimină elementul de la un anumit index | `T` |

:::warning
Funcția `remove` va genera panic dacă `index` este în afara limitelor.
:::

Cel mai bun mod de a itera prin toate elementele unui `Vec` este folosind un `for`:

```rust
for element in v {
    // folosește element de tip &T
}
```

### String

Rust are doar un singur tip de șir în nucleul limbajului: *slice‑ul de șiruri* `str`, de obicei folosit sub forma împrumutată `&str`.

Tipul `String`, care este oferit de biblioteca standard Rust, este un șir UTF‑8 redimensionabil, mutabil și deținut (owned).

#### Crearea unui String nou

```rust
let mut s = String::new();
```

Această linie creează un nou șir gol numit `s`, în care putem încărca ulterior date.

Putem folosi funcția `String::from` sau metoda `to_string` pentru a crea un șir dintr‑un literal:

```rust
let s = String::from("initial contents");
```
```rust
let data = "initial contents";

let s = data.to_string();

// metoda funcționează și direct pe literal:
let s = "initial contents".to_string();
```

#### Adăugarea la un String

Putem extinde un șir folosind metoda `push_str`, care adaugă un *slice* de șiruri.

```rust
let mut s = String::from("foo");
s.push_str("bar");
```

Metoda **`push`** primește **un singur caracter** și îl adaugă la finalul șirului.

```rust
let mut s = String::from("lo");
s.push('l');
```

#### Metode de iterație pe String‑uri

Cea mai bună modalitate de a opera pe fragmente de șiruri este să specificăm clar dacă dorim caractere sau octeți.  
Pentru valori Unicode individuale, folosim metoda `chars`:

```rust
for c in "Зд".chars() {
    println!("{}", c);
}
```

## Rularea programului

Pentru a rula programul, ne putem afla oriunde în directorul proiectului (crate) și putem executa comanda:

```bash
cargo run
```


## Exerciții

:::tip 
Dacă nu ai instalat Rust, poți folosi [Rust Playground](https://play.rust-lang.org/) pentru a rezolva exercițiile. 
:::

:::info
Înainte de a începe exercițiile, parcurge capitolele [1](https://tourofrust.com/chapter_1_en.html), [2](https://tourofrust.com/chapter_2_en.html) și [3](https://tourofrust.com/chapter_3_en.html) din tutorialele [Tour of Rust](https://tourofrust.com/).
:::

1. Scrie o funcție care primește numele tău ca parametru și te salută în `stdout` (afișează pe ecran). Ce tip ar trebui să aibă parametrul și de ce? (**1p**)
2. Scrie o funcție care primește un număr întreg fără semn `N` și afișează primele `N` numere impare (**1p**).
3. Scrie o funcție care returnează primul număr par dintr-un *slice* de array. Asigură-te că tratezi cazul în care nu există niciun număr par. (**1p**)  
   *Indicație:* un slice este o parte a unui array, `&a[first..end]`. Aruncă o privire la [`for`](#for) și [`Option`](#option-enum). Ține minte că `for` oferă o referință către fiecare element din listă.
4. Scrie o funcție care caută într-un vector de string‑uri și returnează primul element care are mai mult de 4 caractere (**1p**).  
   *Indicație:* vezi [`for`](#for), [`Option`](#option-enum) și funcțiile [`from()`, `len()` și `to_string()`](#string).
5. Definește un vector de tranzacții care pot fi în Ron, Dolari, Euro, Lire sau Bitcoin. Creează o funcție care calculează valoarea totală în Ron a vectorului.  
   (presupune: Ron = 1, Dolar = 4.5, Euro = 5, Liră = 6, Bitcoin = 100000) (**2p**)  
   *Indicație:* vezi [`enum`](#enums) și [`structuri`](#structures).
6. Scrie o funcție care transformă un *string slice* `&str` într-un număr întreg fără semn, returnând fie valoarea, fie un cod de eroare. Creează un tip de eroare care gestionează cazurile: *șirul este gol*, *șirul conține un caracter invalid* (și la ce poziție) și *numărul este negativ*. (**2p**)  
   *Indicație:* vezi [`Option`](#option-enum) și [`Result`](#result-enum).
7. Definește o structură `Complex` cu numere reale de tip `float`. (**2p**)  
   a. Implementează o funcție statică `new` pentru această structură.  
   b. Implementează 2 operații posibile pentru ea (inclusiv valoarea absolută și înmulțirea).  
   c. Implementează o metodă `display` care afișează numărul.


## Ownership (Deținerea memoriei)

Ownership este un set de reguli care guvernează modul în care un program Rust gestionează memoria. Toate programele trebuie să gestioneze memoria calculatorului în timpul execuției.

Unele limbaje au **garbage collection**, care caută periodic memoria nefolosită. În alte limbaje, programatorul trebuie să aloce și să elibereze memoria manual.

Rust folosește o a treia abordare: memoria este gestionată printr-un **sistem de proprietate (ownership)**, bazat pe un set de **reguli** verificate de compilator. Dacă una dintre reguli este încălcată, programul nu se va compila. Aceste reguli nu încetinesc execuția programului.

### Reguli de ownership
1. Fiecare valoare în Rust are un **proprietar**.
2. O valoare nu poate avea mai mult de un **proprietar** simultan.
3. Când proprietarul iese din *scope*, valoarea este eliberată (dropped).

### Scope
Un **scope** este zona de cod în care un element este valid.

Exemplu pentru înțelegere:

```rust
{
    // aici s este invalid
    let s = "hello";   // s devine valid de aici
} // după acest punct, valoarea s este eliberată
```

### Ownership în funcții

Mecanismul prin care se transmit valori către o funcție este similar cu atribuirea unei valori unei variabile.  
Transmiterea unei variabile către o funcție va realiza o **mutare (move)** sau o **copiere (copy)**, la fel ca o atribuire.

Exemplu (citește comentariile):

```rust
fn main() {
    let s = String::from("hello");  // s intră în scope

    takes_ownership(s);             // valoarea lui s este mutată în funcție...
                                    // ... deci nu mai este validă aici

    let x = 5;                      // x intră în scope

    makes_copy(x);                  // o copie a lui x este transmisă funcției,
                                    // dar i32 are trăsătura Copy, deci putem
                                    // folosi x și după aceea

} // aici x iese din scope, apoi s. Dar cum s a fost mutat, nu se eliberează nimic.

fn takes_ownership(some_string: String) { // some_string intră în scope
    println!("{}", some_string);
} // aici some_string iese din scope și `drop` este apelat. Memoria este eliberată.

fn makes_copy(some_integer: i32) { // some_integer intră în scope
    println!("{}", some_integer);
} // aici some_integer iese din scope. Nu se întâmplă nimic special.
```

Dacă am încerca să folosim `s` după apelul `take_ownership`, Rust ar returna o eroare de compilare. Aceste verificări statice ne protejează de erori.

### Valori returnate și scope

Valorile returnate pot, de asemenea, transfera ownership-ul.

Proprietatea unei variabile urmează același tipar: atribuirea unei valori unei alte variabile o mută.  
Când o variabilă care conține date pe heap iese din scope, valoarea este eliberată prin `drop`, dacă proprietatea nu a fost transferată.

Exemplu:

```rust
fn main() {
    let s1 = gives_ownership();         // gives_ownership mută valoarea returnată în s1

    let s2 = String::from("hello");     // s2 intră în scope

    let s3 = takes_and_gives_back(s2);  // s2 este mutat în funcție,
                                        // care returnează o valoare mutată în s3
} // aici s3 iese din scope și este eliberat. s2 a fost mutat, deci nimic nu se întâmplă. s1 este eliberat.

fn gives_ownership() -> String {        // mută valoarea returnată către apelant
    let some_string = String::from("yours");
    some_string // se returnează, mutând proprietatea
}

fn takes_and_gives_back(a_string: String) -> String {
    a_string // se returnează și mută valoarea către apelant
}
```

### Referințe și împrumuturi (Borrowing)

O **referință** este similară cu un pointer — este o adresă care permite accesul la datele stocate acolo, dar datele aparțin altei variabile.  
Spre deosebire de pointere, o referință este garantată să indice către o valoare validă de un anumit tip pe durata vieții sale.

Simbolul `&` marchează o referință, fie înaintea numelui unei variabile, fie în tipul unui parametru. Acesta permite referirea unei valori fără a-i lua proprietatea.

```rust
let x: u16 = 10;
let y = &x;
```

Exemplu de funcție care primește o referință la un obiect în loc să preia proprietatea asupra lui:

```rust
fn main() {
    let s1 = String::from("hello");
    let len = calculate_length(&s1);
    println!("The length of '{}' is {}.", s1, len);
}

fn calculate_length(s: &String) -> usize { // s este o referință la un String
    s.len()
} // aici s iese din scope, dar nu deține valoarea, deci nu este eliberată
```

Sintaxa `&s1` creează o referință către valoarea lui `s1`, fără a o muta. Astfel, `s1` rămâne validă și după apel.  
În semnătura funcției, `&String` indică faptul că parametrul este o referință.

Acțiunea de a crea o referință se numește **împrumut (borrowing)**. Așa cum în viața reală împrumuți ceva fără a deveni proprietar, la final trebuie să returnezi acel obiect.  
Referința nu este proprietar — doar folosește temporar valoarea.

La fel ca variabilele, referințele sunt **imutabile** implicit. Nu putem modifica valoarea către care indică o referință imutabilă.

### Referințe mutabile

Dacă vrem să modificăm valoarea unei referințe, trebuie să spunem explicit compilatorului acest lucru, folosind cuvântul cheie `mut`.  
Referințele mutabile au o restricție importantă: dacă există o referință mutabilă către o valoare, nu pot exista alte referințe către aceeași valoare.

De asemenea, nu putem avea o referință mutabilă în timp ce există o referință imutabilă la aceeași valoare.

```rust
fn main() {
    let mut s = String::from("hello");
    change(&mut s);
}

fn change(some_string: &mut String) {
    some_string.push_str(", world");
}
```

:::warning
Reguli pentru referințe:
1. În orice moment, poți avea fie o singură referință mutabilă, fie oricâte referințe imutabile — dar nu ambele simultan.
2. Referințele trebuie să fie întotdeauna **valide**.
:::


## Trăsătura `Copy`

Să luăm un exemplu similar cu cel de mai devreme:

```rust
let mut x: i32 = 0;
let mut y = x;
y = 5;
println!("{x}"); // Afișează 0
```

De data aceasta, compilatorul nu a mutat variabila `x` în `y`. De ce?  
Pentru că `i32` implementează trăsătura [`Copy`](https://doc.rust-lang.org/core/marker/trait.Copy.html).  
Aceasta este o trăsătură folosită pentru tipurile care pot fi copiate eficient bit‑cu‑bit și care nu permit existența a două referințe mutabile către aceeași locație de memorie.

| Tip | Implementează `Copy` | Motiv |
|-----|---------------------|--------|
| `i32` | Da | |
| `f64` | Da | |
| `bool` | Da | |
| `String` | Nu | Conține un pointer către un buffer intern. Bufferul ar trebui duplicat la copiere, lucru pe care o copiere bit‑cu‑bit nu îl poate face. |
| `Vec<_>` | Nu | La fel ca `String`, deține un buffer intern care ar trebui duplicat. |
| `&str` | Da | |
| `&mut str` | Nu | Copierea ar crea o altă referință mutabilă către aceeași valoare. |

Poți implementa trăsătura `Copy` pentru propriile structuri și enumuri folosind:

```rust
#[derive(Clone, Copy)]
```

:::warning
Trebuie să implementezi și trăsătura `Clone` pentru a putea deriva `Copy`.  
De asemenea, toate câmpurile structurii trebuie să aibă tipuri care implementează `Copy`.
:::

## Bonus pentru acasă

1. Rescrie funcția de la exercițiul 2, dar de data aceasta implementeaz-o folosind [Sita lui Eratostene](https://www.geeksforgeeks.org/sieve-of-eratosthenes/).
2. Definește o structură numită `MiniTuring`, cu un buffer de 256 valori booleene și un cursor.  
   - Scrie o funcție statică `new` care creează o instanță a structurii.  
   - Scrie o metodă `display` care afișează banda cu 1 și 0 în loc de `true` și `false`, fără spații sau newline‑uri.  
   - Citește de la tastatură până când se primește „h”. „l” mută cursorul la stânga (cu revenire circulară), „r” la dreapta, „1” setează valoarea la `true`, „0” la `false`, „p” afișează valoarea curentă, „h” afișează întreaga bandă.
3. Creează un parser de expresii aritmetice simple cu numere întregi care acceptă `+`, `-`, `*`, `/`. Presupune că nu există operator unar (ex: `5*-3`, `-2+7`).  
   - Definește un `enum` numit `Expression` cu variante potrivite (indicație: folosește [`Box`](https://doc.rust-lang.org/alloc/boxed/struct.Box.html)).  
   - Creează o funcție care returnează un `Expression` pe baza unui șir dat, respectând regulile de prioritate ale operatorilor.  
   - Creează o funcție care primește un `Expression` și îl evaluează într-un `i32`.  
   - Citește o expresie de la stdin și afișează rezultatul.
