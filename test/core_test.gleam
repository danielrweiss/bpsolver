import core/cipher
import core/core
import core/operator
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

const operators: List(operator.Operator) = [
  operator.Add,
  operator.Subtract,
  operator.Multiply,
  operator.Divide,
]

const nums: List(Int) = [25, 20, 10, 5]

// gleeunit test functions end in `_test`
pub fn find_core_test() {
  let nums: List(Int) = [8, 6, 45, 5]
  let result = core.find_core(nums)
  assert cipher.Cipher(
      "+ - * /",
      [operator.Add, operator.Subtract, operator.Multiply, operator.Divide],
      18,
      True,
    )
    == result
}

pub fn find_core_again_test() {
  let nums: List(Int) = [3, 6, 1, 4]
  let result = core.find_core(nums)
  assert cipher.Cipher(
      "+ * / -",
      [operator.Add, operator.Multiply, operator.Divide, operator.Subtract],
      14,
      True,
    )
    == result
}

pub fn min_cipher_test() {
  let a = cipher.Cipher("a", [operator.Add], 10, True)
  let b = cipher.Cipher("b", [operator.Subtract], 20, True)
  let c = cipher.Cipher("c", [operator.Multiply], 5, True)
  let d = cipher.Cipher("d", [operator.Divide], 2, True)
  let e = cipher.Cipher("e", [operator.Add, operator.Subtract], 10, True)
  let f = cipher.Cipher("f", [operator.Multiply, operator.Divide], 5, True)
  let g = cipher.Cipher("g", [operator.Add, operator.Multiply], 10, True)
  let h = cipher.Cipher("h", [operator.Subtract, operator.Divide], 1, False)
  let min = cipher.min_cipher([a, b, c, d, e, f, g, h])
  assert d == min
}

pub fn minimum_test() {
  let a = cipher.Cipher("a", [operator.Add], 10, True)
  let b = cipher.Cipher("b", [operator.Subtract], 20, True)
  let min = cipher.minimum(a, b)
  assert a == min
}

pub fn minimum_fail_test() {
  let a = cipher.Cipher("a", [operator.Add], 10, True)
  let b = cipher.Cipher("b", [operator.Subtract], 20, False)
  let min = cipher.minimum(a, b)
  assert a == min

  let c = cipher.Cipher("c", [operator.Multiply], 5, False)
  let d = cipher.Cipher("d", [operator.Divide], 10, True)
  let min = cipher.minimum(c, d)
  assert d == min

  let e = cipher.Cipher("e", [operator.Add, operator.Subtract], 10, False)
  let f = cipher.Cipher("f", [operator.Multiply, operator.Divide], 5, False)
  let min = cipher.minimum(e, f)
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
  let num = operator.apply_operator(operator.Add, 10.0, 20.0)
  assert Ok(30.0) == num
  let num = operator.apply_operator(operator.Subtract, 20.0, 10.0)
  assert Ok(10.0) == num
  let num = operator.apply_operator(operator.Multiply, 10.0, 20.0)
  assert Ok(200.0) == num
  let num = operator.apply_operator(operator.Divide, 20.0, 4.0)
  assert Ok(5.0) == num
}

pub fn op_to_string_test() {
  assert "+" == operator.op_to_string(operator.Add)
  assert "-" == operator.op_to_string(operator.Subtract)
  assert "*" == operator.op_to_string(operator.Multiply)
  assert "/" == operator.op_to_string(operator.Divide)
}
