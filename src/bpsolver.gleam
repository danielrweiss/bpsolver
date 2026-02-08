import core/cipher
import core/core
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

fn nums() -> Dict(String, Int) {
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

  let cores =
    num_array
    |> solve_cores

  cores
  |> core.print_cores

  let letters = invert_dict(nums())
  cores
  |> core.cores_to_words(letters)
  |> list.each(io.println)
}

fn invert_dict(dict: Dict(String, Int)) -> Dict(Int, String) {
  dict
  |> dict.to_list
  |> list.map(fn(pair) { #(pair.1, pair.0) })
  |> dict.from_list
}

fn print_board(array: List(List(List(Int)))) -> Nil {
  array
  |> format_board
  |> join_rows
  |> string.join("\n")
  |> io.println

  io.println("")
}

fn format_board(array: List(List(List(Int)))) -> List(List(String)) {
  use row <- list.map(array)
  row |> format_row
}

fn join_rows(rows: List(List(String))) -> List(String) {
  use row <- list.map(rows)
  row |> string.join("  | ")
}

fn format_row(row: List(List(Int))) -> List(String) {
  use cell <- list.map(row)
  cell |> format_cell
}

fn format_cell(cell: List(Int)) -> String {
  cell |> list.map(numstr) |> string.join(" ")
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

fn solve_cores(array: List(List(List(Int)))) -> List(List(cipher.Cipher)) {
  use row <- list.map(array)
  use cell <- list.map(row)
  cell |> find_core
}

fn find_core(nums: List(Int)) -> cipher.Cipher {
  core.find_core(nums)
}
