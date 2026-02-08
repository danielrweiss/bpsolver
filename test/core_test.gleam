import core/core
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

const operators: List(core.Operator) = [
  core.Add,
  core.Subtract,
  core.Multiply,
  core.Divide,
]

const nums: List(Int) = [25, 20, 10, 5]

// gleeunit test functions end in `_test`
pub fn find_core_test() {
  let nums: List(Int) = [8, 6, 45, 5]
  let result = core.find_core(nums)
  assert core.Cipher(
      "+ - * /",
      [core.Add, core.Subtract, core.Multiply, core.Divide],
      18,
      True,
    )
    == result
}

pub fn find_core_again_test() {
  let nums: List(Int) = [3, 6, 1, 4]
  let result = core.find_core(nums)
  assert core.Cipher(
      "+ * / -",
      [core.Add, core.Multiply, core.Divide, core.Subtract],
      14,
      True,
    )
    == result
}

pub fn min_cipher_test() {
  let a = core.Cipher("a", [core.Add], 10, True)
  let b = core.Cipher("b", [core.Subtract], 20, True)
  let c = core.Cipher("c", [core.Multiply], 5, True)
  let d = core.Cipher("d", [core.Divide], 2, True)
  let e = core.Cipher("e", [core.Add, core.Subtract], 10, True)
  let f = core.Cipher("f", [core.Multiply, core.Divide], 5, True)
  let g = core.Cipher("g", [core.Add, core.Multiply], 10, True)
  let h = core.Cipher("h", [core.Subtract, core.Divide], 1, False)
  let min = core.min_cipher([a, b, c, d, e, f, g, h])
  assert d == min
}

pub fn minimum_test() {
  let a = core.Cipher("a", [core.Add], 10, True)
  let b = core.Cipher("b", [core.Subtract], 20, True)
  let min = core.minimum(a, b)
  assert a == min
}

pub fn minimum_fail_test() {
  let a = core.Cipher("a", [core.Add], 10, True)
  let b = core.Cipher("b", [core.Subtract], 20, False)
  let min = core.minimum(a, b)
  assert a == min

  let c = core.Cipher("c", [core.Multiply], 5, False)
  let d = core.Cipher("d", [core.Divide], 10, True)
  let min = core.minimum(c, d)
  assert d == min

  let e = core.Cipher("e", [core.Add, core.Subtract], 10, False)
  let f = core.Cipher("f", [core.Multiply, core.Divide], 5, False)
  let min = core.minimum(e, f)
  assert !min.valid && min.total == 0
}

pub fn operate_test() {
  let result = core.operate(operators, nums)
  assert Ok(10) == result
}

pub fn operate_fail_test() {
  let non_int_nums: List(Int) = [25, 20, 10, 4]
  let result = core.operate(operators, non_int_nums)
  assert Error(Nil) == result
}

pub fn apply_operator_test() {
  let num = core.apply_operator(core.Add, 10.0, 20.0)
  assert Ok(30.0) == num
  let num = core.apply_operator(core.Subtract, 20.0, 10.0)
  assert Ok(10.0) == num
  let num = core.apply_operator(core.Multiply, 10.0, 20.0)
  assert Ok(200.0) == num
  let num = core.apply_operator(core.Divide, 20.0, 4.0)
  assert Ok(5.0) == num
}

pub fn op_to_string_test() {
  assert "+" == core.op_to_string(core.Add)
  assert "-" == core.op_to_string(core.Subtract)
  assert "*" == core.op_to_string(core.Multiply)
  assert "/" == core.op_to_string(core.Divide)
}
