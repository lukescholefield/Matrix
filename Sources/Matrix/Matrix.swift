/// Struct representing a 2D grid of arbitrary size.
public struct Matrix<T> {
  /// Coordinate of item in the matrix, comprised of row and column.
  public typealias Coordinate = (row: Int, column: Int)
  
  /// Tuple containing a coordinate and its associated value, used by `enumerated()`.
  public typealias EnumeratedTuple = (coordinate: Coordinate, value: T)
  
  // MARK: - Public Properties
  
  /// The number of rows in the matrix.
  public let rows: Int
  
  /// The number of columns in the matrix.
  public let columns: Int
  
  /// The dimensions of the matrix as a tuple.
  public var size: (rows: Int, columns: Int) {
    return (rows: rows, columns: columns)
  }
  
  /// Whether the matrix is square (equal rows and columns).
  public var isSquare: Bool {
    return rows == columns
  }
  
  /// Whether the matrix is empty (has no elements).
  public var isEmpty: Bool {
    return count == 0
  }
  
  /// The range of valid row indices.
  public var rowIndices: Range<Int> {
    return 0..<rows
  }
  
  /// The range of valid column indices.
  public var columnIndices: Range<Int> {
    return 0..<columns
  }

  /// Complete list of elements in the matrix.
  ///
  /// The elements will be ordered, outputting the first row r0c0 -> r0cN, followed by subsequent rows.
  public var elements: [T] {
    return grid
  }
  
  /// Total number of elements in the matrix.
  public var count: Int {
    return rows * columns
  }
  
  /// Complete list of coordinates in the matrix.
  ///
  /// The coordinates will be ordered, outputting the first row r0c0 -> r0cN, followed by subsequent rows.
  public var coordinates: [Coordinate] {
    return grid.indices.map {
      let row = $0 / columns
      let column = $0 % columns
      return Coordinate(row: row, column: column)
    }
  }
  
  // MARK: - Internal Properties

  /// The backing array storing the elements of the matrix.
  internal var grid: [T]
  
  /// Internal initializer that constructs a matrix from a validated backing grid.
  ///
  /// - Parameters:
  ///   - rows: Number of rows in the matrix.
  ///   - columns: Number of columns in the matrix.
  ///   - grid: Backing storage in row-major order.
  internal init(rows: Int, columns: Int, grid: [T]) {
    precondition(rows >= 0, "Rows must be non-negative")
    precondition(columns >= 0, "Columns must be non-negative")
    precondition(grid.count == rows * columns, "Grid size must match matrix dimensions")
    self.rows = rows
    self.columns = columns
    self.grid = grid
  }
  
  // MARK: - Initialization
  
  /// Initializer that sets all values to a provided initial value.
  ///
  /// - Parameters:
  ///   - rows: Number of rows in the matrix.
  ///   - columns: Number of columns in the matrix.
  ///   - repeatedValue: The repeated value to set to every element.
  public init(rows: Int, columns: Int, repeatedValue: T) {
    precondition(rows >= 0, "Rows must be non-negative")
    precondition(columns >= 0, "Columns must be non-negative")
    self.rows = rows
    self.columns = columns
    grid = [T](repeating: repeatedValue, count: rows * columns)
  }

  /// Initializer where values can be set using a closure.
  ///
  /// - Parameters:
  ///   - rows: Number of rows in the matrix.
  ///   - columns: Number of columns in the matrix.
  ///   - values: Closure used to generate values based on coordinate.
  public init(rows: Int, columns: Int, values: (Coordinate) -> T) {
    precondition(rows >= 0, "Rows must be non-negative")
    precondition(columns >= 0, "Columns must be non-negative")
    self.rows = rows
    self.columns = columns

    let elementCount = rows * columns
    grid = (0..<elementCount).map { (i: Int) -> T in
      let row = i / columns
      let column = i % columns
      return values((row: row, column: column))
    }
  }

  // MARK: - Core

