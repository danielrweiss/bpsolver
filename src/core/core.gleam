import core/cipher.{type Cipher}
import core/operator.{type Operator}
import gleam/dict.{type Dict}
import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string

pub fn find_core(numword: List(Int)) -> Cipher {
  let ops_options = operator.get_op_permutations()

  let results =
    ops_options
    |> list.map(fn(ops) {
      let total = operate(ops, numword)
      case total {
        Ok(total) ->
          cipher.Cipher(operator.ops_to_string(ops), ops, total, True)
        Error(_) -> cipher.Cipher("", [], 0, False)
      }
    })
    |> list.filter(fn(cipher) { cipher.valid })

  results
  |> cipher.min_cipher
}

pub fn operate(ops: List(Operator), nums: List(Int)) -> Result(Int, Nil) {
  use total <- result.try(internal_operate(ops, nums, None))
  case total >= 0 {
    True -> Ok(total)
    False -> Error(Nil)
  }
}

fn internal_operate(
  ops: List(Operator),
  nums: List(Int),
  total: Option(Float),
) -> Result(Int, Nil) {
  let total = case total {
    Some(t) -> t
    None -> 0.0
  }
  case ops {
    [op, ..rest_ops] ->
      case nums {
        [num, ..rest_nums] -> {
          use total <- result.try(operator.apply_operator(
            op,
            total,
            int.to_float(num),
          ))
          internal_operate(rest_ops, rest_nums, Some(total))
        }
        [] -> internal_result(total)
      }
    [] -> internal_result(total)
  }
}

fn internal_result(total: Float) -> Result(Int, Nil) {
  let total_int: Int = total |> float.truncate
  case total -. int.to_float(total_int) {
    0.0 -> Ok(total_int)
    _ -> Error(Nil)
  }
}

pub fn print_cores(array: List(List(Cipher))) -> Nil {
  array
  |> list.map(fn(row) {
    row
    |> list.map(fn(cell) {
      cell
      |> cipher.cipher_to_string
    })
    |> string.join(" | ")
  })
  |> string.join("\n")
  |> io.println

  io.println("")
}

pub fn cores_to_words(
  cores: List(List(Cipher)),
  letters: Dict(Int, String),
) -> List(String) {
  use core <- list.map(cores)
  core_to_letters(core, letters)
}

fn core_to_letters(core: List(Cipher), letters: Dict(Int, String)) -> String {
  core
  |> list.map(fn(cipher) {
    case dict.get(letters, cipher.total) {
      Ok(letter) -> string.uppercase(letter)
      Error(_) -> "?"
    }
  })
  |> string.join("")
}
