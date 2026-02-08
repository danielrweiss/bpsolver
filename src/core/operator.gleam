import gleam/float
import gleam/list
import gleam/string

pub type Operator {
  Add
  Subtract
  Multiply
  Divide
}

// Always start with + as the first operator before the first number
const operators: List(Operator) = [Subtract, Multiply, Divide]

pub fn get_op_permutations() -> List(List(Operator)) {
  operators
  |> list.permutations
  |> list.map(fn(ops) { [Add, ..ops] })
}

/// Performs the operation on two numbers and returns fail if division is not an integer
pub fn apply_operator(
  op: Operator,
  num1: Float,
  num2: Float,
) -> Result(Float, Nil) {
  case op {
    Add -> Ok(num1 +. num2)
    Subtract -> Ok(num1 -. num2)
    Multiply -> Ok(num1 *. num2)
    Divide -> float.divide(num1, num2)
  }
}

pub fn ops_to_string(ops: List(Operator)) -> String {
  ops
  |> list.map(op_to_string)
  |> string.join(" ")
}

pub fn op_to_string(op: Operator) -> String {
  case op {
    Add -> "+"
    Subtract -> "-"
    Multiply -> "*"
    Divide -> "/"
  }
}
