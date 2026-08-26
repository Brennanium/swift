// Generic-signature behavior for structurally identified dependent arithmetic.
// REQUIRES: swift_feature_LiteralExpressions
// RUN: %target-typecheck-verify-swift -disable-availability-checking -enable-experimental-feature LiteralExpressions

struct Vector<let N: Int, T> {}

// A wholly concrete SE-0531 literal-expression subtree folds before
// structural comparison.
func equivalentFoldedLiteralRequirement<let n: Int, T>(
  _ value: Vector<(n + (2 + 3)), T>
) where Vector<(n + 5), T> == Vector<(n + (2 + 3)), T> { // expected-warning {{same-type requirement is redundant; both sides are already equivalent}}
  _ = value
}

// A wholly concrete subtraction subtree also folds before structural
// comparison, but subtraction outside that subtree remains ordered.
func equivalentFoldedSubtractionRequirement<let n: Int, T>(
  _ value: Vector<(n - (7 - 2)), T>
) where Vector<(n - 5), T> == Vector<(n - (7 - 2)), T> { // expected-warning {{same-type requirement is redundant; both sides are already equivalent}}
  _ = value
}

func equivalentFoldedDivisionRequirement<let n: Int, T>(
  _ value: Vector<(n / (4 / 2)), T>
) where Vector<(n / 2), T> == Vector<(n / (4 / 2)), T> { // expected-warning {{same-type requirement is redundant; both sides are already equivalent}}
  _ = value
}

func equivalentFoldedBitwiseRequirement<let n: Int, T>(
  _ value: Vector<(n & (15 ^ 3)), T>
) where Vector<(n & 12), T> == Vector<(n & (15 ^ 3)), T> { // expected-warning {{same-type requirement is redundant; both sides are already equivalent}}
  _ = value
}

func equivalentFoldedUnaryNegateRequirement<let n: Int, T>(
  _ value: Vector<(n + -((3 - 5))), T>
) where Vector<(n + 2), T> == Vector<(n + -((3 - 5))), T> { // expected-warning {{same-type requirement is redundant; both sides are already equivalent}}
  _ = value
}

// Prefix unary syntax must retain the redundant-requirement warning even
// though a SE-0531 literal expression folds the concrete expression to an
// integer literal.
func equivalentFoldedUnaryPlusRequirement<T>(
  _ value: Vector<3, T>
) where Vector<(+3), T> == Vector<3, T> { // expected-warning {{same-type requirement is redundant; both sides are already equivalent}}
  _ = value
}

func rejectsUnaryPlusAsIdentity<let n: Int, T>(
  _ value: Vector<(+n), T>
) where Vector<(+n), T> == Vector<n, T> { // expected-error {{cannot constrain value parameter 'n' to be type '+n'}} expected-note {{arithmetic generic arguments are equal only when their expression trees have the same operator and ordered operands}}
  _ = value
}

func rejectsNegationAsWrappingMultiplication<let n: Int, T>(
  _ value: Vector<(-n), T>
) where Vector<(-n), T> == Vector<(n &* -1), T> { // expected-error {{generic signature requires types '-n' and 'n &* -1' to be the same}} expected-note {{arithmetic generic arguments are equal only when their expression trees have the same operator and ordered operands}}
  _ = value
}

func nonArithmeticRequirement<T>(
  _ value: T
) where T == T {
  _ = value
}

// Dependent operations are neither reordered nor simplified.
func rejectsCommutedSumRequirement<let n: Int, let m: Int, T>(
  _ value: Vector<n, T>, _ other: Vector<m, T>
) where Vector<(m + n), T> == Vector<(n + m), T> { // expected-error {{generic signature requires types 'm + n' and 'n + m' to be the same}} expected-note {{arithmetic generic arguments are equal only when their expression trees have the same operator and ordered operands}}
  _ = (value, other)
}

func rejectsCommutedDifferenceRequirement<let n: Int, let m: Int, T>(
  _ value: Vector<(n - m), T>, _ other: Vector<(m - n), T>
) where Vector<(n - m), T> == Vector<(m - n), T> { // expected-error {{generic signature requires types 'n - m' and 'm - n' to be the same}} expected-note {{arithmetic generic arguments are equal only when their expression trees have the same operator and ordered operands}}
  _ = (value, other)
}

func rejectsDifferentDivisionRequirement<let n: Int, T>(
  _ value: Vector<(n / 2), T>
) where Vector<(n / 2), T> == Vector<(n / 3), T> { // expected-error {{generic signature requires types 'n / 2' and 'n / 3' to be the same}} expected-note {{arithmetic generic arguments are equal only when their expression trees have the same operator and ordered operands}}
  _ = value
}

func rejectsCommutedBitwiseAndRequirement<let n: Int, let m: Int, T>(
  _ value: Vector<(n & m), T>, _ other: Vector<(m & n), T>
) where Vector<(n & m), T> == Vector<(m & n), T> { // expected-error {{generic signature requires types 'n & m' and 'm & n' to be the same}} expected-note {{arithmetic generic arguments are equal only when their expression trees have the same operator and ordered operands}}
  _ = (value, other)
}

func rejectsReassociatedProductRequirement<let n: Int, let m: Int, let p: Int, T>(
  _ value: Vector<((n * m) * p), T>
) where Vector<((n * m) * p), T> == Vector<(n * (m * p)), T> { // expected-error {{generic signature requires types 'n * m * p' and 'n * (m * p)' to be the same}} expected-note {{arithmetic generic arguments are equal only when their expression trees have the same operator and ordered operands}}
  _ = value
}

func rejectsAdjacentSubtractionFolding<let n: Int, T>(
  _ value: Vector<((n - 7) - 2), T>
) where Vector<((n - 7) - 2), T> == Vector<(n - 9), T> { // expected-error {{generic signature requires types 'n - 7 - 2' and 'n - 9' to be the same}} expected-note {{arithmetic generic arguments are equal only when their expression trees have the same operator and ordered operands}}
  _ = value
}

func rejectsIdentityRequirement<let n: Int, T>(
  _ value: Vector<n, T>
) where Vector<(n * 0), T> == Vector<0, T> { // expected-error {{cannot constrain type parameter 'n * 0' to be integer '0'}}
  _ = value
}

// Structural equality does not solve a value equation by binding `k` to an
// arithmetic expression.
func rejectsArithmeticBinding<let n: Int, let m: Int, let k: Int, T>(
  _ lhs: Vector<n, T>, _ rhs: Vector<m, T>, _ result: Vector<k, T>
) where Vector<(n + m), T> == Vector<k, T> { // expected-error {{cannot constrain value parameter 'k' to be type 'n + m'}} expected-note {{arithmetic generic arguments are equal only when their expression trees have the same operator and ordered operands}}
  _ = (lhs, rhs, result)
}
