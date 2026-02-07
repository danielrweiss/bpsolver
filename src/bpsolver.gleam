import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/string

const words: List(List(String)) = [
  ["pigs", "sand", "mail", "date", "head"],
  ["clam", "peak", "sand", "joya", "well"],
  ["toad", "card", "will", "tape", "legs"],
  ["tree", "road", "maid", "slab", "rock"],
  ["hand", "vase", "safe", "clay", "toes"],
]

pub type Operator {
  Add
  Subtract
  Multiply
  Divide
}

const operators: List(Operator) = [Add, Subtract, Multiply, Divide]

pub fn nums() -> Dict(String, Int) {
  dict.from_list([
    #("a", 1),
    #("b", 2),
    #("c", 3),
    #("d", 4),
    #("e", 5),
    #("f", 6),
    #("g", 7),
    #("h", 8),
    #("i", 9),
    #("j", 10),
    #("k", 11),
    #("l", 12),
    #("m", 13),
    #("n", 14),
    #("o", 15),
    #("p", 16),
    #("q", 17),
    #("r", 18),
    #("s", 19),
    #("t", 20),
    #("u", 21),
    #("v", 22),
    #("w", 23),
    #("x", 24),
    #("y", 25),
    #("z", 26),
  ])
}

pub fn main() -> Nil {
  let num_array =
    words
    |> nums_from_words(nums())
  num_array
  |> print_board
}

fn find_cipher(numword: List(Int)) -> #(String, Int) {
  let ops_options =
    operators
    |> list.permutations
}

fn apply(op: Operator, num1: Int, num2: Int) -> Int {
  case op {
    Add -> num1 + num2
    Subtract -> num1 - num2
    Multiply -> num1 * num2
    Divide -> num1 / num2
  }
}

fn print_board(array: List(List(List(Int)))) -> Nil {
  array
  |> list.map(fn(row) {
    row
    |> list.map(fn(cell) {
      cell
      |> list.map(numstr)
      |> string.join(" ")
    })
    |> string.join(" | ")
  })
  |> string.join("\n")
  |> io.println
}

fn numstr(num: Int) -> String {
  case num {
    n if n < 10 -> " " <> int.to_string(n)
    _ -> int.to_string(num)
  }
}

fn nums_from_words(
  set: List(List(String)),
  nums: Dict(String, Int),
) -> List(List(List(Int))) {
  use row <- list.map(set)
  use cell <- list.map(row)
  cell |> word_to_nums(nums)
}

fn word_to_nums(word: String, nums: Dict(String, Int)) -> List(Int) {
  use char <- list.map(word |> string.to_graphemes)
  case dict.get(nums, char) {
    Ok(num) -> num
    Error(_) -> 0
  }
}
