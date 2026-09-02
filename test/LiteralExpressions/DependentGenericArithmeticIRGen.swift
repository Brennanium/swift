// Code generation and mangling coverage for dependent arithmetic in integer
// generic argument values.
// REQUIRES: swift_feature_LiteralExpressions
// RUN: %target-swift-frontend -emit-ir %s -disable-availability-checking -enable-experimental-feature LiteralExpressions | %FileCheck %s --check-prefix=IR
// RUN: %target-swift-frontend -emit-silgen %s -disable-availability-checking -enable-experimental-feature LiteralExpressions | swift-demangle | %FileCheck %s --check-prefix=DEMANGLE
// RUN: %target-swift-frontend -emit-silgen %s -disable-availability-checking -enable-experimental-feature LiteralExpressions | swift-demangle -test-remangle | %FileCheck %s --check-prefix=REMANGLE

struct Vector<let N: Int, T> {
  init() {}
}

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

func divide<let n: Int, let m: Int, T>(
  _ lhs: Vector<n, T>, _ rhs: Vector<m, T>
) -> Vector<(n / m), T> {
  Vector()
}

func remainder<let n: Int, let m: Int, T>(
  _ lhs: Vector<n, T>, _ rhs: Vector<m, T>
) -> Vector<(n % m), T> {
  Vector()
}

func bitwise<let n: Int, let m: Int, T>(
  _ lhs: Vector<n, T>, _ rhs: Vector<m, T>
) -> Vector<((~n & m) | (n ^ m)), T> {
  Vector()
}

func unaryPlus<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(+n), T> {
  Vector()
}

func negate<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(-n), T> {
  Vector()
}

func wrappingArithmetic<let n: Int, let m: Int, T>(
  _ lhs: Vector<n, T>, _ rhs: Vector<m, T>
) -> Vector<(((n &+ m) &* n) &- m), T> {
  Vector()
}

func shifts<let n: Int, let m: Int, T>(
  _ value: Vector<n, T>, _ amount: Vector<m, T>
) -> Vector<(((n << m) >> m) &<< m), T> {
  Vector()
}

func maskingRightShift<let n: Int, let m: Int, T>(
  _ value: Vector<n, T>, _ amount: Vector<m, T>
) -> Vector<(n &>> m), T> {
  Vector()
}

func zeroAfterPotentialOverflow<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<((n + 1) * 0), T> {
  Vector()
}

func orderedSum<let n: Int, let m: Int, let p: Int, T>(
  _ value: Vector<n, T>
) -> Vector<((n + m) + p), T> {
  Vector()
}

func overflowedConstantTail<let n: Int, T>(
  _ value: Vector<n, T>
) -> Vector<(n + 9223372036854775807 + 1), T> {
  Vector()
}

func wideNegativeLiteral<T>() -> Vector<-3000000000, T> {
  Vector()
}

