// Dependent arithmetic in integer generic parameter values.
// REQUIRES: swift_feature_LiteralExpressions
// RUN: %target-typecheck-verify-swift -disable-availability-checking -enable-experimental-feature LiteralExpressions
// RUN: %target-swift-frontend -typecheck -dump-ast %s -disable-availability-checking -enable-experimental-feature LiteralExpressions -verify | %FileCheck %s

struct Vector<let N: Int, T> {}

private let offset = 5
private let scale = 3
private let derivedOffset = offset + 2
private enum Dimensions {
  static let scale = 3
}

let concreteReference: Vector<(offset), Int> = Vector()
let concreteStaticReference: Vector<(Dimensions.scale), Int> = Vector()

func add<let n: Int, let m: Int, T>(
  _ lhs: Vector<n, T>, _ rhs: Vector<m, T>
) -> Vector<(n + m), T> {
  Vector()
}

func multiply<let n: Int, let m: Int, T>(
  _ lhs: Vector<n, T>, _ rhs: Vector<m, T>
) -> Vector<(n * m), T> {
  Vector()
}

func subtract<let n: Int, let m: Int, T>(
  _ lhs: Vector<n, T>, _ rhs: Vector<m, T>
) -> Vector<(n - m), T> {
  Vector()
}

func divideByFoldedConstant<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n / (1 + 1)), T> {
  Vector()
}
// CHECK-LABEL: "divideByFoldedConstant(_:)" "<n : Int, T>" interface_type="<let n : Int, T> (Vector<n, T>) -> Vector<(n / 2), T>"

func remainderByFoldedConstant<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n % (7 - 3)), T> {
  Vector()
}
// CHECK-LABEL: "remainderByFoldedConstant(_:)" "<n : Int, T>" interface_type="<let n : Int, T> (Vector<n, T>) -> Vector<(n % 4), T>"

func bitwiseAnd<let n: Int, let m: Int, T>(
  _ lhs: Vector<n, T>, _ rhs: Vector<m, T>
) -> Vector<(n & m), T> {
  Vector()
}

func bitwiseOr<let n: Int, let m: Int, T>(
  _ lhs: Vector<n, T>, _ rhs: Vector<m, T>
) -> Vector<(n | m), T> {
  Vector()
}

func bitwiseXor<let n: Int, let m: Int, T>(
  _ lhs: Vector<n, T>, _ rhs: Vector<m, T>
) -> Vector<(n ^ m), T> {
  Vector()
}

func bitwiseNot<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(~n), T> {
  Vector()
}

func unaryPlus<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(+n), T> {
  Vector()
}
// CHECK-LABEL: "unaryPlus(_:)" "<n : Int, T>" interface_type="<let n : Int, T> (Vector<n, T>) -> Vector<(+n), T>"

func negate<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(-n), T> {
  Vector()
}
// CHECK-LABEL: "negate(_:)" "<n : Int, T>" interface_type="<let n : Int, T> (Vector<n, T>) -> Vector<(-n), T>"

func wrappingAdd<let n: Int, let m: Int, T>(
  _ lhs: Vector<n, T>, _ rhs: Vector<m, T>
) -> Vector<(n &+ m), T> {
  Vector()
}

func wrappingSubtract<let n: Int, let m: Int, T>(
  _ lhs: Vector<n, T>, _ rhs: Vector<m, T>
) -> Vector<(n &- m), T> {
  Vector()
}

func wrappingMultiply<let n: Int, let m: Int, T>(
  _ lhs: Vector<n, T>, _ rhs: Vector<m, T>
) -> Vector<(n &* m), T> {
  Vector()
}

func foldedUnaryNegateConstant<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n + -((3 - 5))), T> {
  Vector()
}
// CHECK-LABEL: "foldedUnaryNegateConstant(_:)" "<n : Int, T>" interface_type="<let n : Int, T> (Vector<n, T>) -> Vector<(n + 2), T>"

func leftShift<let n: Int, let m: Int, T>(
  _ value: Vector<n, T>, _ amount: Vector<m, T>
) -> Vector<(n << m), T> {
  Vector()
}

func rightShift<let n: Int, let m: Int, T>(
  _ value: Vector<n, T>, _ amount: Vector<m, T>
) -> Vector<(n >> m), T> {
  Vector()
}

func maskingLeftShift<let n: Int, let m: Int, T>(
  _ value: Vector<n, T>, _ amount: Vector<m, T>
) -> Vector<(n &<< m), T> {
  Vector()
}

func maskingRightShift<let n: Int, let m: Int, T>(
  _ value: Vector<n, T>, _ amount: Vector<m, T>
) -> Vector<(n &>> m), T> {
  Vector()
}

