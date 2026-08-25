//===--- IntegerArithmetic.h - Integer arithmetic helpers -------*- C++ -*-===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2026 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
//===----------------------------------------------------------------------===//

#ifndef SWIFT_AST_INTEGER_ARITHMETIC_H
#define SWIFT_AST_INTEGER_ARITHMETIC_H

#include "swift/AST/Type.h"
#include "llvm/ADT/APInt.h"

namespace swift {

/// The result of evaluating an arithmetic operation on two integer values.
///
/// `overflow` is reported only when requested by
/// `evaluateIntegerArithmetic`; callers performing arbitrary-precision value
/// generic normalization should provide operands wide enough for the result.
struct IntegerArithmeticResult {
  llvm::APInt value;
  bool overflow;
};

/// Evaluate an arithmetic operator shared by literal-expression folding and
/// symbolic integer generic argument normalization. Both operands must have
/// the same bit width.
IntegerArithmeticResult evaluateIntegerArithmetic(
    ArithmeticOperatorKind opKind, const llvm::APInt &lhs,
    const llvm::APInt &rhs, bool isSigned, bool detectOverflow);

/// Evaluate Swift's non-masking shift operators. The result has the bit width
/// of \p lhs; \p rhs may have a different bit width and signedness.
llvm::APInt evaluateIntegerSmartShift(ArithmeticOperatorKind opKind,
                                      const llvm::APInt &lhs,
                                      const llvm::APInt &rhs,
                                      bool lhsIsSigned, bool rhsIsSigned);

} // namespace swift

#endif // SWIFT_AST_INTEGER_ARITHMETIC_H
