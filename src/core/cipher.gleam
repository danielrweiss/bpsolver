import core/operator.{type Operator}
import gleam/int
import gleam/list

/// Representation of the order of the 4 operators and the numeric total
/// Property valid tracks failures in calculation like non-whole number result or invalid division
pub type Cipher {
  Cipher(equation: String, operators: List(Operator), total: Int, valid: Bool)
}

/// Finds the valid cipher with the minimum total in a list of possible ciphers
pub fn min_cipher(ciphers: List(Cipher)) -> Cipher {
  list.fold(over: ciphers, from: Cipher("", [], 0, False), with: minimum)
}

/// Pattern match on valid to return minimum valid cipher or a default is neither are valid
pub fn minimum(a: Cipher, b: Cipher) -> Cipher {
  case a.valid, b.valid {
    True, True ->
      case a.total < b.total {
        True -> a
        False -> b
      }
    True, False -> a
    False, True -> b
    False, False -> Cipher("", [], 0, False)
  }
}

pub fn cipher_to_string(cipher: Cipher) -> String {
  cipher.equation <> " = " <> numstr(cipher.total)
}

fn numstr(num: Int) -> String {
  case num {
    n if n < 10 -> " " <> int.to_string(n)
    _ -> int.to_string(num)
  }
}
