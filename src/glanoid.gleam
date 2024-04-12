import gleam/bool
import gleam/crypto
import gleam/int
import gleam/string

pub const default_alphabet = "useandom-26T198340PX75pxJACKVERYMINDBUSHWOLF_GQZbfghjklqvwyzrict"

fn fix4(f) {
  fn(a, b, c, d) { f(fix4(f), a, b, c, d) }
}

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
  use <- bool.guard(string.length(alphabet) == 0, Error(Nil))

  let bit_mask =
    alphabet
    |> string.length()
    |> int.subtract(1)
    |> bit_size()
    |> int.bitwise_shift_left(2, _)
    |> int.subtract(1)

  let to_alphabet =
    fix4(fn(to_alphabet, bits, size, alphabet, acc) {
      case string.length(acc) == size, bits {
        True, _ -> acc
        False, <<x:8, rest:bits>> -> {
          let index = int.bitwise_and(x, bit_mask)
          let letter = string.slice(alphabet, index, 1)
          case letter {
            "" -> to_alphabet(rest, size, alphabet, acc)
            _ -> to_alphabet(rest, size, alphabet, acc <> letter)
          }
        }
        False, <<>> ->
          to_alphabet(crypto.strong_random_bytes(size * 2), size, alphabet, acc)
        _, _ -> panic
      }
    })

  Ok(fn(size) {
    crypto.strong_random_bytes(size * 2)
    |> to_alphabet(size, alphabet, "")
  })
}
