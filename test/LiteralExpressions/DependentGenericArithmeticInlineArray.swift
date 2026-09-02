// Integration coverage for dependent arithmetic used as an InlineArray count.
// Concrete InlineArray literal-expression folding lives in the existing
// literal-expression tests; this file covers the symbolic remainder that
// those tests cannot exercise.
// REQUIRES: swift_feature_LiteralExpressions
// RUN: %target-typecheck-verify-swift -disable-availability-checking -enable-experimental-feature LiteralExpressions
// RUN: %target-swift-frontend -emit-sil -o /dev/null %s -disable-availability-checking -enable-experimental-feature LiteralExpressions
// RUN: %target-swift-frontend -emit-ir -o /dev/null %s -disable-availability-checking -enable-experimental-feature LiteralExpressions

// InlineArray counts retain the same dependent arithmetic tree as other
// integer generic arguments.
func orderedCount<let n: Int, let m: Int, T>(
  _ value: InlineArray<(m + n), T>
) -> InlineArray<(m + n), T> {
  value
}

func associatedCount<let n: Int, let m: Int, let p: Int, T>(
  _ value: InlineArray<((n + m) + p), T>
) -> InlineArray<((n + m) + p), T> {
  value
}

func foldedConstantCount<let n: Int, T>(
  _ value: InlineArray<(n + (2 + 3)), T>
) -> InlineArray<(n + 5), T> {
  value
}

func preservesIdentityCount<let n: Int, T>(
  _ value: InlineArray<((n * 1) + 0), T>
) -> InlineArray<((n * 1) + 0), T> {
  value
}

// The InlineArray sugar follows the same parenthesized spelling requirement.
func orderedSugaredCount<let n: Int, let m: Int, T>(
  _ value: [(m + n) of T]
) -> [(m + n) of T] {
  value
}

func requiresExactCount<let n: Int, let m: Int, T>(
  _ value: InlineArray<(n + m), T>
) {}

func forwardsExactCount<let n: Int, let m: Int, T>(
  _ value: InlineArray<(n + m), T>
) {
  requiresExactCount(value)
}

// A value generic inferred from one argument can make a dependent expression
// in a later parameter wholly concrete. Rebuilding that expression must fold
// it before the later argument is matched.
func acceptsSuccessor<let n: Int>(
  _ value: InlineArray<n, UInt8>,
  _ successor: InlineArray<(n + 1), UInt8>
) {}

func testConcreteSuccessor() {
  acceptsSuccessor(
    InlineArray<4, UInt8>(repeating: 0),
    InlineArray<5, UInt8>(repeating: 0)
  )
}

// Parameter-position expressions are useful when a caller already has the
// same structural expression. This forwarding call binds `inner` to `outer`;
// it does not infer a value by solving an arithmetic equation.
func acceptsSymbolicSuccessor<let inner: Int>(
  _ value: InlineArray<(inner + 1), UInt8>
) {}

func forwardsSymbolicSuccessor<let outer: Int>(
  _ value: InlineArray<outer, UInt8>,
  _ successor: InlineArray<(outer + 1), UInt8>
) {
  _ = value
  acceptsSymbolicSuccessor(successor)
}

// Independent generic parameters can be inferred from an expression with the
// same structure, including when the parameter names appear in the opposite
// order.
func makeSum<let lhs: Int, let rhs: Int>(
  _ first: InlineArray<lhs, UInt8>,
  _ second: InlineArray<rhs, UInt8>
) -> InlineArray<(lhs + rhs), UInt8> {
  _ = (first, second)
  return InlineArray<(lhs + rhs), UInt8>(repeating: 0)
}

func takesSwappedSum<let first: Int, let second: Int>(
  _ value: InlineArray<(second + first), UInt8>
) {
  _ = value
}

func forwardsSwappedSum<let lhs: Int, let rhs: Int>(
  _ first: InlineArray<lhs, UInt8>,
  _ second: InlineArray<rhs, UInt8>
) {
  takesSwappedSum(makeSum(first, second))
}

// Force lowering of an InlineArray whose storage count is a symbolic value.
func inlineArrayStride<let n: Int, let m: Int, T>(
  _: InlineArray<(n + m), T>.Type
) -> Int {
  MemoryLayout<InlineArray<(n + m), T>>.stride
}
