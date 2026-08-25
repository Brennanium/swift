// Cross-module and module-interface coverage for dependent arithmetic.
// REQUIRES: swift_feature_LiteralExpressions
// RUN: %empty-directory(%t)
// RUN: split-file %s %t
// RUN: %target-swift-frontend -emit-module -parse-as-library -module-name Arithmetic -emit-module-path %t/Arithmetic.swiftmodule -emit-module-interface-path %t/Arithmetic.swiftinterface -enable-library-evolution -swift-version 5 -disable-availability-checking -enable-experimental-feature LiteralExpressions %t/Arithmetic.swift
// RUN: %FileCheck %s --check-prefix=INTERFACE < %t/Arithmetic.swiftinterface
// RUN: %target-swift-typecheck-module-from-interface(%t/Arithmetic.swiftinterface) -module-name Arithmetic -disable-availability-checking -enable-experimental-feature LiteralExpressions
// RUN: %target-swift-frontend -emit-sil -o /dev/null -I %t -swift-version 5 -disable-availability-checking -enable-experimental-feature LiteralExpressions %t/Client.swift

// INTERFACE: public func mixed
// INTERFACE-SAME: -> Arithmetic::Vector<(n + m * p), T>
// INTERFACE: public func grouped
// INTERFACE-SAME: -> Arithmetic::Vector<((n + m) * p), T>
// INTERFACE: public func difference
// INTERFACE-SAME: -> Arithmetic::Vector<(n - m), T>
// INTERFACE: public func quotient
// INTERFACE-SAME: -> Arithmetic::Vector<(n / 2), T>
// INTERFACE: public func remainder
// INTERFACE-SAME: -> Arithmetic::Vector<(n % 3), T>
// INTERFACE: public func bitwise
// INTERFACE-SAME: -> Arithmetic::Vector<((~n & m) | (n ^ m)), T>
// INTERFACE: public func unaryPlus
// INTERFACE-SAME: -> Arithmetic::Vector<(+n), T>
// INTERFACE: public func negate
// INTERFACE-SAME: -> Arithmetic::Vector<(-n), T>
// INTERFACE: public func wrapping
// INTERFACE-SAME: -> Arithmetic::Vector<((n &+ m) &* n &- m), T>
// INTERFACE: public func wrappingIncrement
// INTERFACE-SAME: -> Arithmetic::Vector<(n &+ 1), T>
// INTERFACE: public func wrappingSquare
// INTERFACE-SAME: -> Arithmetic::Vector<(n &* n), T>
// INTERFACE: public func shift
// INTERFACE-SAME: -> Arithmetic::Vector<(n << m), T>
// INTERFACE: public func rightShift
// INTERFACE-SAME: -> Arithmetic::Vector<(n >> m), T>
// INTERFACE: public func maskingShift
// INTERFACE-SAME: -> Arithmetic::Vector<(n &>> m), T>
// INTERFACE: public func maskingShiftByWord
// INTERFACE-SAME: -> Arithmetic::Vector<(n &<< 64), T>
// INTERFACE: public func withFoldedConstant
// INTERFACE-SAME: -> Arithmetic::Vector<(n + 5), T>
// INTERFACE: public func withNestedFoldedConstants
// INTERFACE-SAME: -> Arithmetic::Vector<(n + 15), T>
// INTERFACE: public func orderedAdd
// INTERFACE-SAME: Arithmetic::Vector<(m + n), T>) -> Arithmetic::Vector<(m + n), T>
// INTERFACE: public func orderedLongAdd
// INTERFACE-SAME: Arithmetic::Vector<(s + (m + 4) + (q + 1 + (n + (r + (p + 2))))), T>) -> Arithmetic::Vector<(s + (m + 4) + (q + 1 + (n + (r + (p + 2))))), T>
// INTERFACE: public func orderedLongMultiply
// INTERFACE-SAME: Arithmetic::Vector<(s * (m * 4) * (q * 1 * (n * (r * (p * 2))))), T>) -> Arithmetic::Vector<(s * (m * 4) * (q * 1 * (n * (r * (p * 2))))), T>

