// Diagnostic boundaries for dependent integer-generic arithmetic.
// REQUIRES: swift_feature_LiteralExpressions
// RUN: %target-typecheck-verify-swift -disable-availability-checking -enable-experimental-feature LiteralExpressions

struct Vector<let N: Int, T> {}

func acceptsDependentDivisionDivisor<let n: Int, let m: Int, T>(
  _ value: Vector<n, T>, _ divisor: Vector<m, T>
) -> Vector<(n / m), T> {
  Vector()
}

func acceptsDependentRemainderDivisor<let n: Int, let m: Int, T>(
  _ value: Vector<n, T>, _ divisor: Vector<m, T>
) -> Vector<(n % m), T> {
  Vector()
}

func rejectsDivisionByZero<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n / (3 - 3)), T> { // expected-error {{division by zero}}
  Vector()
}

func rejectsRemainderByZero<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n % (3 - 3)), T> { // expected-error {{division by zero}}
  Vector()
}

func acceptsNestedShift<let n: Int, let m: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n + (m << 1)), T> {
  Vector()
}

// By contrast, a complete concrete subtree continues through the SE-0531
// literal-expression folder before it is combined with the symbolic '+'.
func acceptsConcreteLiteralExpressionSubexpression<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n + (((1 << 5) / 2) - (7 % 3))), T> {
  Vector()
}