func foldedBitwiseConstant<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n & (15 ^ 3)), T> {
  Vector()
}
// CHECK-LABEL: "foldedBitwiseConstant(_:)" "<n : Int, T>" interface_type="<let n : Int, T> (Vector<n, T>) -> Vector<(n & 12), T>"

func foldedUnaryBitwiseConstant<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n ^ ~0), T> {
  Vector()
}
// CHECK-LABEL: "foldedUnaryBitwiseConstant(_:)" "<n : Int, T>" interface_type="<let n : Int, T> (Vector<n, T>) -> Vector<(n ^ -1), T>"

// Complete SE-0531 literal-expression subexpressions retain Swift's
// smart-shift semantics before they are connected to the dependent part of the
// expression.
func foldedNegativeSmartShift<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n + (8 << -1)), T> {
  Vector()
}
// CHECK-LABEL: "foldedNegativeSmartShift(_:)" "<n : Int, T>" interface_type="<let n : Int, T> (Vector<n, T>) -> Vector<(n + 4), T>"

func foldedOvershift<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n + (1 << 64)), T> {
  Vector()
}
// CHECK-LABEL: "foldedOvershift(_:)" "<n : Int, T>" interface_type="<let n : Int, T> (Vector<n, T>) -> Vector<(n + 0), T>"

func divisionWithAddition<let n: Int, let m: Int, T>(
  _ value: Vector<n, T>
) -> Vector<((n + m) / 2), T> {
  Vector()
}
// CHECK-LABEL: "divisionWithAddition(_:)" "<n : Int, m : Int, T>" interface_type="<let n : Int, let m : Int, T> (Vector<n, T>) -> Vector<((n + m) / 2), T>"

// Parentheses around a value generic parameter use the generic-value-expression
// fallback rather than being interpreted as a parenthesized type argument.
func groupedGenericValue<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n), T> {
  value
}
// CHECK-LABEL: "groupedGenericValue(_:)" "<n : Int, T>" interface_type="<let n : Int, T> (Vector<n, T>) -> Vector<n, T>"

// A signed concrete integer remains a literal operand.
func addNegativeLiteral<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n + -1), T> {
  Vector()
}
// CHECK-LABEL: "addNegativeLiteral(_:)" "<n : Int, T>" interface_type="<let n : Int, T> (Vector<n, T>) -> Vector<(n + -1), T>"

func mixedPrecedence<let n: Int, let m: Int, let p: Int, T>(
  _ first: Vector<n, T>, _ second: Vector<m, T>, _ third: Vector<p, T>
) -> Vector<(n + m * p), T> {
  Vector()
}

// The source expression intentionally has no interior parentheses. Swift's
// ordinary precedence first groups unary negation, shifts, multiplication,
// then addition; operators in each binary precedence group associate left.
func standardOperatorPrecedence<let n: Int, let m: Int, let p: Int, let q: Int,
                                let r: Int, let s: Int, let t: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(-n << m &* p & q &+ r | s ^ t), T> {
  Vector()
}
// CHECK-LABEL: "standardOperatorPrecedence(_:)" "<n : Int, m : Int, p : Int, q : Int, r : Int, s : Int, t : Int, T>" interface_type="<let n : Int, let m : Int, let p : Int, let q : Int, let r : Int, let s : Int, let t : Int, T> (Vector<n, T>) -> Vector<((((((-n << m) &* p) & q) &+ r) | s) ^ t), T>"

func nested<let n: Int, let m: Int, let p: Int, T>(
  _ first: Vector<n, T>, _ second: Vector<m, T>, _ third: Vector<p, T>
) -> Vector<((n + m) * p), T> {
  Vector()
}

// Subtraction is structural: its operand order and right-nested additive
// expressions must survive printing and type comparison.
func nestedSubtraction<let n: Int, let m: Int, let p: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n - (m - p)), T> {
  Vector()
}
// CHECK-LABEL: "nestedSubtraction(_:)" "<n : Int, m : Int, p : Int, T>" interface_type="<let n : Int, let m : Int, let p : Int, T> (Vector<n, T>) -> Vector<(n - (m - p)), T>"

func additionWithSubtraction<let n: Int, let m: Int, let p: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n + (m - p)), T> {
  Vector()
}
// CHECK-LABEL: "additionWithSubtraction(_:)" "<n : Int, m : Int, p : Int, T>" interface_type="<let n : Int, let m : Int, let p : Int, T> (Vector<n, T>) -> Vector<(n + (m - p)), T>"

func subtractionWithAddition<let n: Int, let m: Int, let p: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n - (m + p)), T> {
  Vector()
}
// CHECK-LABEL: "subtractionWithAddition(_:)" "<n : Int, m : Int, p : Int, T>" interface_type="<let n : Int, let m : Int, let p : Int, T> (Vector<n, T>) -> Vector<(n - (m + p)), T>"

