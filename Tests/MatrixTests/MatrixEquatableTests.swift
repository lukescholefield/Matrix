import Testing

@testable import Matrix

// MARK: - Equatable Extension Tests

@Test func coordinateOfValue() {
  let matrix = Matrix(rows: 2, columns: 3) { coordinate in
    "\(coordinate.row),\(coordinate.column)"
  }

  let coord = matrix.coordinate(of: "1,2")

  #expect(coord != nil)
  #expect(coord?.row == 1)
  #expect(coord?.column == 2)
}

@Test func coordinateOfValueNotFound() {
  let matrix = Matrix(rows: 2, columns: 2, repeatedValue: "x")

  let coord = matrix.coordinate(of: "y")

  #expect(coord == nil)
}

@Test func allCoordinatesOf() {
  var matrix = Matrix(rows: 3, columns: 3, repeatedValue: 0)
  matrix[0, 0] = 5
  matrix[1, 1] = 5
  matrix[2, 2] = 5

  let coords = matrix.allCoordinates(of: 5)

  #expect(coords.count == 3)
}

@Test func countOf() {
  var matrix = Matrix(rows: 3, columns: 3, repeatedValue: 0)
  matrix[0, 0] = 1
  matrix[1, 1] = 1
  matrix[2, 2] = 1

  #expect(matrix.count(of: 1) == 3)
  #expect(matrix.count(of: 0) == 6)
  #expect(matrix.count(of: 99) == 0)
}

@Test func containsValue() {
  let matrix = Matrix(rows: 2, columns: 2) { coord in
    coord.row * 2 + coord.column
  }

  #expect(matrix.contains(0) == true)
  #expect(matrix.contains(3) == true)
  #expect(matrix.contains(99) == false)
}

@Test func replaceAll() {
  var matrix = Matrix(rows: 2, columns: 2, repeatedValue: 1)
  matrix[0, 0] = 2

  matrix.replaceAll(1, with: 9)

  #expect(matrix[0, 0] == 2)
  #expect(matrix[0, 1] == 9)
  #expect(matrix[1, 0] == 9)
  #expect(matrix[1, 1] == 9)
}

@Test func matrixEquality() {
  let matrix1 = Matrix(rows: 2, columns: 2, repeatedValue: 1)
  let matrix2 = Matrix(rows: 2, columns: 2, repeatedValue: 1)
  let matrix3 = Matrix(rows: 2, columns: 2, repeatedValue: 2)
  let matrix4 = Matrix(rows: 3, columns: 2, repeatedValue: 1)

  #expect(matrix1 == matrix2)
  #expect(matrix1 != matrix3)
  #expect(matrix1 != matrix4)
}

// MARK: - Hashable Tests

@Test func hashableConformance() {
  let matrix1: Matrix<Int> = [
    [1, 2],
    [3, 4],
  ]
  let matrix2: Matrix<Int> = [
    [1, 2],
    [3, 4],
  ]
  let matrix3: Matrix<Int> = [
    [1, 2],
    [3, 5],
  ]

  #expect(matrix1.hashValue == matrix2.hashValue)
  #expect(matrix1.hashValue != matrix3.hashValue)
}

@Test func hashableInSet() {
  let matrix1: Matrix<Int> = [[1, 2], [3, 4]]
  let matrix2: Matrix<Int> = [[1, 2], [3, 4]]
  let matrix3: Matrix<Int> = [[5, 6], [7, 8]]

  var set: Set<Matrix<Int>> = []
  set.insert(matrix1)
  set.insert(matrix2)
  set.insert(matrix3)

  #expect(set.count == 2)
}

@Test func hashableAsDictionaryKey() {
  let matrix1: Matrix<Int> = [[1, 2], [3, 4]]
  let matrix2: Matrix<Int> = [[5, 6], [7, 8]]

  var dict: [Matrix<Int>: String] = [:]
  dict[matrix1] = "first"
  dict[matrix2] = "second"

  #expect(dict[matrix1] == "first")
  #expect(dict[matrix2] == "second")
}
