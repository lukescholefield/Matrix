# Matrix

A Swift package providing a generic 2D matrix data structure with comprehensive functionality for grid-based operations.

## Features

- **Generic Type Support** - Store any type in a matrix.
- **Swift 6 Ready** - Conditional `Sendable` conformance for concurrency safety.
- **Protocol Conformances** - `Sequence`, `Codable`, `Hashable`, `Equatable`, `ExpressibleByArrayLiteral`.
- **Numeric Operations** - Matrix arithmetic, multiplication, determinant, inverse, trace.
- **Transformations** - Transpose, rotate, flip, reshape.
- **Convenient Subscripting** - Access by row/column, coordinate tuple, or ranges.

## Requirements

- Swift 6.0+
- macOS, iOS, tvOS, watchOS, visionOS, Linux

## Installation

### Swift Package Manager

Add the following to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/lukescholefield/Matrix.git", from: "1.0.0")
]
```

Or add it directly in Xcode via File → Add Package Dependencies.

## Usage

### Creating a Matrix

```swift
import Matrix

// From array literal
let matrix: Matrix<Int> = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
]

// With repeated value.
let zeros = Matrix(rows: 3, columns: 3, repeatedValue: 0)

// With closure.
let identity = Matrix(rows: 3, columns: 3) { coord in
    coord.row == coord.column ? 1 : 0
}

// Factory methods.
let identityMatrix = Matrix<Double>.identity(size: 4)
let zeroMatrix = Matrix<Int>.zero(rows: 2, columns: 3)
let diagonalMatrix = Matrix<Int>.diagonal([1, 2, 3])
```

### Accessing Elements

```swift
// By row and column.
let value = matrix[1, 2]

// By coordinate tuple.
let coord: Matrix<Int>.Coordinate = (row: 1, column: 2)
let value = matrix[coord]

// Get entire row or column.
let firstRow = matrix.row(0)        // [1, 2, 3]
let secondColumn = matrix.column(1) // [2, 5, 8]

// Submatrix with ranges.
let submatrix = matrix[0..<2, 1..<3]
```

### Properties

```swift
matrix.rows           // Number of rows.
matrix.columns        // Number of columns.
matrix.count          // Total element count.
matrix.size           // (rows: Int, columns: Int).
matrix.isSquare       // true if rows == columns.
matrix.isEmpty        // true if count == 0.
matrix.elements       // All elements as flat array.
matrix.coordinates    // All coordinates.
matrix.diagonal()     // Main diagonal elements.
```

### Iteration

```swift
// As a sequence (row-major order).
for element in matrix {
    print(element)
}

// With coordinates.
for (coord, value) in matrix.enumerated() {
    print("\(coord): \(value)")
}

// ForEach with closure.
matrix.forEach { coord, value in
    print("\(coord): \(value)")
}
```

### Transformations

```swift
let transposed = matrix.transposed()
let flippedH = matrix.flippedHorizontally()
let flippedV = matrix.flippedVertically()
let rotated = matrix.rotated90Clockwise()
let reshaped = matrix.reshaped(rows: 1, columns: 9)
```

### Numeric Operations

```swift
let a: Matrix<Double> = [[1, 2], [3, 4]]
let b: Matrix<Double> = [[5, 6], [7, 8]]

// Arithmetic
let sum = a + b
let diff = a - b
let scaled = a * 2.0
let hadamard = a * b          // Element-wise.
let product = a.dot(b)        // Matrix multiplication.

// Analysis
let total = a.sum()
let avg = a.average()
let trace = a.trace()
let det = a.determinant()
let inv = a.inverse()         // Returns nil if singular.
```

### Mutation

```swift
var matrix = Matrix(rows: 3, columns: 3, repeatedValue: 0)

matrix[0, 0] = 1
matrix.fill(with: 5)
matrix.fillRow(0, with: 10)
matrix.fillColumn(1, with: 20)
matrix.swapRows(0, 2)
matrix.swapColumns(0, 1)

// Row/column operations (return new matrix)
let withNewRow = matrix.insertingRow([1, 2, 3], at: 1)
let withoutRow = matrix.removingRow(at: 0)
let withAppendedCol = matrix.appendingColumn([1, 2, 3])
```

### Searching

```swift
// With predicate.
if let coord = matrix.firstCoordinate(where: { $0 > 5 }) {
    print("Found at \(coord)")
}

// For Equatable types.
if let coord = matrix.coordinate(of: 5) {
    print("Found 5 at \(coord)")
}

let allFives = matrix.allCoordinates(of: 5)
let count = matrix.count(of: 5)
let hasValue = matrix.contains(5)
```

### Serialization

```swift
// Codable support.
let encoder = JSONEncoder()
let data = try encoder.encode(matrix)

let decoder = JSONDecoder()
let decoded = try decoder.decode(Matrix<Int>.self, from: data)
```

## API Reference

### Core Types

| Type | Description |
|------|-------------|
| `Matrix<T>` | Generic 2D matrix structure |
| `Matrix.Coordinate` | Tuple alias `(row: Int, column: Int)` |
| `Matrix.EnumeratedTuple` | Tuple alias `(coordinate: Coordinate, value: T)` |

### Protocol Conformances

| Protocol | Constraint |
|----------|------------|
| `Sendable` | `T: Sendable` (conditional) |
| `Sequence` | Always |
| `Equatable`, `Hashable` | `T: Equatable` / `T: Hashable` |
| `Codable` | `T: Codable` |
| `ExpressibleByArrayLiteral` | Always |

## Code Formatting

This project uses [swift-format](https://github.com/swiftlang/swift-format) to enforce a consistent code style. The configuration is defined in `.swift-format` at the project root.

To format all source files:

```bash
swift format format --in-place --recursive Sources/ Tests/
```

To check formatting without modifying files:

```bash
swift format lint --recursive Sources/ Tests/
```

## License

MIT License - see [LICENSE](LICENSE) for details.
