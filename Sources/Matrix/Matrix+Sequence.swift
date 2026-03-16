// MARK: - Sequence Conformance

extension Matrix: Sequence {
  /// Returns an iterator over the elements of the matrix in row-major order.
  public func makeIterator() -> IndexingIterator<[T]> {
    return grid.makeIterator()
  }
}
