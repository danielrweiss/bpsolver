import core/core
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

const operators: List(core.Operator) = [
  core.Subtract,
  core.Multiply,
  core.Divide,
]

const nums: List(Int) = [15, 20, 25, 10]

// gleeunit test functions end in `_test`
pub fn apply_operator_test() {
  let num = core.apply_operator(core.Add, 10, 20)
  assert Ok(30) == num
  let num = core.apply_operator(core.Subtract, 10, 20)
  assert Ok(-10) == num
  let num = core.apply_operator(core.Multiply, 10, 20)
  assert Ok(200) == num
  let num = core.apply_operator(core.Divide, 10, 20)
  assert Ok(5) == num
}