  /// Checks to see if row, column constitute a valid coordinate in the matrix.
  ///
  /// - Parameters:
  ///   - row: The index of the row.
  ///   - column: The index of the column.
  /// - Returns: True if the coordinate is valid.
  public func isValidCoordinate(row: Int, column: Int) -> Bool {
    return rowIndices ~= row && columnIndices ~= column
  }

  /// Allows values to be referenced by matrix[row, column]
  ///
  /// - Parameters:
  ///   - row: The index of the row for the item.
  ///   - column: The index of the column for the item.
  public subscript(row: Int, column: Int) -> T {
    get {
      precondition(isValidIndex(row: row, column: column), "Index out of range")
      return grid[(row * columns) + column]
    }
    mutating set {
      precondition(isValidIndex(row: row, column: column), "Index out of range")
      grid[(row * columns) + column] = newValue
    }
  }

  /// Allows values to be referenced by matrix[coordinate]
  ///
  /// - Parameters:
  ///   - coordinate: The value containing the row and column for the item.
  public subscript(coordinate: Coordinate) -> T {
    get {
      return self[coordinate.row, coordinate.column]
    }
    mutating set {
      self[coordinate.row, coordinate.column] = newValue
    }
  }

  /// Returns the first coordinate where the element matches the predicate.
  ///
  /// - Parameters:
  ///   - predicate: A closure that takes an element and returns true if it matches.
  /// - Returns: Coordinate of the first matching element, or nil if not found.
  public func firstCoordinate(where predicate: (T) -> Bool) -> Coordinate? {
    guard let index = grid.firstIndex(where: predicate) else {
      return nil
    }

    let row = index / columns
    let column = index % columns

    return (row: row, column: column)
  }

  // MARK: - Helpers

  /// Generate a new matrix by applying transform to each element and coordinate of this matrix.
  ///
  /// - Parameters:
  ///   - transform: Transform to apply.
  /// - Returns: The newly initialized matrix.
  public func map<U>(_ transform: (_ coordinate: Coordinate, _ element: T) -> U) -> Matrix<U> {
    return Matrix<U>(rows: rows, columns: columns) { (c: Coordinate) -> U in
      let e = self[c.row, c.column]
      return transform(c, e)
    }
  }

  /// Generate a new matrix by applying transform to each coordinate of this matrix.
  ///
  /// - Parameters:
  ///   - transform: Transform to apply.
  /// - Returns: The newly initialized matrix.
  public func map<U>(_ transform: (_ coordinate: Coordinate) -> U) -> Matrix<U> {
    return map { (coordinate, element) -> U in
      return transform(coordinate)
    }
  }

  /// Generate a new matrix by applying transform to each element of this matrix.
  ///
  /// - Parameters:
  ///   - transform: Transform to apply.
  /// - Returns: The newly initialized matrix.
  public func map<U>(_ transform: (_ element: T) -> U) -> Matrix<U> {
    return map { (coordinate, element) -> U in
      return transform(element)
    }
  }

  /// Returns an array of tuples containing each coordinate and its value.
  ///
  /// Similar to `Array.enumerated()`, but returns coordinates instead of indices.
  public func enumerated() -> [EnumeratedTuple] {
    return coordinates.map { m in
      (coordinate: m, value: self[m])
    }
  }
  
  // MARK: - Iteration & Access
  
  /// Returns all elements in the specified row.
  ///
  /// - Parameters:
  ///   - index: The row index.
  /// - Returns: Array of elements in the row.
  public func row(_ index: Int) -> [T] {
    precondition(rowIndices ~= index, "Row index out of range")
    return (0..<columns).map { self[index, $0] }
  }
  
  /// Returns all elements in the specified column.
  ///
  /// - Parameters:
  ///   - index: The column index.
  /// - Returns: Array of elements in the column.
  public func column(_ index: Int) -> [T] {
    precondition(columnIndices ~= index, "Column index out of range")
    return (0..<rows).map { self[$0, index] }
  }
  
  /// Returns the main diagonal elements (top-left to bottom-right).
  ///
  /// - Returns: Array of diagonal elements.
  public func diagonal() -> [T] {
    let diagonalCount = Swift.min(rows, columns)
    return (0..<diagonalCount).map { self[$0, $0] }
  }
  
