# glanoid

[![Package Version](https://img.shields.io/hexpm/v/glanoid)](https://hex.pm/packages/glanoid)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/glanoid/)

Gleam port of [nanoid](https://github.com/ai/nanoid).

## Installation

```sh
gleam add glanoid
```

## Usage

### Default alphabet

Use the following to generate IDs with the default alphabet (`A-Za-z0-9_-`).

Generate the nanoid function with `glanoid.make_generator(glanoid.default_alphabet)`.  
Then call the function with the desired ID length as an argument.

```gleam
import glanoid
import gleam/io

pub fn main() {
  let assert Ok(nanoid) = glanoid.make_generator(glanoid.default_alphabet)
  nanoid(18)
  |> io.debug() // "bppqBa-4eNFW_yPzib"
}
```

### Custom alphabet

```gleam
import glanoid
import gleam/io

pub fn main() {
  let assert Ok(nanoid) = glanoid.make_generator("lucy")
  nanoid(18)
  |> io.debug() // "lluucyuyulycyucucy"
}
```

### Collision probability
You can use the [ID collision probability calculator](https://zelark.github.io/nano-id-cc/) to check the safety of your ID size and alphabet.
