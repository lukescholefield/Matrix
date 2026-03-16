# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2026-03-15

### Added

- Core `Matrix<T>` struct with generic type support
- Conditional `Sendable` conformance when `T: Sendable`
- Protocol conformances:
  - `Sequence`
  - `Equatable`, `Hashable` (where `T` conforms)
  - `Codable` (where `T` conforms)
  - `ExpressibleByArrayLiteral`
  - `CustomStringConvertible`, `CustomDebugStringConvertible`
- Initialization:
  - `init(rows:columns:repeatedValue:)`
  - `init(rows:columns:values:)` with closure
  - Array literal syntax
- Factory methods:
  - `Matrix.zero(rows:columns:)`
  - `Matrix.ones(rows:columns:)`
  - `Matrix.identity(size:)`
  - `Matrix.diagonal(_:)`
  - `Matrix.from2DArray(_:)`
  - `Matrix.fromArray(_:rows:columns:)`
- Properties:
  - `rows`, `columns`, `count`, `size`
  - `isSquare`, `isEmpty`
  - `rowIndices`, `columnIndices`
  - `elements`, `coordinates`
- Subscript access:
  - By row/column indices
  - By `Coordinate` tuple
  - By `Range` and `ClosedRange`
- Iteration & access:
  - `row(_:)`, `column(_:)`
  - `diagonal()`, `antiDiagonal()`
  - `enumerated()`, `forEach(_:)`
- Transformations:
  - `transposed()`
  - `flippedHorizontally()`, `flippedVertically()`
  - `rotated90Clockwise()`, `rotated90CounterClockwise()`, `rotated180()`
  - `reshaped(rows:columns:)`
  - `to2DArray()`
- Submatrices:
  - `submatrix(rowRange:columnRange:)`
  - `neighbors(of:includeDiagonals:)`
  - `neighborCoordinates(of:includeDiagonals:)`
- Queries:
  - `contains(where:)`, `allSatisfy(_:)`, `first(where:)`, `filter(_:)`
  - `isValidCoordinate(row:column:)`
  - `firstCoordinate(where:)`
- Mutation:
  - `fill(with:)`, `fillRow(_:with:)`, `fillColumn(_:with:)`
  - `swapRows(_:_:)`, `swapColumns(_:_:)`
  - `insertingRow(_:at:)`, `insertingColumn(_:at:)`
  - `removingRow(at:)`, `removingColumn(at:)`
  - `appendingRow(_:)`, `appendingColumn(_:)`
- Equatable extensions:
  - `coordinate(of:)`, `allCoordinates(of:)`
  - `count(of:)`, `contains(_:)`
  - `replaceAll(_:with:)`
- Numeric extensions:
  - `sum()`, `scaled(by:)`
  - `+`, `-`, `*` operators (element-wise and scalar)
  - `+=`, `-=`, `*=` compound assignment
  - `dot(_:)`, `matrixMultiply(_:)`
  - `trace()`
  - `negated()`, prefix `-`
- FloatingPoint extensions:
  - `average()`, `min()`, `max()`
  - `determinant()`, `inverse()`
- BinaryInteger extensions:
  - `average()`, `min()`, `max()`
- `prettyPrinted(columnWidth:)` for formatted output
- Comprehensive test suite (133 tests)

[Unreleased]: https://github.com/lukescholefield/Matrix/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/lukescholefield/Matrix/releases/tag/v1.0.0
