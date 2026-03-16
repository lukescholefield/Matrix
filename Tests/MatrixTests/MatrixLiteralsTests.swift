import Testing

@testable import Matrix

// MARK: - Array Literal Tests

@Test func initFromArrayLiteral() {
  let matrix: Matrix<Int> = [
    [1, 2, 3],
    [4, 5, 6],
  ]

  #expect(matrix.rows == 2)
  #expect(matrix.columns == 3)
  #expect(matrix[0, 0] == 1)
  #expect(matrix[0, 2] == 3)
  #expect(matrix[1, 0] == 4)
  #expect(matrix[1, 2] == 6)
}

@Test func initFromArrayLiteralSingleRow() {
  let matrix: Matrix<Int> = [
    [1, 2, 3, 4, 5]
  ]

  #expect(matrix.rows == 1)
  #expect(matrix.columns == 5)
}

@Test func initFromArrayLiteralSingleColumn() {
  let matrix: Matrix<Int> = [
    [1],
    [2],
    [3],
  ]

  #expect(matrix.rows == 3)
  #expect(matrix.columns == 1)
}

@Test func initFromArrayLiteralWithStrings() {
  let matrix: Matrix<String> = [
    ["a", "b"],
    ["c", "d"],
  ]

  #expect(matrix[0, 0] == "a")
  #expect(matrix[1, 1] == "d")
}

@Test func initFromArrayLiteralWithDoubles() {
  let matrix: Matrix<Double> = [
    [1.5, 2.5],
    [3.5, 4.5],
  ]

  #expect(matrix[0, 0] == 1.5)
  #expect(matrix[1, 1] == 4.5)
}

@Test func initFromArrayLiteralSquareMatrix() {
  let matrix: Matrix<Int> = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
  ]

  #expect(matrix.isSquare)
  #expect(matrix.rows == 3)
  #expect(matrix.columns == 3)
}
