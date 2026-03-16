extension Matrix where T: Numeric {
  /// Returns the sum of all elements in the matrix.
  ///
  /// - Returns: The sum of all elements.
  public func sum() -> T {
    return grid.reduce(0, +)
  }

  /// Returns a new matrix with each element scaled by the given factor.
  ///
  /// - Parameters:
  ///   - factor: The scaling factor.
  /// - Returns: A new matrix with scaled elements.
  public func scaled(by factor: T) -> Matrix<T> {
    return map { $0 * factor }
  }

  /// Returns the element-wise addition of two matrices.
  ///
  /// - Parameters:
  ///   - lhs: The first matrix.
  ///   - rhs: The second matrix.
  /// - Returns: A new matrix containing the element-wise sum.
  public static func + (lhs: Matrix<T>, rhs: Matrix<T>) -> Matrix<T> {
    precondition(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "Matrix dimensions must match")
    return Matrix(rows: lhs.rows, columns: lhs.columns) { coord in
      lhs[coord] + rhs[coord]
    }
  }

  /// Returns the element-wise subtraction of two matrices.
  ///
  /// - Parameters:
  ///   - lhs: The first matrix.
  ///   - rhs: The second matrix.
  /// - Returns: A new matrix containing the element-wise difference.
  public static func - (lhs: Matrix<T>, rhs: Matrix<T>) -> Matrix<T> {
    precondition(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "Matrix dimensions must match")
    return Matrix(rows: lhs.rows, columns: lhs.columns) { coord in
      lhs[coord] - rhs[coord]
    }
  }

  /// Returns the element-wise multiplication of two matrices (Hadamard product).
  ///
  /// - Parameters:
  ///   - lhs: The first matrix.
  ///   - rhs: The second matrix.
  /// - Returns: A new matrix containing the element-wise product.
  public static func * (lhs: Matrix<T>, rhs: Matrix<T>) -> Matrix<T> {
    precondition(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "Matrix dimensions must match")
    return Matrix(rows: lhs.rows, columns: lhs.columns) { coord in
      lhs[coord] * rhs[coord]
    }
  }

  /// Returns the matrix scaled by a scalar value.
  ///
  /// - Parameters:
  ///   - lhs: The matrix.
  ///   - rhs: The scalar value.
  /// - Returns: A new matrix with each element multiplied by the scalar.
  public static func * (lhs: Matrix<T>, rhs: T) -> Matrix<T> {
    return lhs.scaled(by: rhs)
  }

  /// Returns the matrix scaled by a scalar value.
  ///
  /// - Parameters:
  ///   - lhs: The scalar value.
  ///   - rhs: The matrix.
  /// - Returns: A new matrix with each element multiplied by the scalar.
  public static func * (lhs: T, rhs: Matrix<T>) -> Matrix<T> {
    return rhs.scaled(by: lhs)
  }

  /// Performs matrix multiplication (dot product).
  ///
  /// For an m×n matrix multiplied by an n×p matrix, returns an m×p matrix.
  ///
  /// - Parameters:
  ///   - other: The matrix to multiply with (must have rows equal to this matrix's columns).
  /// - Returns: A new matrix containing the matrix product.
  public func matrixMultiply(_ other: Matrix<T>) -> Matrix<T> {
    precondition(columns == other.rows, "Matrix dimensions incompatible for multiplication: \(rows)x\(columns) * \(other.rows)x\(other.columns)")

    return Matrix(rows: rows, columns: other.columns) { coord in
      var sum: T = 0
      for k in 0..<columns {
        sum = sum + self[coord.row, k] * other[k, coord.column]
      }
      return sum
    }
  }

  /// Alias for `matrixMultiply(_:)`. Performs matrix multiplication (dot product).
  ///
  /// For an m×n matrix multiplied by an n×p matrix, returns an m×p matrix.
  ///
  /// - Parameters:
  ///   - other: The matrix to multiply with (must have rows equal to this matrix's columns).
  /// - Returns: A new matrix containing the matrix product.
  public func dot(_ other: Matrix<T>) -> Matrix<T> {
    return matrixMultiply(other)
  }

  /// Returns the trace of the matrix (sum of diagonal elements).
  ///
  /// The matrix must be square.
  ///
  /// - Returns: The sum of the diagonal elements.
  public func trace() -> T {
    precondition(isSquare, "Trace is only defined for square matrices")
    return diagonal().reduce(0, +)
  }

  /// Adds another matrix to this matrix in place.
  ///
  /// - Parameters:
  ///   - lhs: The matrix to modify.
  ///   - rhs: The matrix to add.
  public static func += (lhs: inout Matrix<T>, rhs: Matrix<T>) {
    precondition(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "Matrix dimensions must match")
    for coord in lhs.coordinates {
      lhs[coord] = lhs[coord] + rhs[coord]
    }
  }

  /// Subtracts another matrix from this matrix in place.
  ///
  /// - Parameters:
  ///   - lhs: The matrix to modify.
  ///   - rhs: The matrix to subtract.
  public static func -= (lhs: inout Matrix<T>, rhs: Matrix<T>) {
    precondition(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "Matrix dimensions must match")
    for coord in lhs.coordinates {
      lhs[coord] = lhs[coord] - rhs[coord]
    }
  }

  /// Scales this matrix by a scalar value in place.
  ///
  /// - Parameters:
  ///   - lhs: The matrix to modify.
  ///   - rhs: The scaling factor.
  public static func *= (lhs: inout Matrix<T>, rhs: T) {
    for coord in lhs.coordinates {
      lhs[coord] = lhs[coord] * rhs
    }
  }
}

