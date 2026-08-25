// A user-defined operator must not be selected for a dependent integer-generic
// arithmetic expression.
// REQUIRES: swift_feature_LiteralExpressions
// RUN: %target-typecheck-verify-swift -disable-availability-checking -enable-experimental-feature LiteralExpressions

struct Vector<let N: Int, T> {}

func +(lhs: Int, rhs: Int) -> Int { 42 }

func rejectsCustomAddition<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n + 1), T> { // expected-error {{operator '+' is not supported in dependent generic value expressions}}
  Vector()
}