//--- Arithmetic.swift
public struct Vector<let N: Int, T> {
  public init() {}
  public static var size: Int { Self.N }
}

let offset = 5
enum Dimensions {
  static let scale = 3
}

public func mixed<let n: Int, let m: Int, let p: Int, T>(
  _ lhs: Vector<n, T>, _ middle: Vector<m, T>, _ rhs: Vector<p, T>
) -> Vector<(n + m * p), T> {
  Vector()
}

public func grouped<let n: Int, let m: Int, let p: Int, T>(
  _ lhs: Vector<n, T>, _ middle: Vector<m, T>, _ rhs: Vector<p, T>
) -> Vector<((n + m) * p), T> {
  Vector()
}

public func difference<let n: Int, let m: Int, T>(
  _ lhs: Vector<n, T>, _ rhs: Vector<m, T>
) -> Vector<(n - m), T> {
  Vector()
}

public func quotient<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n / 2), T> {
  Vector()
}

public func remainder<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n % 3), T> {
  Vector()
}

public func bitwise<let n: Int, let m: Int, T>(
  _ lhs: Vector<n, T>, _ rhs: Vector<m, T>
) -> Vector<((~n & m) | (n ^ m)), T> {
  Vector()
}

public func unaryPlus<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(+n), T> {
  Vector()
}

public func negate<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(-n), T> {
  Vector()
}

public func wrapping<let n: Int, let m: Int, T>(
  _ lhs: Vector<n, T>, _ rhs: Vector<m, T>
) -> Vector<(((n &+ m) &* n) &- m), T> {
  Vector()
}

public func wrappingIncrement<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n &+ 1), T> {
  Vector()
}

public func wrappingSquare<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n &* n), T> {
  Vector()
}

public func shift<let n: Int, let m: Int, T>(
  _ value: Vector<n, T>, _ amount: Vector<m, T>
) -> Vector<(n << m), T> {
  Vector()
}

public func rightShift<let n: Int, let m: Int, T>(
  _ value: Vector<n, T>, _ amount: Vector<m, T>
) -> Vector<(n >> m), T> {
  Vector()
}

public func maskingShift<let n: Int, let m: Int, T>(
  _ value: Vector<n, T>, _ amount: Vector<m, T>
) -> Vector<(n &>> m), T> {
  Vector()
}

public func maskingShiftByWord<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n &<< 64), T> {
  Vector()
}

public func withFoldedConstant<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n + offset), T> {
  Vector()
}

public func withNestedFoldedConstants<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n + (offset * Dimensions.scale)), T> {
  Vector()
}

public func orderedAdd<let n: Int, let m: Int, T>(
  _ value: Vector<(m + n), T>
) -> Vector<(m + n), T> {
  value
}

// A long, deliberately ordered tree survives interface emission unchanged.
public func orderedLongAdd<let n: Int, let m: Int, let p: Int, let q: Int,
                           let r: Int, let s: Int, T>(
  _ value: Vector<((s + (m + 4)) + ((q + 1) + (n + (r + (p + 2))))), T>
) -> Vector<((s + (m + 4)) + ((q + 1) + (n + (r + (p + 2))))), T> {
  value
}

public func orderedLongMultiply<let n: Int, let m: Int, let p: Int,
                                let q: Int, let r: Int, let s: Int, T>(
  _ value: Vector<((s * (m * 4)) * ((q * 1) * (n * (r * (p * 2))))), T>
) -> Vector<((s * (m * 4)) * ((q * 1) * (n * (r * (p * 2))))), T> {
  value
}

//--- Client.swift
import Arithmetic

func orderedAcrossModules<let n: Int, let m: Int, T>(
  _ value: Vector<(m + n), T>
) -> Vector<(m + n), T> {
  orderedAdd(value)
}

func orderedLongChainAcrossModules<let n: Int, let m: Int, let p: Int,
                                   let q: Int, let r: Int, let s: Int, T>(
  _ value: Vector<((s + (m + 4)) + ((q + 1) + (n + (r + (p + 2))))), T>
) -> Vector<((s + (m + 4)) + ((q + 1) + (n + (r + (p + 2))))), T> {
  orderedLongAdd(value)
}