  /// Returns the anti-diagonal elements (top-right to bottom-left).
  ///
  /// - Returns: Array of anti-diagonal elements.
  public func antiDiagonal() -> [T] {
    let diagonalCount = Swift.min(rows, columns)
    return (0..<diagonalCount).map { self[$0, columns - 1 - $0] }
  }
  
  /// Iterates over each element with its coordinate.
  ///
  /// - Parameters:
  ///   - body: Closure to execute for each element.
  public func forEach(_ body: (Coordinate, T) -> Void) {
    for coord in coordinates {
      body(coord, self[coord])
    }
  }
  
  // MARK: - Transformation
  
  /// Returns a new matrix with rows and columns swapped.
  ///
  /// - Returns: The transposed matrix.
  public func transposed() -> Matrix<T> {
    return Matrix(rows: columns, columns: rows) { coord in
      self[coord.column, coord.row]
    }
  }
  
  /// Returns a new matrix flipped horizontally (mirrored left-to-right).
  ///
  /// - Returns: The horizontally flipped matrix.
  public func flippedHorizontally() -> Matrix<T> {
    return Matrix(rows: rows, columns: columns) { coord in
      self[coord.row, columns - 1 - coord.column]
    }
  }
  
  /// Returns a new matrix flipped vertically (mirrored top-to-bottom).
  ///
  /// - Returns: The vertically flipped matrix.
  public func flippedVertically() -> Matrix<T> {
    return Matrix(rows: rows, columns: columns) { coord in
      self[rows - 1 - coord.row, coord.column]
    }
  }
  
  /// Returns a new matrix rotated 90 degrees clockwise.
  ///
  /// - Returns: The rotated matrix.
  public func rotated90Clockwise() -> Matrix<T> {
    return Matrix(rows: columns, columns: rows) { coord in
      self[rows - 1 - coord.column, coord.row]
    }
  }
  
  /// Returns a new matrix rotated 90 degrees counter-clockwise.
  ///
  /// - Returns: The rotated matrix.
  public func rotated90CounterClockwise() -> Matrix<T> {
    return Matrix(rows: columns, columns: rows) { coord in
      self[coord.column, columns - 1 - coord.row]
    }
  }
  
  /// Returns a new matrix rotated 180 degrees.
  ///
  /// - Returns: The rotated matrix.
  public func rotated180() -> Matrix<T> {
    return Matrix(rows: rows, columns: columns) { coord in
      self[rows - 1 - coord.row, columns - 1 - coord.column]
    }
  }
  
  // MARK: - Submatrices
  
  /// Extracts a submatrix from the specified ranges.
  ///
  /// - Parameters:
  ///   - rowRange: Range of rows to include.
  ///   - columnRange: Range of columns to include.
  /// - Returns: A new matrix containing the specified region.
  public func submatrix(rowRange: Range<Int>, columnRange: Range<Int>) -> Matrix<T> {
    precondition(rowRange.lowerBound >= 0 && rowRange.upperBound <= rows, "Row range out of bounds")
    precondition(columnRange.lowerBound >= 0 && columnRange.upperBound <= columns, "Column range out of bounds")
    
    return Matrix(rows: rowRange.count, columns: columnRange.count) { coord in
      self[rowRange.lowerBound + coord.row, columnRange.lowerBound + coord.column]
    }
  }
  
  /// Returns the neighboring elements of the specified coordinate.
  ///
  /// - Parameters:
  ///   - coordinate: The center coordinate.
  ///   - includeDiagonals: Whether to include diagonal neighbors.
  /// - Returns: Array of neighboring elements.
  public func neighbors(of coordinate: Coordinate, includeDiagonals: Bool = true) -> [T] {
    return neighborCoordinates(of: coordinate, includeDiagonals: includeDiagonals).map { self[$0] }
  }
  