// IR-LABEL: define hidden swiftcc void @"$s{{.*}}add{{.*}}"
// IR: call { i{{32|64}}, i1 } @llvm.sadd.with.overflow.i{{32|64}}
// IR-LABEL: define hidden swiftcc void @"$s{{.*}}multiply{{.*}}"
// IR: call { i{{32|64}}, i1 } @llvm.smul.with.overflow.i{{32|64}}
// IR-LABEL: define hidden swiftcc void @"$s{{.*}}subtract{{.*}}"
// IR: call { i{{32|64}}, i1 } @llvm.ssub.with.overflow.i{{32|64}}
// IR-LABEL: define hidden swiftcc void @"$s{{.*}}divide{{.*}}"
// IR: icmp eq i{{32|64}} %m, 0
// IR: sdiv i{{32|64}}
// IR: call void @llvm.trap()
// IR-LABEL: define hidden swiftcc void @"$s{{.*}}remainder{{.*}}"
// IR: icmp eq i{{32|64}} %m, 0
// IR: srem i{{32|64}}
// IR: call void @llvm.trap()
// IR-LABEL: define hidden swiftcc void @"$s{{.*}}bitwise{{.*}}"
// IR: and i{{32|64}}
// IR: xor i{{32|64}}
// IR: or i{{32|64}}
// IR-LABEL: define hidden swiftcc void @"$s{{.*}}unaryPlus{{.*}}"
// IR-NOT: llvm.ssub.with.overflow
// IR-LABEL: define hidden swiftcc void @"$s{{.*}}negate{{.*}}"
// IR: call { i{{32|64}}, i1 } @llvm.ssub.with.overflow.i{{32|64}}(i{{32|64}} 0, i{{32|64}} %n)
// IR-LABEL: define hidden swiftcc void @"$s{{.*}}wrapping{{.*}}"
// IR: add i{{32|64}}
// IR: mul i{{32|64}}
// IR: sub i{{32|64}}
// IR-LABEL: define hidden swiftcc void @"$s{{.*}}shifts{{.*}}"
// IR: icmp slt i{{32|64}}
// IR: icmp sge i{{32|64}}
// IR: icmp sle i{{32|64}}
// IR: shl i{{32|64}}
// IR: ashr i{{32|64}}
// IR: select i1
// IR-LABEL: define hidden swiftcc void @"$s{{.*}}maskingRightShift{{.*}}"
// IR: and i{{32|64}} {{.*}}, {{31|63}}
// IR: ashr i{{32|64}}
// IR-LABEL: define hidden swiftcc void @"$s{{.*}}zeroAfterPotentialOverflow{{.*}}"
// IR: call { i{{32|64}}, i1 } @llvm.sadd.with.overflow.i{{32|64}}(i{{32|64}} %n, i{{32|64}} 1)
// IR: call { i{{32|64}}, i1 } @llvm.smul.with.overflow.i{{32|64}}
// IR-LABEL: define hidden swiftcc void @"$s{{.*}}orderedSum{{.*}}"
// IR: call { i{{32|64}}, i1 } @llvm.sadd.with.overflow.i{{32|64}}(i{{32|64}} %n, i{{32|64}} %m)
// IR: call { i{{32|64}}, i1 } @llvm.sadd.with.overflow.i{{32|64}}
// IR-LABEL: define hidden swiftcc void @"$s{{.*}}overflowedConstantTail{{.*}}"
// IR: call { i{{32|64}}, i1 } @llvm.sadd.with.overflow.i{{32|64}}(i{{32|64}} %n, i{{32|64}} 9223372036854775807)
// IR: call { i{{32|64}}, i1 } @llvm.sadd.with.overflow.i{{32|64}}

// DEMANGLE: func add<let n : Int, let m : Int, T>(_ lhs: Vector<n, T>, _ rhs: Vector<m, T>) -> Vector<(n + m), T>
// DEMANGLE: func multiply<let n : Int, let m : Int, T>(_ lhs: Vector<n, T>, _ rhs: Vector<m, T>) -> Vector<(n * m), T>
// DEMANGLE: func subtract<let n : Int, let m : Int, T>(_ lhs: Vector<n, T>, _ rhs: Vector<m, T>) -> Vector<(n - m), T>
// DEMANGLE: func divide<let n : Int, let m : Int, T>(_ lhs: Vector<n, T>, _ rhs: Vector<m, T>) -> Vector<(n / m), T>
// DEMANGLE: func remainder<let n : Int, let m : Int, T>(_ lhs: Vector<n, T>, _ rhs: Vector<m, T>) -> Vector<(n % m), T>
// DEMANGLE: func bitwise<let n : Int, let m : Int, T>(_ lhs: Vector<n, T>, _ rhs: Vector<m, T>) -> Vector<((~n & m) | (n ^ m)), T>
// DEMANGLE: func unaryPlus<let n : Int, T>(_ value: Vector<n, T>) -> Vector<(+n), T>
// DEMANGLE: func negate<let n : Int, T>(_ value: Vector<n, T>) -> Vector<(-n), T>
// DEMANGLE: func wrappingArithmetic<let n : Int, let m : Int, T>(_ lhs: Vector<n, T>, _ rhs: Vector<m, T>) -> Vector<((n &+ m) &* n &- m), T>
// DEMANGLE: func shifts<let n : Int, let m : Int, T>(_ value: Vector<n, T>, _ amount: Vector<m, T>) -> Vector<(((n << m) >> m) &<< m), T>
// DEMANGLE: func maskingRightShift<let n : Int, let m : Int, T>(_ value: Vector<n, T>, _ amount: Vector<m, T>) -> Vector<(n &>> m), T>
// DEMANGLE: func orderedSum<let n : Int, let m : Int, let p : Int, T>(_ value: Vector<n, T>) -> Vector<(n + m + p), T>
// DEMANGLE: func overflowedConstantTail<let n : Int, T>(_ value: Vector<n, T>) -> Vector<(n + 9223372036854775807 + 1), T>
// DEMANGLE: func wideNegativeLiteral<T>() -> Vector<-3000000000, T>

// REMANGLE: @$s{{.*}}unaryPlus{{.*}}$Vi{{.*}}
