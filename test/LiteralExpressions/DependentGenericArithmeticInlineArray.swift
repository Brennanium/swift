// Integration coverage for dependent arithmetic used as an InlineArray count.
// Concrete InlineArray literal-expression folding lives in the SE-0531 tests;
// this file covers the symbolic remainder that those tests cannot exercise.
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

// Force lowering of an InlineArray whose storage count is a symbolic value.
func inlineArrayStride<let n: Int, let m: Int, T>(
  _: InlineArray<(n + m), T>.Type
) -> Int {
  MemoryLayout<InlineArray<(n + m), T>>.stride
}