  /// Returns the neighboring coordinates of the specified coordinate.
  ///
  /// - Parameters:
  ///   - coordinate: The center coordinate.
  ///   - includeDiagonals: Whether to include diagonal neighbors.
  /// - Returns: Array of valid neighboring coordinates.
  public func neighborCoordinates(of coordinate: Coordinate, includeDiagonals: Bool = true) -> [Coordinate] {
    let orthogonalOffsets = [(-1, 0), (1, 0), (0, -1), (0, 1)]
    let diagonalOffsets = [(-1, -1), (-1, 1), (1, -1), (1, 1)]
    
    let offsets = includeDiagonals ? orthogonalOffsets + diagonalOffsets : orthogonalOffsets
    
    return offsets.compactMap { offset in
      let newRow = coordinate.row + offset.0
      let newCol = coordinate.column + offset.1
      guard isValidCoordinate(row: newRow, column: newCol) else { return nil }
      return (row: newRow, column: newCol)
    }
  }
  
  // MARK: - Queries
  
  /// Returns whether any element satisfies the given predicate.
  ///
  /// - Parameters:
  ///   - predicate: A closure that takes an element and returns a Boolean.
  /// - Returns: True if any element satisfies the predicate.
  public func contains(where predicate: (T) -> Bool) -> Bool {
    return grid.contains(where: predicate)
  }
  
  /// Returns whether all elements satisfy the given predicate.
  ///
  /// - Parameters:
  ///   - predicate: A closure that takes an element and returns a Boolean.
  /// - Returns: True if all elements satisfy the predicate.
  public func allSatisfy(_ predicate: (T) -> Bool) -> Bool {
    return grid.allSatisfy(predicate)
  }
  
  /// Returns the first element that satisfies the given predicate.
  ///
  /// - Parameters:
  ///   - predicate: A closure that takes an element and returns a Boolean.
  /// - Returns: The first matching element, or nil if none found.
  public func first(where predicate: (T) -> Bool) -> T? {
    return grid.first(where: predicate)
  }
  
  /// Returns all elements with their coordinates that satisfy the given predicate.
  ///
  /// - Parameters:
  ///   - predicate: A closure that takes an element and returns a Boolean.
  /// - Returns: Array of tuples containing coordinates and matching elements.
  public func filter(_ predicate: (T) -> Bool) -> [(Coordinate, T)] {
    return enumerated().filter { predicate($0.value) }.map { ($0.coordinate, $0.value) }
  }
  
  // MARK: - Mutation
  
  /// Fills all elements with the specified value.
  ///
  /// - Parameters:
  ///   - value: The value to fill with.
  public mutating func fill(with value: T) {
    grid = [T](repeating: value, count: count)
  }
  
  /// Fills the specified row with the given value.
  ///
  /// - Parameters:
  ///   - rowIndex: The row to fill.
  ///   - value: The value to fill with.
  public mutating func fillRow(_ rowIndex: Int, with value: T) {
    precondition(rowIndices ~= rowIndex, "Row index out of range")
    for col in columnIndices {
      self[rowIndex, col] = value
    }
  }
  
  /// Fills the specified column with the given value.
  ///
  /// - Parameters:
  ///   - columnIndex: The column to fill.
  ///   - value: The value to fill with.
  public mutating func fillColumn(_ columnIndex: Int, with value: T) {
    precondition(columnIndices ~= columnIndex, "Column index out of range")
    for row in rowIndices {
      self[row, columnIndex] = value
    }
  }
  
  /// Swaps two rows in the matrix.
  ///
  /// - Parameters:
  ///   - row1: Index of the first row.
  ///   - row2: Index of the second row.
  public mutating func swapRows(_ row1: Int, _ row2: Int) {
    precondition(rowIndices ~= row1 && rowIndices ~= row2, "Row index out of range")
    guard row1 != row2 else { return }
    for col in columnIndices {
      let temp = self[row1, col]
      self[row1, col] = self[row2, col]
      self[row2, col] = temp
    }
  }
  
  /// Swaps two columns in the matrix.
  ///
  /// - Parameters:
  ///   - col1: Index of the first column.
  ///   - col2: Index of the second column.
  public mutating func swapColumns(_ col1: Int, _ col2: Int) {
    precondition(columnIndices ~= col1 && columnIndices ~= col2, "Column index out of range")
    guard col1 != col2 else { return }
    for row in rowIndices {
      let temp = self[row, col1]
      self[row, col1] = self[row, col2]
      self[row, col2] = temp
    }
  }
  
