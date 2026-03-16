import Testing

@testable import Matrix

// MARK: - Numeric Extension Tests

@Test func sum() {
  let matrix = Matrix(rows: 2, columns: 2) { coord in
    coord.row * 2 + coord.column + 1
  }

  #expect(matrix.sum() == 10)
}

@Test func scaled() {
  let matrix = Matrix(rows: 2, columns: 2) { coord in
    coord.row + coord.column + 1
  }

  let scaled = matrix.scaled(by: 3)

  #expect(scaled[0, 0] == 3)
  #expect(scaled[0, 1] == 6)
  #expect(scaled[1, 0] == 6)
  #expect(scaled[1, 1] == 9)
}

@Test func matrixAddition() {
  let a = Matrix(rows: 2, columns: 2, repeatedValue: 1)
  let b = Matrix(rows: 2, columns: 2, repeatedValue: 2)

  let result = a + b

  #expect(result.allSatisfy { $0 == 3 })
}

@Test func matrixSubtraction() {
  let a = Matrix(rows: 2, columns: 2, repeatedValue: 5)
  let b = Matrix(rows: 2, columns: 2, repeatedValue: 2)

  let result = a - b

  #expect(result.allSatisfy { $0 == 3 })
}

@Test func elementWiseMultiplication() {
  let a = Matrix(rows: 2, columns: 2) { coord in
    coord.row + coord.column + 1
  }
  let b = Matrix(rows: 2, columns: 2, repeatedValue: 2)

  let result = a * b

  #expect(result[0, 0] == 2)
  #expect(result[0, 1] == 4)
  #expect(result[1, 0] == 4)
  #expect(result[1, 1] == 6)
}

@Test func scalarMultiplication() {
  let matrix = Matrix(rows: 2, columns: 2, repeatedValue: 3)

  let result1 = matrix * 2
  let result2 = 2 * matrix

  #expect(result1.allSatisfy { $0 == 6 })
  #expect(result2.allSatisfy { $0 == 6 })
}

@Test func matrixMultiplication() {
  let a = Matrix(rows: 2, columns: 3) { coord in
    coord.row * 3 + coord.column + 1
  }
  let b = Matrix(rows: 3, columns: 2) { coord in
    coord.row * 2 + coord.column + 1
  }

  let result = a.matrixMultiply(b)

  #expect(result.rows == 2)
  #expect(result.columns == 2)
  #expect(result[0, 0] == 22)
  #expect(result[0, 1] == 28)
  #expect(result[1, 0] == 49)
  #expect(result[1, 1] == 64)
}

@Test func compoundAssignmentOperators() {
  var matrix = Matrix(rows: 2, columns: 2, repeatedValue: 5)
  let other = Matrix(rows: 2, columns: 2, repeatedValue: 3)

  matrix += other
  #expect(matrix.allSatisfy { $0 == 8 })

  matrix -= other
  #expect(matrix.allSatisfy { $0 == 5 })

  matrix *= 2
  #expect(matrix.allSatisfy { $0 == 10 })
}

@Test func negation() {
  let matrix = Matrix(rows: 2, columns: 2, repeatedValue: 5)

  let negated = -matrix

  #expect(negated.allSatisfy { $0 == -5 })
}

@Test func floatingPointOperations() {
  let matrix = Matrix(rows: 2, columns: 2) { coord in
    Double(coord.row * 2 + coord.column + 1)
  }

  #expect(matrix.average() == 2.5)
  #expect(matrix.min() == 1.0)
  #expect(matrix.max() == 4.0)
}

@Test func integerAverage() {
  let matrix = Matrix(rows: 2, columns: 2) { coord in
    coord.row * 2 + coord.column + 1
  }

  #expect(matrix.average() == 2.5)
}

@Test func integerMinMax() {
  let matrix = Matrix(rows: 2, columns: 2) { coord in
    coord.row * 2 + coord.column + 1
  }

  #expect(matrix.min() == 1)
  #expect(matrix.max() == 4)
}

// MARK: - Trace Tests

@Test func trace() {
  let matrix: Matrix<Int> = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
  ]

  #expect(matrix.trace() == 15)
}

@Test func traceIdentityMatrix() {
  let identity = Matrix<Int>.identity(size: 4)

  #expect(identity.trace() == 4)
}

// MARK: - Dot Product Tests

@Test func dotProduct() {
  let a: Matrix<Int> = [
    [1, 2],
    [3, 4],
  ]
  let b: Matrix<Int> = [
    [5, 6],
    [7, 8],
  ]

  let result = a.dot(b)

  #expect(result[0, 0] == 19)
  #expect(result[0, 1] == 22)
  #expect(result[1, 0] == 43)
  #expect(result[1, 1] == 50)
}

// MARK: - Determinant Tests

@Test func determinant2x2() {
  let matrix: Matrix<Double> = [
    [4.0, 6.0],
    [3.0, 8.0],
  ]

  let det = matrix.determinant()

  #expect(abs(det - 14.0) < 0.0001)
}

@Test func determinant3x3() {
  let matrix: Matrix<Double> = [
    [6.0, 1.0, 1.0],
    [4.0, -2.0, 5.0],
    [2.0, 8.0, 7.0],
  ]

  let det = matrix.determinant()

  #expect(abs(det - (-306.0)) < 0.0001)
}

@Test func determinantIdentity() {
  let identity = Matrix<Double>.identity(size: 3)

  #expect(abs(identity.determinant() - 1.0) < 0.0001)
}

@Test func determinantSingularMatrix() {
  let matrix: Matrix<Double> = [
    [1.0, 2.0, 3.0],
    [4.0, 5.0, 6.0],
    [7.0, 8.0, 9.0],
  ]

  let det = matrix.determinant()

  #expect(abs(det) < 0.0001)
}

// MARK: - Inverse Tests

@Test func inverse2x2() {
  let matrix: Matrix<Double> = [
    [4.0, 7.0],
    [2.0, 6.0],
  ]

  let inverse = matrix.inverse()

  #expect(inverse != nil)

  let product = matrix.dot(inverse!)

  #expect(abs(product[0, 0] - 1.0) < 0.0001)
  #expect(abs(product[0, 1]) < 0.0001)
  #expect(abs(product[1, 0]) < 0.0001)
  #expect(abs(product[1, 1] - 1.0) < 0.0001)
}

@Test func inverse3x3() {
  let matrix: Matrix<Double> = [
    [1.0, 2.0, 3.0],
    [0.0, 1.0, 4.0],
    [5.0, 6.0, 0.0],
  ]

  let inverse = matrix.inverse()

  #expect(inverse != nil)

  let product = matrix.dot(inverse!)
  let identity = Matrix<Double>.identity(size: 3)

  for r in 0..<3 {
    for c in 0..<3 {
      #expect(abs(product[r, c] - identity[r, c]) < 0.0001)
    }
  }
}

@Test func inverseSingularMatrix() {
  let matrix: Matrix<Double> = [
    [1.0, 2.0],
    [2.0, 4.0],
  ]

  let inverse = matrix.inverse()

  #expect(inverse == nil)
}
