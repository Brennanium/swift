// Diagnostic behavior for SE-0531 literal-expression constant references
// within dependent integer-generic arithmetic.
// REQUIRES: swift_feature_LiteralExpressions
// RUN: %target-typecheck-verify-swift -package-name LiteralExpressionsTest -disable-availability-checking -enable-experimental-feature LiteralExpressions

struct Vector<let N: Int, T> {} // expected-note {{arguments to generic parameter 'N' ('5' and 'n + 1') are expected to be equal}}

private let privateConstant = 2
internal let internalConstant = 3
package let packageConstant = 4
public let publicConstant = 5
@usableFromInline internal let usableFromInlineConstant = 7
var mutableConstant = 11

public enum PublicDimensions {
  public static let scale = 13
}

func runtimeInteger() -> Int { 17 }
private let nonFoldableConstant = runtimeInteger() // expected-error {{not supported in a literal expression}}

class Overridable {
  class var shared: Int { 4 }
}

struct Replaceable {
  dynamic static let value = 19
}

// =============================================================================
// Accepted references in SE-0531 literal expressions fold before the symbolic
// expression is formed.
// =============================================================================

func acceptsPrivateConstant<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n + privateConstant), T> {
  Vector()
}

func acceptsInternalConstant<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n + internalConstant), T> {
  Vector()
}

// =============================================================================
// Rejected references retain the SE-0531 literal-expression diagnostic and
// generic-argument follow-up, rather than becoming an unsupported symbolic
// operand.
// =============================================================================

func rejectsPackageConstant<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n + packageConstant), T> { // expected-error {{generic value must be an integer literal expression}}
  // expected-error@-1 {{reference to a package 'let' binding is not permitted in a literal expression}}
  Vector()
}

func rejectsPublicConstant<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n + publicConstant), T> { // expected-error {{generic value must be an integer literal expression}}
  // expected-error@-1 {{reference to a public 'let' binding is not permitted in a literal expression}}
  Vector()
}

func rejectsUsableFromInlineConstant<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n + usableFromInlineConstant), T> { // expected-error {{generic value must be an integer literal expression}}
  // expected-error@-1 {{reference to a '@usableFromInline' 'let' binding is not permitted in a literal expression}}
  Vector()
}

func rejectsMutableConstant<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n + mutableConstant), T> { // expected-error {{generic value must be an integer literal expression}}
  // expected-error@-1 {{not supported in a literal expression}}
  Vector()
}

func rejectsPublicStaticConstant<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n + PublicDimensions.scale), T> { // expected-error {{generic value must be an integer literal expression}}
  // expected-error@-1 {{reference to a public 'let' binding is not permitted in a literal expression}}
  Vector()
}

func rejectsNonFoldableConstant<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n + nonFoldableConstant), T> { // expected-error {{generic value must be an integer literal expression}}
  // expected-note@-1 {{requested from reference in a literal expression}}
  Vector()
}

func rejectsOverridableProperty<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n + Overridable.shared), T> { // expected-error {{generic value must be an integer literal expression}}
  // expected-error@-1 {{unable to resolve variable reference in a literal expression}}
  Vector()
}

func rejectsDynamicStaticConstant<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n + Replaceable.value), T> { // expected-error {{generic value must be an integer literal expression}}
  // expected-error@-1 {{unable to resolve variable reference in a literal expression}}
  Vector()
}

// Matching is structural, not reverse arithmetic inference: a concrete
// Vector<5, _> cannot establish which value satisfies `n + 1 == 5`.
func requiresSymbolicPredecessor<let n: Int>(
  _ value: Vector<(n + 1), UInt8>
) {
  _ = value
}
// expected-note@-5 {{in call to function 'requiresSymbolicPredecessor'}}

func rejectsReverseArithmeticInference() {
  requiresSymbolicPredecessor(Vector<5, UInt8>())
  // expected-error@-1 {{generic parameter 'n' could not be inferred}}
  // expected-error@-2 {{cannot convert value of type 'Vector<5, UInt8>' to expected argument type 'Vector<(n + 1), UInt8>'}}
}