  // MARK: - Row/Column Insertion & Removal
  
  /// Returns a new matrix with a row inserted at the specified index.
  ///
  /// - Parameters:
  ///   - rowValues: The values for the new row.
  ///   - index: The index at which to insert the row.
  /// - Returns: A new matrix with the row inserted.
  public func insertingRow(_ rowValues: [T], at index: Int) -> Matrix<T> {
    precondition(index >= 0 && index <= rows, "Row index out of range")
    precondition(rowValues.count == columns, "Row must have \(columns) elements")
    
    var newGrid = [T]()
    newGrid.reserveCapacity((rows + 1) * columns)
    
    for r in 0..<index {
      newGrid.append(contentsOf: row(r))
    }
    newGrid.append(contentsOf: rowValues)
    for r in index..<rows {
      newGrid.append(contentsOf: row(r))
    }
    
    return Matrix(rows: rows + 1, columns: columns, grid: newGrid)
  }
  
  /// Returns a new matrix with a column inserted at the specified index.
  ///
  /// - Parameters:
  ///   - columnValues: The values for the new column.
  ///   - index: The index at which to insert the column.
  /// - Returns: A new matrix with the column inserted.
  public func insertingColumn(_ columnValues: [T], at index: Int) -> Matrix<T> {
    precondition(index >= 0 && index <= columns, "Column index out of range")
    precondition(columnValues.count == rows, "Column must have \(rows) elements")
    
    return Matrix(rows: rows, columns: columns + 1) { coord in
      if coord.column < index {
        return self[coord.row, coord.column]
      } else if coord.column == index {
        return columnValues[coord.row]
      } else {
        return self[coord.row, coord.column - 1]
      }
    }
  }
  
  /// Returns a new matrix with the row at the specified index removed.
  ///
  /// - Parameters:
  ///   - index: The index of the row to remove.
  /// - Returns: A new matrix without the specified row.
  public func removingRow(at index: Int) -> Matrix<T> {
    precondition(index >= 0 && index < rows, "Row index out of range")
    precondition(rows > 1, "Cannot remove the only row")
    
    var newGrid = [T]()
    newGrid.reserveCapacity((rows - 1) * columns)
    
    for r in 0..<rows where r != index {
      newGrid.append(contentsOf: row(r))
    }
    
    return Matrix(rows: rows - 1, columns: columns, grid: newGrid)
  }
  
  /// Returns a new matrix with the column at the specified index removed.
  ///
  /// - Parameters:
  ///   - index: The index of the column to remove.
  /// - Returns: A new matrix without the specified column.
  public func removingColumn(at index: Int) -> Matrix<T> {
    precondition(index >= 0 && index < columns, "Column index out of range")
    precondition(columns > 1, "Cannot remove the only column")
    
    return Matrix(rows: rows, columns: columns - 1) { coord in
      if coord.column < index {
        return self[coord.row, coord.column]
      } else {
        return self[coord.row, coord.column + 1]
      }
    }
  }
  
  /// Returns a new matrix with a row appended at the end.
  ///
  /// - Parameters:
  ///   - rowValues: The values for the new row.
  /// - Returns: A new matrix with the row appended.
  public func appendingRow(_ rowValues: [T]) -> Matrix<T> {
    return insertingRow(rowValues, at: rows)
  }
  
  /// Returns a new matrix with a column appended at the end.
  ///
  /// - Parameters:
  ///   - columnValues: The values for the new column.
  /// - Returns: A new matrix with the column appended.
  public func appendingColumn(_ columnValues: [T]) -> Matrix<T> {
    return insertingColumn(columnValues, at: columns)
  }
  
  // MARK: - Reshaping
  