func multiplicationWithSubtraction<let n: Int, let m: Int, let p: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n * (m - p)), T> {
  Vector()
}
// CHECK-LABEL: "multiplicationWithSubtraction(_:)" "<n : Int, m : Int, p : Int, T>" interface_type="<let n : Int, let m : Int, let p : Int, T> (Vector<n, T>) -> Vector<(n * (m - p)), T>"

func multiplicationAfterDivision<let n: Int, let m: Int, T>(
  _ value: Vector<n, T>
) -> Vector<((n / 2) * m), T> {
  Vector()
}
// CHECK-LABEL: "multiplicationAfterDivision(_:)" "<n : Int, m : Int, T>" interface_type="<let n : Int, let m : Int, T> (Vector<n, T>) -> Vector<(n / 2 * m), T>"

func addRightIdentity<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n + 0), T> {
  Vector()
}
// CHECK-LABEL: "addRightIdentity(_:)" "<n : Int, T>" interface_type="<let n : Int, T> (Vector<n, T>) -> Vector<(n + 0), T>"

func addLeftIdentity<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(0 + n), T> {
  Vector()
}
// CHECK-LABEL: "addLeftIdentity(_:)" "<n : Int, T>" interface_type="<let n : Int, T> (Vector<n, T>) -> Vector<(0 + n), T>"

func multiplyRightIdentity<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n * 1), T> {
  Vector()
}
// CHECK-LABEL: "multiplyRightIdentity(_:)" "<n : Int, T>" interface_type="<let n : Int, T> (Vector<n, T>) -> Vector<(n * 1), T>"

func multiplyLeftIdentity<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(1 * n), T> {
  Vector()
}
// CHECK-LABEL: "multiplyLeftIdentity(_:)" "<n : Int, T>" interface_type="<let n : Int, T> (Vector<n, T>) -> Vector<(1 * n), T>"

func multiplyRightZero<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n * 0), T> {
  Vector()
}
// CHECK-LABEL: "multiplyRightZero(_:)" "<n : Int, T>" interface_type="<let n : Int, T> (Vector<n, T>) -> Vector<(n * 0), T>"

func multiplyLeftZero<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(0 * n), T> {
  Vector()
}
// CHECK-LABEL: "multiplyLeftZero(_:)" "<n : Int, T>" interface_type="<let n : Int, T> (Vector<n, T>) -> Vector<(0 * n), T>"

func preservesAddConstantOrder<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(5 + n), T> {
  Vector()
}
// CHECK-LABEL: "preservesAddConstantOrder(_:)" "<n : Int, T>" interface_type="<let n : Int, T> (Vector<n, T>) -> Vector<(5 + n), T>"

func preservesMultiplyConstantOrder<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(3 * n), T> {
  Vector()
}
// CHECK-LABEL: "preservesMultiplyConstantOrder(_:)" "<n : Int, T>" interface_type="<let n : Int, T> (Vector<n, T>) -> Vector<(3 * n), T>"

func foldedConstantPreservesAddOrder<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<((2 + 3) + n), T> {
  Vector()
}
// CHECK-LABEL: "foldedConstantPreservesAddOrder(_:)" "<n : Int, T>" interface_type="<let n : Int, T> (Vector<n, T>) -> Vector<(5 + n), T>"

func foldedAddIdentity<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n + (3 - 3)), T> {
  Vector()
}
// CHECK-LABEL: "foldedAddIdentity(_:)" "<n : Int, T>" interface_type="<let n : Int, T> (Vector<n, T>) -> Vector<(n + 0), T>"

func foldedMultiplyIdentity<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n * ((1 << 1) - 1)), T> {
  Vector()
}
// CHECK-LABEL: "foldedMultiplyIdentity(_:)" "<n : Int, T>" interface_type="<let n : Int, T> (Vector<n, T>) -> Vector<(n * 1), T>"

func foldedMultiplyZero<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n * (5 % 5)), T> {
  Vector()
}
// CHECK-LABEL: "foldedMultiplyZero(_:)" "<n : Int, T>" interface_type="<let n : Int, T> (Vector<n, T>) -> Vector<(n * 0), T>"

func addFoldedConstant<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n + offset), T> {
  Vector()
}
// CHECK-LABEL: "addFoldedConstant(_:)" "<n : Int, T>" interface_type="<let n : Int, T> (Vector<n, T>) -> Vector<(n + 5), T>"

func multiplyFoldedConstant<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n * scale), T> {
  Vector()
}
// CHECK-LABEL: "multiplyFoldedConstant(_:)" "<n : Int, T>" interface_type="<let n : Int, T> (Vector<n, T>) -> Vector<(n * 3), T>"

