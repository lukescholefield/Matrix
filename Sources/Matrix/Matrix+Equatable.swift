extension Matrix where T: Equatable {
  /// Returns the first coordinate of the specified value in the matrix.
  ///
  /// - Parameters:
  ///   - value: The value to search for.
  /// - Returns: Coordinate of the item, or nil if not found.
  public func coordinate(of value: T) -> Coordinate? {
    return firstCoordinate(where: { $0 == value })
  }

  /// Returns all coordinates containing the specified value.
  ///
  /// - Parameters:
  ///   - value: The value to search for.
  /// - Returns: Array of coordinates where the value is found.
  public func allCoordinates(of value: T) -> [Coordinate] {
    return enumerated()
      .filter { $0.value == value }
      .map { $0.coordinate }
  }

  /// Returns the count of elements equal to the specified value.
  ///
  /// - Parameters:
  ///   - value: The value to count.
  /// - Returns: Number of occurrences.
  public func count(of value: T) -> Int {
    return grid.filter { $0 == value }.count
  }

  /// Returns whether the matrix contains the specified value.
  ///
  /// - Parameters:
  ///   - value: The value to search for.
  /// - Returns: True if the value exists in the matrix.
  public func contains(_ value: T) -> Bool {
    return grid.contains(value)
  }

  /// Replaces all occurrences of a value with another value.
  ///
  /// - Parameters:
  ///   - oldValue: The value to replace.
  ///   - newValue: The replacement value.
  public mutating func replaceAll(_ oldValue: T, with newValue: T) {
    for i in grid.indices {
      if grid[i] == oldValue {
        grid[i] = newValue
      }
    }
  }
}

extension Matrix: Equatable where T: Equatable {
  /// Returns whether two matrices are equal.
  ///
  /// Two matrices are equal if they have the same dimensions and all corresponding elements are equal.
  ///
  /// - Parameters:
  ///   - lhs: The first matrix to compare.
  ///   - rhs: The second matrix to compare.
  /// - Returns: True if the matrices are equal.
  public static func == (lhs: Matrix<T>, rhs: Matrix<T>) -> Bool {
    return lhs.rows == rhs.rows && lhs.columns == rhs.columns && lhs.grid == rhs.grid
  }
}

extension Matrix: Hashable where T: Hashable {
  /// Hashes the essential components of this matrix by feeding them into the given hasher.
  ///
  /// - Parameters:
  ///   - hasher: The hasher to use when combining the components of this instance.
  public func hash(into hasher: inout Hasher) {
    hasher.combine(rows)
    hasher.combine(columns)
    hasher.combine(grid)
  }
}
