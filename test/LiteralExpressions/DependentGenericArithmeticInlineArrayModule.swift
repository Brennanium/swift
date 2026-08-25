// Cross-module coverage for dependent arithmetic in InlineArray counts.
// REQUIRES: swift_feature_LiteralExpressions
// RUN: %empty-directory(%t)
// RUN: split-file %s %t
// RUN: %target-swift-frontend -emit-module -parse-as-library -module-name ArithmeticInlineArray -emit-module-path %t/ArithmeticInlineArray.swiftmodule -emit-module-interface-path %t/ArithmeticInlineArray.swiftinterface -enable-library-evolution -swift-version 5 -disable-availability-checking -enable-experimental-feature LiteralExpressions %t/ArithmeticInlineArray.swift
// RUN: %FileCheck %s --check-prefix=INTERFACE < %t/ArithmeticInlineArray.swiftinterface
// RUN: %target-swift-typecheck-module-from-interface(%t/ArithmeticInlineArray.swiftinterface) -module-name ArithmeticInlineArray -disable-availability-checking -enable-experimental-feature LiteralExpressions
// RUN: %target-swift-frontend -emit-sil -o /dev/null -I %t -swift-version 5 -disable-availability-checking -enable-experimental-feature LiteralExpressions %t/Client.swift

// INTERFACE: public func orderedCount
// INTERFACE-SAME: Swift::InlineArray<(m + n), T>) -> Swift::InlineArray<(m + n), T>
// INTERFACE: public func orderedScaleCount
// INTERFACE-SAME: Swift::InlineArray<(2 * n), T>) -> Swift::InlineArray<(2 * n), T>

//--- ArithmeticInlineArray.swift
public func orderedCount<let n: Int, let m: Int, T>(
  _ value: InlineArray<(m + n), T>
) -> InlineArray<(m + n), T> {
  value
}

public func orderedScaleCount<let n: Int, T>(
  _ value: InlineArray<(2 * n), T>
) -> InlineArray<(2 * n), T> {
  value
}

//--- Client.swift
import ArithmeticInlineArray

func orderedAcrossModules<let n: Int, let m: Int, T>(
  _ value: InlineArray<(m + n), T>
) -> InlineArray<(m + n), T> {
  orderedCount(value)
}

func orderedScaleAcrossModules<let n: Int, T>(
  _ value: InlineArray<(2 * n), T>
) -> InlineArray<(2 * n), T> {
  orderedScaleCount(value)
}
