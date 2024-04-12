import funtil
import gleam/crypto
import gleam/int
import gleam/string

pub const default_alphabet = "useandom-26T198340PX75pxJACKVERYMINDBUSHWOLF_GQZbfghjklqvwyzrict"

fn do_bit_size(n, acc) {
  case n {
    0 -> acc
    _ -> do_bit_size(int.bitwise_shift_right(n, 1), acc + 1)
  }
}

fn bit_size(n) {
  do_bit_size(n, 0)
}

pub fn make_generator(alphabet) {
  let bit_mask =
    alphabet
    |> string.length()
    |> bit_size()
    |> int.subtract(1)
    |> int.bitwise_shift_left(1, _)
    |> int.subtract(1)

  let to_alphabet =
    funtil.fix3(fn(to_alphabet, bits, alphabet, acc) {
      case bits {
        <<x:8, rest:bits>> -> {
          let index = int.bitwise_and(x, bit_mask)
          let letter = string.slice(alphabet, index, 1)
          case letter {
            "" -> to_alphabet(bits, alphabet, acc)
            _ -> to_alphabet(rest, alphabet, acc <> letter)
          }
        }
        <<>> -> {
          acc
        }
        _ -> panic
      }
    })

  fn(size) {
    crypto.strong_random_bytes(size)
    |> to_alphabet(alphabet, "")
  }
}