extension Matrix where T: SignedNumeric {
  /// Returns a new matrix with each element negated.
  ///
  /// - Returns: A new matrix with negated elements.
  public func negated() -> Matrix<T> {
    return map { -$0 }
  }

  /// Returns the negation of the matrix.
  ///
  /// - Parameters:
  ///   - matrix: The matrix to negate.
  /// - Returns: A new matrix with negated elements.
  public static prefix func - (matrix: Matrix<T>) -> Matrix<T> {
    return matrix.negated()
  }
}

extension Matrix where T: FloatingPoint {
  /// Returns the average of all elements in the matrix.
  ///
  /// - Returns: The average value.
  public func average() -> T {
    precondition(!isEmpty, "Cannot compute average of an empty matrix")
    return sum() / T(count)
  }

  /// Returns the minimum element in the matrix.
  ///
  /// - Returns: The minimum value, or nil if the matrix is empty.
  public func min() -> T? {
    return grid.min()
  }

  /// Returns the maximum element in the matrix.
  ///
  /// - Returns: The maximum value, or nil if the matrix is empty.
  public func max() -> T? {
    return grid.max()
  }

  /// Returns the determinant of the matrix.
  ///
  /// The matrix must be square. Uses LU decomposition for efficiency.
  ///
  /// - Returns: The determinant value.
  public func determinant() -> T {
    precondition(isSquare, "Determinant is only defined for square matrices")

    let n = rows
    if n == 0 { return 1 }
    if n == 1 { return self[0, 0] }
    if n == 2 { return self[0, 0] * self[1, 1] - self[0, 1] * self[1, 0] }

    var matrix = self
    var det: T = 1
    var swaps = 0

    for col in 0..<n {
      var maxRow = col
      for row in (col + 1)..<n {
        if abs(matrix[row, col]) > abs(matrix[maxRow, col]) {
          maxRow = row
        }
      }

      if abs(matrix[maxRow, col]) < T.ulpOfOne {
        return 0
      }

      if maxRow != col {
        matrix.swapRows(col, maxRow)
        swaps += 1
      }

      det = det * matrix[col, col]

      for row in (col + 1)..<n {
        let factor = matrix[row, col] / matrix[col, col]
        for k in col..<n {
          matrix[row, k] = matrix[row, k] - factor * matrix[col, k]
        }
      }
    }

    return swaps % 2 == 0 ? det : -det
  }

  /// Returns the inverse of the matrix, or nil if the matrix is singular.
  ///
  /// The matrix must be square.
  ///
  /// - Returns: The inverse matrix, or nil if the matrix cannot be inverted.
  public func inverse() -> Matrix<T>? {
    precondition(isSquare, "Inverse is only defined for square matrices")

    let n = rows
    if n == 0 { return nil }

    var augmented = Matrix<T>(rows: n, columns: 2 * n) { coord in
      if coord.column < n {
        return self[coord.row, coord.column]
      } else {
        return coord.row == coord.column - n ? 1 : 0
      }
    }

    for col in 0..<n {
      var maxRow = col
      for row in (col + 1)..<n {
        if abs(augmented[row, col]) > abs(augmented[maxRow, col]) {
          maxRow = row
        }
      }

      if abs(augmented[maxRow, col]) < T.ulpOfOne {
        return nil
      }

      if maxRow != col {
        augmented.swapRows(col, maxRow)
      }

      let pivot = augmented[col, col]
      for k in 0..<(2 * n) {
        augmented[col, k] = augmented[col, k] / pivot
      }

      for row in 0..<n {
        if row != col {
          let factor = augmented[row, col]
          for k in 0..<(2 * n) {
            augmented[row, k] = augmented[row, k] - factor * augmented[col, k]
          }
        }
      }
    }

    return Matrix<T>(rows: n, columns: n) { coord in
      augmented[coord.row, coord.column + n]
    }
  }
}

extension Matrix where T: BinaryInteger {
  /// Returns the average of all elements in the matrix.
  ///
  /// - Returns: The average value as a Double.
  public func average() -> Double {
    precondition(!isEmpty, "Cannot compute average of an empty matrix")
    return Double(sum()) / Double(count)
  }

  /// Returns the minimum element in the matrix.
  ///
  /// - Returns: The minimum value, or nil if the matrix is empty.
  public func min() -> T? {
    return grid.min()
  }

  /// Returns the maximum element in the matrix.
  ///
  /// - Returns: The maximum value, or nil if the matrix is empty.
  public func max() -> T? {
    return grid.max()
  }
}
