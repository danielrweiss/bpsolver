import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string

pub type Operator {
  Add
  Subtract
  Multiply
  Divide
}

pub type Cipher {
  Cipher(equation: String, operators: List(Operator), total: Int, valid: Bool)
}

pub fn ops_to_string(ops: List(Operator)) -> String {
  ops
  |> list.map(op_to_string)
  |> string.join(" ")
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

// Always start with + as the first operator before the first number
const operators: List(Operator) = [Subtract, Multiply, Divide]

pub fn find_core(numword: List(Int)) -> Cipher {
  let ops_options =
    operators
    |> list.permutations
    |> list.map(fn(ops) { [Add, ..ops] })

  let results =
    ops_options
    |> list.map(fn(ops) {
      let total = operate(ops, numword, None)
      case total {
        Ok(total) -> Cipher(ops_to_string(ops), ops, total, True)
        Error(_) -> Cipher("", [], 0, False)
      }
    })
    |> list.filter(fn(cipher) { cipher.valid })

  results
  |> min_cipher
}

pub fn min_cipher(ciphers: List(Cipher)) -> Cipher {
  list.fold(over: ciphers, from: Cipher("", [], 0, False), with: minimum)
}

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

pub fn operate(
  ops: List(Operator),
  nums: List(Int),
  total: Option(Int),
) -> Result(Int, Nil) {
  use total <- result.try(internal_operate(ops, nums, total))
  case total >= 0 {
    True -> Ok(total)
    False -> Error(Nil)
  }
}

fn internal_operate(
  ops: List(Operator),
  nums: List(Int),
  total: Option(Int),
) -> Result(Int, Nil) {
  let total = case total {
    Some(t) -> t
    None -> 0
  }
  case ops {
    [op, ..rest_ops] ->
      case nums {
        [num, ..rest_nums] -> {
          use total <- result.try(apply_operator(op, total, num))
          internal_operate(rest_ops, rest_nums, Some(total))
        }
        [] -> Ok(total)
      }
    [] -> Ok(total)
  }
}

/// Performs the operation on two numbers and returns fail if division is not an integer
pub fn apply_operator(op: Operator, num1: Int, num2: Int) -> Result(Int, Nil) {
  case op {
    Add -> Ok(num1 + num2)
    Subtract -> Ok(num1 - num2)
    Multiply -> Ok(num1 * num2)
    Divide ->
      case num1 % num2 {
        0 -> Ok(num1 / num2)
        _ -> Error(Nil)
      }
  }
}

pub fn op_to_string(op: Operator) -> String {
  case op {
    Add -> "+"
    Subtract -> "-"
    Multiply -> "*"
    Divide -> "/"
  }
}