func nestedFoldedConstants<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n + (offset * scale)), T> {
  Vector()
}
// CHECK-LABEL: "nestedFoldedConstants(_:)" "<n : Int, T>" interface_type="<let n : Int, T> (Vector<n, T>) -> Vector<(n + 15), T>"

func chainedFoldedConstant<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n + derivedOffset), T> {
  Vector()
}
// CHECK-LABEL: "chainedFoldedConstant(_:)" "<n : Int, T>" interface_type="<let n : Int, T> (Vector<n, T>) -> Vector<(n + 7), T>"

func staticFoldedConstant<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n + Dimensions.scale), T> {
  Vector()
}
// CHECK-LABEL: "staticFoldedConstant(_:)" "<n : Int, T>" interface_type="<let n : Int, T> (Vector<n, T>) -> Vector<(n + 3), T>"

func literalSubexpression<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n + (2 + 3)), T> {
  Vector()
}
// CHECK-LABEL: "literalSubexpression(_:)" "<n : Int, T>" interface_type="<let n : Int, T> (Vector<n, T>) -> Vector<(n + 5), T>"

func subtractLiteralSubexpression<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n - (7 - 2)), T> {
  Vector()
}
// CHECK-LABEL: "subtractLiteralSubexpression(_:)" "<n : Int, T>" interface_type="<let n : Int, T> (Vector<n, T>) -> Vector<(n - 5), T>"

func fullyFoldedLiteralExpressionSubexpression<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n + ((1 << 4) - 3)), T> {
  Vector()
}
// CHECK-LABEL: "fullyFoldedLiteralExpressionSubexpression(_:)" "<n : Int, T>" interface_type="<let n : Int, T> (Vector<n, T>) -> Vector<(n + 13), T>"

func fullyFoldedLiteralExpressionIntegerOperators<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n + ((((1 &<< 4) >> 1) | ((9 % 4) & 3)) ^ 2)), T> {
  Vector()
}
// CHECK-LABEL: "fullyFoldedLiteralExpressionIntegerOperators(_:)" "<n : Int, T>" interface_type="<let n : Int, T> (Vector<n, T>) -> Vector<(n + 11), T>"

func localValueShadowsGenericParameter<let n: Int>(
  _ genericValue: Vector<n, Int>
) {
  let n = 2
  let foldedValue: Vector<3, Int> = Vector()
  let _: Vector<(n + 1), Int> = foldedValue
  _ = n
  _ = genericValue
}

// An overflowing sequence is preserved in its parsed order. In particular,
// resolving this signature must not assume every concrete term can fold to an
// IntegerType.
func overflowedConstantTail<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n + 9223372036854775807 + 1), T> {
  Vector()
}

// Structural identity does not introduce algebraic equivalences across
// operators.
struct CoefficientVector<let N: Int, T> {} // expected-note {{arguments to generic parameter 'N' ('n + n' and 'n * 2') are expected to be equal}}

func doesNotCollectCoefficients<let n: Int, T>(
  _ value: CoefficientVector<(n + n), T>
) -> CoefficientVector<(n * 2), T> {
  value // expected-error {{cannot convert return expression of type 'CoefficientVector<(n + n), T>' to return type 'CoefficientVector<(n * 2), T>'}}
}

let two = Vector<2, Int>()
let three = Vector<3, Int>()
let foldedCallResult: Vector<5, Int> = add(two, three)
// CHECK-LABEL: (pattern_named type="Vector<5, Int>" "foldedCallResult")

let negativeTwo = Vector<(-2), Int>()
let signedAddResult: Vector<1, Int> = add(negativeTwo, three)
// CHECK-LABEL: (pattern_named type="Vector<1, Int>" "signedAddResult")
let signedMultiplyResult: Vector<(-6), Int> = multiply(negativeTwo, three)
// CHECK-LABEL: (pattern_named type="Vector<-6, Int>" "signedMultiplyResult")
let signedSubtractResult: Vector<-5, Int> = subtract(negativeTwo, three)
// CHECK-LABEL: (pattern_named type="Vector<-5, Int>" "signedSubtractResult")

let hundredThousand = Vector<100000, Int>()
let largeMultiplyResult: Vector<10000000000, Int> = multiply(
  hundredThousand, hundredThousand
)
// CHECK-LABEL: (pattern_named type="Vector<10000000000, Int>" "largeMultiplyResult")

struct Divide<let n: Int, let m: Int, T> {
  let value: Vector<(n / m), T> // expected-error {{the divisor in a dependent generic value expression must be a nonzero integer constant expression}}
}

struct NonValueOperand<let n: Int, T> {
  let value: Vector<(n + T), Int> // expected-error {{dependent generic value expressions currently support only integer literals and value generic parameters}}
}
