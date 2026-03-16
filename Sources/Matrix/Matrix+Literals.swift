extension Matrix: ExpressibleByArrayLiteral {
  /// The type of the elements of an array literal.
  public typealias ArrayLiteralElement = [T]

  /// Creates a matrix from a 2D array literal.
  ///
  /// Each inner array represents a row. All rows must have the same number of elements.
  ///
  /// Example:
  /// ```swift
  /// let matrix: Matrix<Int> = [
  ///   [1, 2, 3],
  ///   [4, 5, 6]
  /// ]
  /// ```
  ///
  /// - Parameters:
  ///   - elements: The rows of the matrix.
  public init(arrayLiteral elements: [T]...) {
    precondition(!elements.isEmpty, "Matrix cannot be empty")
    let columnCount = elements[0].count
    precondition(columnCount > 0, "Matrix rows cannot be empty")
    precondition(elements.allSatisfy { $0.count == columnCount }, "All rows must have the same number of columns")

    self.rows = elements.count
    self.columns = columnCount
    self.grid = elements.flatMap { $0 }
  }
}