func orderedLongProductAcrossModules<let n: Int, let m: Int, let p: Int,
                                     let q: Int, let r: Int, let s: Int, T>(
  _ value: Vector<((s * (m * 4)) * ((q * 1) * (n * (r * (p * 2))))), T>
) -> Vector<((s * (m * 4)) * ((q * 1) * (n * (r * (p * 2))))), T> {
  orderedLongMultiply(value)
}

func bitwiseAcrossModules<let n: Int, let m: Int, T>(
  _ lhs: Vector<n, T>, _ rhs: Vector<m, T>
) -> Vector<((~n & m) | (n ^ m)), T> {
  bitwise(lhs, rhs)
}

func negatedAcrossModules<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(-n), T> {
  negate(value)
}

func unaryPlusAcrossModules<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(+n), T> {
  unaryPlus(value)
}

func foldedUnaryPlusAcrossModules<T>(
  _ value: Vector<3, T>
) -> Vector<3, T> {
  unaryPlus(value)
}

func wrappingAcrossModules<let n: Int, let m: Int, T>(
  _ lhs: Vector<n, T>, _ rhs: Vector<m, T>
) -> Vector<(((n &+ m) &* n) &- m), T> {
  wrapping(lhs, rhs)
}

func shiftAcrossModules<let n: Int, let m: Int, T>(
  _ value: Vector<n, T>, _ amount: Vector<m, T>
) -> Vector<(n << m), T> {
  shift(value, amount)
}

func smartShiftAcrossModules<T>(
  _ value: Vector<8, T>
) -> Vector<4, T> {
  shift(value, Vector<(-1), T>())
}

func overshiftAcrossModules<T>(
  _ value: Vector<1, T>
) -> Vector<0, T> {
  shift(value, Vector<64, T>())
}

func negativeRightShiftAcrossModules<T>(
  _ value: Vector<(-8), T>
) -> Vector<(-16), T> {
  rightShift(value, Vector<(-1), T>())
}

func overshiftRightAcrossModules<T>(
  _ value: Vector<(-8), T>
) -> Vector<(-1), T> {
  rightShift(value, Vector<64, T>())
}

func maskingShiftAcrossModules<T>(
  _ value: Vector<1, T>
) -> Vector<1, T> {
  maskingShiftByWord(value)
}

func wrappingOverflowAcrossModules<T>(
  _ value: Vector<9223372036854775807, T>
) -> Vector<1, T> {
  wrappingSquare(value)
}

func wrappingMinimumAcrossModules<T>(
  _ value: Vector<9223372036854775807, T>
) -> Vector<(-9223372036854775808), T> {
  wrappingIncrement(value)
}

func test() {
  let two = Vector<2, Int>()
  let three = Vector<3, Int>()
  let four = Vector<4, Int>()

  let precedence = mixed(two, three, four)
  let parentheses = grouped(two, three, four)
  let differenceResult = difference(two, three)
  let quotientResult = quotient(four)
  let remainderResult = remainder(four)
  let bitwiseResult = bitwise(two, three)
  let negatedResult = negate(two)
  let wrappingResult = wrapping(two, three)
  let shiftResult = shift(two, three)
  let maskingShiftResult = maskingShift(two, three)
  let constant = withFoldedConstant(two)
  let nestedConstant = withNestedFoldedConstants(two)
  let foldedPrecedence: Vector<14, Int> = mixed(two, three, four)
  let foldedParentheses: Vector<20, Int> = grouped(two, three, four)
  let foldedDifference: Vector<-1, Int> = difference(two, three)
  let foldedQuotient: Vector<2, Int> = quotient(four)
  let foldedRemainder: Vector<1, Int> = remainder(four)
  _ = (precedence, parentheses, differenceResult, quotientResult,
       remainderResult, constant, nestedConstant, foldedPrecedence,
       foldedParentheses, foldedDifference, foldedQuotient, foldedRemainder,
       bitwiseResult, negatedResult, wrappingResult, shiftResult,
       maskingShiftResult)
}
