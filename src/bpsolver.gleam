import core/core.{type Cipher}
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

  let cores =
    num_array
    |> solve_cores

  cores
  |> print_cores

  cores
  |> cores_to_words
  |> list.each(io.println)
}

fn invert_dict(dict: Dict(String, Int)) -> Dict(Int, String) {
  dict
  |> dict.to_list
  |> list.map(fn(pair) { #(pair.1, pair.0) })
  |> dict.from_list
}

fn cores_to_words(cores: List(List(Cipher))) -> List(String) {
  let letters = invert_dict(nums())
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

fn print_board(array: List(List(List(Int)))) -> Nil {
  array
  |> list.map(fn(row) {
    row
    |> list.map(fn(cell) {
      cell
      |> list.map(numstr)
      |> string.join(" ")
    })
    |> string.join("  | ")
  })
  |> string.join("\n")
  |> io.println

  io.println("")
}

fn print_cores(array: List(List(Cipher))) -> Nil {
  array
  |> list.map(fn(row) {
    row
    |> list.map(fn(cell) {
      cell
      |> core.cipher_to_string
    })
    |> string.join(" | ")
  })
  |> string.join("\n")
  |> io.println

  io.println("")
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

fn solve_cores(array: List(List(List(Int)))) -> List(List(Cipher)) {
  use row <- list.map(array)
  use cell <- list.map(row)
  cell |> find_core
}

fn find_core(nums: List(Int)) -> core.Cipher {
  core.find_core(nums)
}
