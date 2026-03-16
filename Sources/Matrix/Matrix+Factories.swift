// MARK: - Factory Methods for Numeric Types

extension Matrix where T: Numeric {
  /// Creates a zero-filled matrix with the specified dimensions.
  ///
  /// - Parameters:
  ///   - rows: Number of rows in the matrix.
  ///   - columns: Number of columns in the matrix.
  /// - Returns: A matrix filled with zeros.
  public static func zero(rows: Int, columns: Int) -> Matrix<T> {
    return Matrix(rows: rows, columns: columns, repeatedValue: 0)
  }

  /// Creates a square identity matrix of the specified size.
  ///
  /// The identity matrix has 1s on the main diagonal and 0s elsewhere.
  ///
  /// - Parameters:
  ///   - size: The number of rows and columns in the square matrix.
  /// - Returns: An identity matrix.
  public static func identity(size: Int) -> Matrix<T> {
    return Matrix(rows: size, columns: size) { coord in
      coord.row == coord.column ? 1 : 0
    }
  }

  /// Creates a diagonal matrix from the given values.
  ///
  /// The resulting matrix has the provided values on the main diagonal and 0s elsewhere.
  ///
  /// - Parameters:
  ///   - values: The values to place on the main diagonal.
  /// - Returns: A square diagonal matrix.
  public static func diagonal(_ values: [T]) -> Matrix<T> {
    let size = values.count
    return Matrix(rows: size, columns: size) { coord in
      coord.row == coord.column ? values[coord.row] : 0
    }
  }

  /// Creates a matrix filled with ones.
  ///
  /// - Parameters:
  ///   - rows: Number of rows in the matrix.
  ///   - columns: Number of columns in the matrix.
  /// - Returns: A matrix filled with ones.
  public static func ones(rows: Int, columns: Int) -> Matrix<T> {
    return Matrix(rows: rows, columns: columns, repeatedValue: 1)
  }
}

// MARK: - Factory Methods for All Types

extension Matrix {
  /// Creates a matrix from a 2D array of values.
  ///
  /// - Parameters:
  ///   - array: A 2D array where each inner array represents a row.
  /// - Returns: A matrix containing the values, or nil if the array is empty or rows have inconsistent lengths.
  public static func from2DArray(_ array: [[T]]) -> Matrix<T>? {
    guard let firstRow = array.first else { return nil }
    let rows = array.count
    let columns = firstRow.count

    guard columns > 0 else { return nil }
    guard array.allSatisfy({ $0.count == columns }) else { return nil }

    return Matrix(rows: rows, columns: columns) { coord in
      array[coord.row][coord.column]
    }
  }

  /// Creates a matrix from a flat array with the specified dimensions.
  ///
  /// - Parameters:
  ///   - array: A flat array of values in row-major order.
  ///   - rows: Number of rows in the matrix.
  ///   - columns: Number of columns in the matrix.
  /// - Returns: A matrix containing the values, or nil if the array size doesn't match dimensions.
  public static func fromArray(_ array: [T], rows: Int, columns: Int) -> Matrix<T>? {
    guard rows >= 0, columns >= 0 else { return nil }
    guard array.count == rows * columns else { return nil }
    return Matrix(rows: rows, columns: columns, grid: array)
  }
}
