# Contributing to Matrix

Thank you for your interest in contributing to Matrix! This document outlines the guidelines and expectations for contributions.

## Getting Started

1. Fork the repository
2. Clone your fork locally
3. Create a branch for your changes
4. Make your changes following the guidelines below
5. Run tests to ensure everything passes
6. Submit a pull request

## Development Setup

```bash
# Clone the repository
git clone https://github.com/lukescholefield/Matrix.git
cd Matrix

# Set up git hooks (enables pre-commit format check)
git config core.hooksPath .githooks

# Build the package
swift build

# Run tests
swift test
```

## Code Style

### Documentation

All public APIs must be documented using Swift documentation comments. Follow these conventions:

**Single-line summaries** for simple properties:

```swift
/// The number of rows in the matrix.
public let rows: Int
```

**Multi-line documentation** for methods with parameters:

```swift
/// Returns all elements in the specified row.
///
/// - Parameters:
///   - index: The row index.
/// - Returns: Array of elements in the row.
public func row(_ index: Int) -> [T] {
```

**Key documentation requirements:**

- Every `public` type, property, method, and function must have a documentation comment
- Use `/// - Parameters:` format (multi-line style), not `/// - Parameter name:` (single-line style)
- Include `- Returns:` for non-void return types
- Include `- Throws:` if the method can throw
- Document any preconditions or assertions

### Comments

- **Do not** add comments that simply narrate what code does
- **Do** add comments explaining non-obvious intent, trade-offs, or constraints
- Use `// MARK: -` to organize code sections

**Bad:**

```swift
// Increment the counter.
counter += 1

// Return the result.
return result
```

**Good:**

```swift
// Use row-major order to match standard mathematical notation.
let index = row * columns + column
```

### Formatting

This project uses [swift-format](https://github.com/swiftlang/swift-format) to enforce a consistent code style. The configuration is defined in `.swift-format` at the project root.

A pre-commit hook in `.githooks/pre-commit` will check formatting automatically when you commit. Set it up with:

```bash
git config core.hooksPath .githooks
```

To format all files manually:

```bash
swift format format --in-place --recursive Sources/ Tests/
```

Additional style conventions:

- Use 2-space indentation
- No trailing whitespace
- One blank line between method definitions
- Use `// MARK: - Section Name` for logical groupings

## Testing Requirements

### Test Coverage

All new functionality must include tests. Follow these guidelines:

1. **Every public API must have at least one test**
2. **Test both success and failure cases** where applicable
3. **Test edge cases** (empty matrices, single element, large matrices)
4. **Test type constraints** (e.g., Numeric operations only work with Numeric types)

### Test Organization

Tests are organized to mirror the source file structure:

| Source File | Test File |
|-------------|-----------|
| `Matrix.swift` | `MatrixTests.swift` |
| `Matrix+Equatable.swift` | `MatrixEquatableTests.swift` |
| `Matrix+Numeric.swift` | `MatrixNumericTests.swift` |
| `Matrix+Sequence.swift` | `MatrixSequenceTests.swift` |
| `Matrix+Codable.swift` | `MatrixCodableTests.swift` |
| `Matrix+Factories.swift` | `MatrixFactoriesTests.swift` |
| `Matrix+Literals.swift` | `MatrixLiteralsTests.swift` |

### Test Style

Use the Swift Testing framework with descriptive test function names:

```swift
import Testing
@testable import Matrix

@Test func transposedSwapsRowsAndColumns() {
    let matrix: Matrix<Int> = [
        [1, 2, 3],
        [4, 5, 6]
    ]
    
    let transposed = matrix.transposed()
    
    #expect(transposed.rows == 3)
    #expect(transposed.columns == 2)
    #expect(transposed[0, 0] == 1)
    #expect(transposed[0, 1] == 4)
}
```

**Test naming conventions:**

- Use descriptive names that explain what is being tested
- Start with the method/property name being tested
- Include the expected behavior or condition

### Running Tests

```bash
# Run all tests
swift test

# Run tests with verbose output
swift test --verbose
```

All tests must pass before a pull request will be merged.

## Pull Request Process

1. **Update documentation** for any changed public APIs
2. **Add tests** for new functionality
3. **Run the full test suite** and ensure all tests pass
4. **Update CHANGELOG.md** with your changes under `[Unreleased]`
5. **Keep commits focused** - one logical change per commit
6. **Write clear commit messages** explaining the "why"

### Commit Message Format

```
Brief summary of the change (50 chars or less)

More detailed explanation if necessary. Wrap at 72 characters.
Explain the problem this commit solves and why this approach
was chosen.
```

## Adding New Features

When adding new functionality:

1. **Consider the API surface** - Is this something most users would need?
2. **Follow existing patterns** - Look at similar functionality for guidance
3. **Use protocol extensions** - Add functionality via extensions where appropriate (e.g., `Numeric`, `Equatable`)
4. **Create separate files** for distinct functionality areas
5. **Add comprehensive tests** in the corresponding test file

## Questions?

If you have questions about contributing, feel free to open an issue for discussion.
