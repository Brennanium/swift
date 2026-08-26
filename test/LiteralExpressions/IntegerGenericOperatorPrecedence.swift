// REQUIRES: swift_feature_LiteralExpressions
// RUN: %target-typecheck-verify-swift -disable-availability-checking -enable-experimental-feature LiteralExpressions

struct Vector<let N: Int, T> {}

precedencegroup LocalAdditionPrecedence {
  associativity: left
  higherThan: MultiplicationPrecedence
}
infix operator +: LocalAdditionPrecedence

// A SE-0531 literal expression must not fold according to a locally altered
// precedence group. The expression would otherwise be parsed as `(2 + 2) * 3`.
func rejectsAlteredPrecedenceForLiteral() -> Vector<(2 + 2 * 3), Int> { // expected-error {{operator '+' in an integer generic argument cannot use locally altered precedence or associativity}}
  Vector()
}

// The same rule applies to dependent arithmetic expressions, whose tree is
// retained in the generic signature.
func rejectsAlteredPrecedenceForDependent<let n: Int, let m: Int, let p: Int>(
  _ value: Vector<n, Int>
) -> Vector<(n + m * p), Int> { // expected-error {{operator '+' in an integer generic argument cannot use locally altered precedence or associativity}}
  Vector()
}
