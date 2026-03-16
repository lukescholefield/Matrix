import Testing

@testable import Matrix

// MARK: - Zero Matrix Tests

@Test func zeroMatrix() {
  let matrix = Matrix<Int>.zero(rows: 3, columns: 4)

  #expect(matrix.rows == 3)
  #expect(matrix.columns == 4)
  #expect(matrix.allSatisfy { $0 == 0 })
}

@Test func zeroMatrixDouble() {
  let matrix = Matrix<Double>.zero(rows: 2, columns: 2)

  #expect(matrix[0, 0] == 0.0)
  #expect(matrix[1, 1] == 0.0)
}

// MARK: - Identity Matrix Tests

@Test func identityMatrix() {
  let matrix = Matrix<Int>.identity(size: 3)

  #expect(matrix.rows == 3)
  #expect(matrix.columns == 3)
  #expect(matrix[0, 0] == 1)
  #expect(matrix[1, 1] == 1)
  #expect(matrix[2, 2] == 1)
  #expect(matrix[0, 1] == 0)
  #expect(matrix[1, 0] == 0)
}

@Test func identityMatrixDouble() {
  let matrix = Matrix<Double>.identity(size: 2)

  #expect(matrix[0, 0] == 1.0)
  #expect(matrix[0, 1] == 0.0)
  #expect(matrix[1, 0] == 0.0)
  #expect(matrix[1, 1] == 1.0)
}

// MARK: - Diagonal Matrix Tests

@Test func diagonalMatrix() {
  let matrix = Matrix<Int>.diagonal([1, 2, 3])

  #expect(matrix.rows == 3)
  #expect(matrix.columns == 3)
  #expect(matrix[0, 0] == 1)
  #expect(matrix[1, 1] == 2)
  #expect(matrix[2, 2] == 3)
  #expect(matrix[0, 1] == 0)
  #expect(matrix[1, 2] == 0)
}

// MARK: - Ones Matrix Tests

@Test func onesMatrix() {
  let matrix = Matrix<Int>.ones(rows: 2, columns: 3)

  #expect(matrix.rows == 2)
  #expect(matrix.columns == 3)
  #expect(matrix.allSatisfy { $0 == 1 })
}

// MARK: - From 2D Array Tests

@Test func from2DArray() {
  let array = [[1, 2, 3], [4, 5, 6]]
  let matrix = Matrix.from2DArray(array)

  #expect(matrix != nil)
  #expect(matrix?.rows == 2)
  #expect(matrix?.columns == 3)
  #expect(matrix?[0, 0] == 1)
  #expect(matrix?[1, 2] == 6)
}

@Test func from2DArrayEmpty() {
  let array: [[Int]] = []
  let matrix = Matrix.from2DArray(array)

  #expect(matrix == nil)
}

@Test func from2DArrayInconsistentRows() {
  let array = [[1, 2, 3], [4, 5]]
  let matrix = Matrix.from2DArray(array)

  #expect(matrix == nil)
}

// MARK: - From Array Tests

@Test func fromArray() {
  let array = [1, 2, 3, 4, 5, 6]
  let matrix = Matrix.fromArray(array, rows: 2, columns: 3)

  #expect(matrix != nil)
  #expect(matrix?.rows == 2)
  #expect(matrix?.columns == 3)
  #expect(matrix?[0, 0] == 1)
  #expect(matrix?[1, 2] == 6)
}

@Test func fromArrayInvalidSize() {
  let array = [1, 2, 3, 4, 5]
  let matrix = Matrix.fromArray(array, rows: 2, columns: 3)

  #expect(matrix == nil)
}

@Test func fromArrayNegativeDimensionsReturnsNil() {
  let array = [1, 2, 3]

  #expect(Matrix.fromArray(array, rows: -1, columns: 3) == nil)
  #expect(Matrix.fromArray(array, rows: 1, columns: -3) == nil)
}

@Test func fromArrayEmptyMatrix() {
  let array: [Int] = []
  let matrix = Matrix.fromArray(array, rows: 0, columns: 0)

  #expect(matrix != nil)
  #expect(matrix?.rows == 0)
  #expect(matrix?.columns == 0)
  #expect(matrix?.count == 0)
}