  /// Returns a new matrix with the same elements but different dimensions.
  ///
  /// The total number of elements must remain the same.
  ///
  /// - Parameters:
  ///   - newRows: The number of rows in the reshaped matrix.
  ///   - newColumns: The number of columns in the reshaped matrix.
  /// - Returns: A reshaped matrix, or nil if dimensions are incompatible.
  public func reshaped(rows newRows: Int, columns newColumns: Int) -> Matrix<T>? {
    guard newRows >= 0, newColumns >= 0 else { return nil }
    guard newRows * newColumns == count else { return nil }
    return Matrix(rows: newRows, columns: newColumns, grid: grid)
  }
  
  /// Returns the elements of the matrix as a 2D array.
  ///
  /// Each inner array represents a row.
  ///
  /// - Returns: A 2D array of the matrix elements.
  public func to2DArray() -> [[T]] {
    return (0..<rows).map { row($0) }
  }
  
  // MARK: - Range-Based Subscripts
  
  /// Accesses a submatrix using row and column ranges.
  ///
  /// - Parameters:
  ///   - rowRange: The range of rows.
  ///   - columnRange: The range of columns.
  /// - Returns: A submatrix containing the specified region.
  public subscript(rowRange: Range<Int>, columnRange: Range<Int>) -> Matrix<T> {
    return submatrix(rowRange: rowRange, columnRange: columnRange)
  }
  
  /// Accesses a submatrix using closed ranges.
  ///
  /// - Parameters:
  ///   - rowRange: The closed range of rows.
  ///   - columnRange: The closed range of columns.
  /// - Returns: A submatrix containing the specified region.
  public subscript(rowRange: ClosedRange<Int>, columnRange: ClosedRange<Int>) -> Matrix<T> {
    return submatrix(rowRange: rowRange.lowerBound..<(rowRange.upperBound + 1),
                     columnRange: columnRange.lowerBound..<(columnRange.upperBound + 1))
  }
  
  // MARK: - Pretty Printing
  
  /// Returns a formatted string representation of the matrix as a grid.
  ///
  /// - Parameters:
  ///   - columnWidth: Minimum width for each column.
  /// - Returns: A formatted string showing the matrix as a grid.
  public func prettyPrinted(columnWidth: Int = 8) -> String {
    precondition(columnWidth > 0, "columnWidth must be greater than zero")
    var result = ""
    
    for r in 0..<rows {
      var rowStr = "│"
      for c in 0..<columns {
        let value = String(describing: self[r, c])
        let padding = Swift.max(0, columnWidth - value.count)
        let leftPad = padding / 2
        let rightPad = padding - leftPad
        rowStr += String(repeating: " ", count: leftPad) + value + String(repeating: " ", count: rightPad)
        if c < columns - 1 {
          rowStr += " "
        }
      }
      rowStr += "│"
      result += rowStr
      if r < rows - 1 {
        result += "\n"
      }
    }
    
    return result
  }
  
  // MARK: - Private Helpers
  
  /// Checks to see if row, column constitute a valid index in the matrix.
  ///
  /// - Parameters:
  ///   - row: The index of the row.
  ///   - column: The index of the column.
  /// - Returns: True if the index is valid.
  private func isValidIndex(row: Int, column: Int) -> Bool {
    return 0 <= row && row < rows && 0 <= column && column < columns
  }
  
  /// Checks to see if the coordinate is a valid index in the matrix.
  ///
  /// - Parameters:
  ///   - coordinate: The value containing the row and column for the item.
  /// - Returns: True if the index is valid.
  private func isValidIndex(coordinate: Coordinate) -> Bool {
    return isValidIndex(row: coordinate.row, column: coordinate.column)
  }
}

extension Matrix: CustomStringConvertible, CustomDebugStringConvertible {
  public var description: String {
    return "Matrix - \(rows) rows, \(columns) columns"
  }

  public var debugDescription: String {
    var result = "Matrix - \(rows) rows, \(columns) columns"

    for coordinate in self.coordinates {
      let element = self[coordinate]
      let elementDescription = "\n    (\(coordinate.row), \(coordinate.column)): \(element)"
      result.append(contentsOf: elementDescription)
    }

    return result
  }
}

// MARK: - Sendable Conformance

extension Matrix: Sendable where T: Sendable {}
