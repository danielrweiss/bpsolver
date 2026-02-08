import gleam/list
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

// Always start with + as the first operator before the first number
const operators: List(Operator) = [Subtract, Multiply, Divide]

pub fn find_core(numword: List(Int)) -> Cipher {
  let ops_options =
    operators
    |> list.permutations

  let results =
    ops_options
    |> list.map(fn(ops) {
      let total = operate(ops, numword, 0)
      case total {
        Ok(total) -> Cipher(ops_to_string(ops), ops, total, True)
        Error(_) -> Cipher("", [], 0, False)
      }
    })
    |> list.filter(fn(cipher) { cipher.valid })

  results
  |> min_cipher
}

fn min_cipher(ciphers: List(Cipher)) -> Cipher {
  list.fold(over: ciphers, from: Cipher("", [], 0, False), with: minimum)
}

fn minimum(a: Cipher, b: Cipher) -> Cipher {
  case a.total < b.total {
    True -> a
    False -> b
  }
}

fn operate(ops: List(Operator), nums: List(Int), total: Int) -> Result(Int, Nil) {
  case ops {
    [op, ..rest_ops] ->
      case nums {
        [num, next_num, ..rest_nums] -> {
          use next_total <- result.try(apply_operator(op, num, next_num))
          operate(rest_ops, rest_nums, total + next_total)
        }
        [] -> Ok(total)
        [_] -> Error(Nil)
      }
    [] -> Ok(total)
  }
}

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

fn op_to_string(op: Operator) -> String {
  case op {
    Add -> "+"
    Subtract -> "-"
    Multiply -> "*"
    Divide -> "/"
  }
}
