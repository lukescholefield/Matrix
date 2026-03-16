import Testing
@testable import Matrix

// MARK: - Initialization Tests

@Test func initWithRepeatedValue() {
    let matrix = Matrix(rows: 3, columns: 4, repeatedValue: 0)
    
    #expect(matrix.rows == 3)
    #expect(matrix.columns == 4)
    #expect(matrix.count == 12)
    #expect(matrix.elements == Array(repeating: 0, count: 12))
}

@Test func initWithClosure() {
    let matrix = Matrix(rows: 2, columns: 3) { coordinate in
        coordinate.row * 10 + coordinate.column
    }
    
    #expect(matrix.rows == 2)
    #expect(matrix.columns == 3)
    #expect(matrix[0, 0] == 0)
    #expect(matrix[0, 1] == 1)
    #expect(matrix[0, 2] == 2)
    #expect(matrix[1, 0] == 10)
    #expect(matrix[1, 1] == 11)
    #expect(matrix[1, 2] == 12)
}

@Test func initWithSingleElement() {
    let matrix = Matrix(rows: 1, columns: 1, repeatedValue: "single")
    
    #expect(matrix.rows == 1)
    #expect(matrix.columns == 1)
    #expect(matrix.count == 1)
    #expect(matrix[0, 0] == "single")
}

// MARK: - Properties Tests

@Test func rowIndices() {
    let matrix = Matrix(rows: 5, columns: 3, repeatedValue: 0)
    
    #expect(matrix.rowIndices == 0..<5)
}

@Test func columnIndices() {
    let matrix = Matrix(rows: 3, columns: 7, repeatedValue: 0)
    
    #expect(matrix.columnIndices == 0..<7)
}

@Test func elements() {
    let matrix = Matrix(rows: 2, columns: 2) { coordinate in
        coordinate.row * 2 + coordinate.column
    }
    
    #expect(matrix.elements == [0, 1, 2, 3])
}

@Test func count() {
    let matrix = Matrix(rows: 4, columns: 5, repeatedValue: 0)
    
    #expect(matrix.count == 20)
}

@Test func sizeProperty() {
    let matrix = Matrix(rows: 3, columns: 5, repeatedValue: 0)
    let size = matrix.size
    
    #expect(size.rows == 3)
    #expect(size.columns == 5)
}

@Test func isSquare() {
    let square = Matrix(rows: 3, columns: 3, repeatedValue: 0)
    let notSquare = Matrix(rows: 2, columns: 4, repeatedValue: 0)
    
    #expect(square.isSquare == true)
    #expect(notSquare.isSquare == false)
}

@Test func isEmpty() {
    let empty = Matrix(rows: 0, columns: 0, repeatedValue: 0)
    let notEmpty = Matrix(rows: 2, columns: 2, repeatedValue: 0)
    
    #expect(empty.isEmpty == true)
    #expect(notEmpty.isEmpty == false)
}

@Test func coordinates() {
    let matrix = Matrix(rows: 2, columns: 3, repeatedValue: 0)
    let coords = matrix.coordinates
    
    #expect(coords.count == 6)
    #expect(coords[0].row == 0 && coords[0].column == 0)
    #expect(coords[1].row == 0 && coords[1].column == 1)
    #expect(coords[2].row == 0 && coords[2].column == 2)
    #expect(coords[3].row == 1 && coords[3].column == 0)
    #expect(coords[4].row == 1 && coords[4].column == 1)
    #expect(coords[5].row == 1 && coords[5].column == 2)
}

// MARK: - Subscript Tests

@Test func subscriptWithRowColumn() {
    var matrix = Matrix(rows: 3, columns: 3, repeatedValue: 0)
    
    matrix[0, 0] = 1
    matrix[1, 2] = 5
    matrix[2, 1] = 9
    
    #expect(matrix[0, 0] == 1)
    #expect(matrix[1, 2] == 5)
    #expect(matrix[2, 1] == 9)
    #expect(matrix[0, 1] == 0)
}

@Test func subscriptSetAndGetMultipleValues() {
    var matrix = Matrix(rows: 3, columns: 3, repeatedValue: 0)
    
    for row in 0..<3 {
        for col in 0..<3 {
            matrix[row, col] = row * 3 + col
        }
    }
    
    #expect(matrix[0, 0] == 0)
    #expect(matrix[0, 2] == 2)
    #expect(matrix[2, 2] == 8)
}

@Test func subscriptWithCoordinate() {
    var matrix = Matrix(rows: 3, columns: 3, repeatedValue: 0)
    let coord1: Matrix<Int>.Coordinate = (row: 0, column: 2)
    let coord2: Matrix<Int>.Coordinate = (row: 2, column: 0)
    
    matrix[coord1] = 42
    matrix[coord2] = 99
    
    #expect(matrix[coord1] == 42)
    #expect(matrix[coord2] == 99)
}

@Test func subscriptConsistencyBetweenStyles() {
    var matrix = Matrix(rows: 2, columns: 2, repeatedValue: 0)
    
    matrix[0, 1] = 10
    let coord: Matrix<Int>.Coordinate = (row: 0, column: 1)
    #expect(matrix[coord] == 10)
    
    matrix[(row: 1, column: 0)] = 20
    #expect(matrix[1, 0] == 20)
    #expect(matrix[(row: 1, column: 0)] == 20)
}

// MARK: - Coordinate Validation Tests

@Test func isValidCoordinateWithValidCoordinates() {
    let matrix = Matrix(rows: 3, columns: 4, repeatedValue: 0)
    
    #expect(matrix.isValidCoordinate(row: 0, column: 0) == true)
    #expect(matrix.isValidCoordinate(row: 2, column: 3) == true)
    #expect(matrix.isValidCoordinate(row: 1, column: 2) == true)
}

@Test func isValidCoordinateWithInvalidCoordinates() {
    let matrix = Matrix(rows: 3, columns: 4, repeatedValue: 0)
    
    #expect(matrix.isValidCoordinate(row: -1, column: 0) == false)
    #expect(matrix.isValidCoordinate(row: 0, column: -1) == false)
    #expect(matrix.isValidCoordinate(row: 3, column: 0) == false)
    #expect(matrix.isValidCoordinate(row: 0, column: 4) == false)
    #expect(matrix.isValidCoordinate(row: 5, column: 5) == false)
}

// MARK: - FirstCoordinate Tests

@Test func firstCoordinateWithPredicate() {
    let matrix = Matrix(rows: 3, columns: 3) { coordinate in
        coordinate.row * 3 + coordinate.column
    }
    
    let coord = matrix.firstCoordinate(where: { $0 == 5 })
    
    #expect(coord != nil)
    #expect(coord?.row == 1)
    #expect(coord?.column == 2)
}

@Test func firstCoordinateWithPredicateNotFound() {
    let matrix = Matrix(rows: 2, columns: 2, repeatedValue: 0)
    
    let coord = matrix.firstCoordinate(where: { $0 == 99 })
    
    #expect(coord == nil)
}

// MARK: - Map Tests

@Test func mapWithCoordinateAndElement() {
    let matrix = Matrix(rows: 2, columns: 2, repeatedValue: 1)
    
    let mapped = matrix.map { coordinate, element in
        element + coordinate.row + coordinate.column
    }
    
    #expect(mapped[0, 0] == 1)
    #expect(mapped[0, 1] == 2)
    #expect(mapped[1, 0] == 2)
    #expect(mapped[1, 1] == 3)
}

@Test func mapWithCoordinateOnly() {
    let matrix = Matrix(rows: 2, columns: 3, repeatedValue: 0)
    
    let mapped: Matrix<String> = matrix.map { coordinate in
        "(\(coordinate.row),\(coordinate.column))"
    }
    
    #expect(mapped[0, 0] == "(0,0)")
    #expect(mapped[1, 2] == "(1,2)")
}

@Test func mapWithElementOnly() {
    let matrix = Matrix(rows: 2, columns: 2) { coord in
        coord.row + coord.column
    }
    
    let mapped = matrix.map { element in
        element * 2
    }
    
    #expect(mapped[0, 0] == 0)
    #expect(mapped[0, 1] == 2)
    #expect(mapped[1, 0] == 2)
    #expect(mapped[1, 1] == 4)
}

@Test func mapPreservesDimensions() {
    let matrix = Matrix(rows: 5, columns: 7, repeatedValue: 0)
    
    let mapped = matrix.map { $0 + 1 }
    
    #expect(mapped.rows == 5)
    #expect(mapped.columns == 7)
}

// MARK: - Enumerated Tests

@Test func enumerated() {
    let matrix = Matrix(rows: 2, columns: 2) { coord in
        coord.row * 10 + coord.column
    }
    
    let enumerated = matrix.enumerated()
    
    #expect(enumerated.count == 4)
    
    #expect(enumerated[0].coordinate.row == 0)
    #expect(enumerated[0].coordinate.column == 0)
    #expect(enumerated[0].value == 0)
    
    #expect(enumerated[1].coordinate.row == 0)
    #expect(enumerated[1].coordinate.column == 1)
    #expect(enumerated[1].value == 1)
    
    #expect(enumerated[2].coordinate.row == 1)
    #expect(enumerated[2].coordinate.column == 0)
    #expect(enumerated[2].value == 10)
    
    #expect(enumerated[3].coordinate.row == 1)
    #expect(enumerated[3].coordinate.column == 1)
    #expect(enumerated[3].value == 11)
}

// MARK: - Description Tests

@Test func description() {
    let matrix = Matrix(rows: 3, columns: 4, repeatedValue: 0)
    
    #expect(matrix.description == "Matrix - 3 rows, 4 columns")
}

@Test func debugDescription() {
    let matrix = Matrix(rows: 2, columns: 2) { coord in
        coord.row * 2 + coord.column
    }
    
    let debug = matrix.debugDescription
    
    #expect(debug.contains("Matrix - 2 rows, 2 columns"))
    #expect(debug.contains("(0, 0): 0"))
    #expect(debug.contains("(0, 1): 1"))
    #expect(debug.contains("(1, 0): 2"))
    #expect(debug.contains("(1, 1): 3"))
}

// MARK: - Edge Cases

@Test func largeMatrix() {
    let matrix = Matrix(rows: 100, columns: 100, repeatedValue: 0)
    
    #expect(matrix.count == 10000)
    #expect(matrix.coordinates.count == 10000)
}

@Test func singleRowMatrix() {
    let matrix = Matrix(rows: 1, columns: 5, repeatedValue: "x")
    
    #expect(matrix.rows == 1)
    #expect(matrix.columns == 5)
    #expect(matrix.rowIndices == 0..<1)
    #expect(matrix.columnIndices == 0..<5)
}

@Test func singleColumnMatrix() {
    let matrix = Matrix(rows: 5, columns: 1, repeatedValue: "y")
    
    #expect(matrix.rows == 5)
    #expect(matrix.columns == 1)
    #expect(matrix.rowIndices == 0..<5)
    #expect(matrix.columnIndices == 0..<1)
}

@Test func matrixWithDifferentTypes() {
    let intMatrix = Matrix(rows: 2, columns: 2, repeatedValue: 42)
    #expect(intMatrix[0, 0] == 42)
    
    let stringMatrix = Matrix(rows: 2, columns: 2, repeatedValue: "hello")
    #expect(stringMatrix[0, 0] == "hello")
    
    let doubleMatrix = Matrix(rows: 2, columns: 2, repeatedValue: 3.14)
    #expect(doubleMatrix[0, 0] == 3.14)
    
    let optionalMatrix = Matrix<Int?>(rows: 2, columns: 2, repeatedValue: nil)
    #expect(optionalMatrix[0, 0] == nil)
}

// MARK: - Iteration & Access Tests

@Test func rowAccess() {
    let matrix = Matrix(rows: 3, columns: 4) { coord in
        coord.row * 10 + coord.column
    }
    
    #expect(matrix.row(0) == [0, 1, 2, 3])
    #expect(matrix.row(1) == [10, 11, 12, 13])
    #expect(matrix.row(2) == [20, 21, 22, 23])
}

@Test func columnAccess() {
    let matrix = Matrix(rows: 3, columns: 4) { coord in
        coord.row * 10 + coord.column
    }
    
    #expect(matrix.column(0) == [0, 10, 20])
    #expect(matrix.column(1) == [1, 11, 21])
    #expect(matrix.column(3) == [3, 13, 23])
}

@Test func diagonalSquareMatrix() {
    let matrix = Matrix(rows: 3, columns: 3) { coord in
        coord.row * 10 + coord.column
    }
    
    #expect(matrix.diagonal() == [0, 11, 22])
}

@Test func diagonalRectangularMatrix() {
    let wide = Matrix(rows: 2, columns: 4) { coord in
        coord.row * 10 + coord.column
    }
    #expect(wide.diagonal() == [0, 11])
    
    let tall = Matrix(rows: 4, columns: 2) { coord in
        coord.row * 10 + coord.column
    }
    #expect(tall.diagonal() == [0, 11])
}

@Test func antiDiagonal() {
    let matrix = Matrix(rows: 3, columns: 3) { coord in
        coord.row * 10 + coord.column
    }
    
    #expect(matrix.antiDiagonal() == [2, 11, 20])
}

@Test func forEachIteratesAllElements() {
    let matrix = Matrix(rows: 2, columns: 2) { coord in
        coord.row * 2 + coord.column
    }
    
    var visited: [(Matrix<Int>.Coordinate, Int)] = []
    matrix.forEach { coord, value in
        visited.append((coord, value))
    }
    
    #expect(visited.count == 4)
    #expect(visited[0].1 == 0)
    #expect(visited[1].1 == 1)
    #expect(visited[2].1 == 2)
    #expect(visited[3].1 == 3)
}

// MARK: - Transformation Tests

@Test func transposed() {
    let matrix = Matrix(rows: 2, columns: 3) { coord in
        coord.row * 10 + coord.column
    }
    
    let transposed = matrix.transposed()
    
    #expect(transposed.rows == 3)
    #expect(transposed.columns == 2)
    #expect(transposed[0, 0] == 0)
    #expect(transposed[0, 1] == 10)
    #expect(transposed[1, 0] == 1)
    #expect(transposed[1, 1] == 11)
    #expect(transposed[2, 0] == 2)
    #expect(transposed[2, 1] == 12)
}

@Test func flippedHorizontally() {
    let matrix = Matrix(rows: 2, columns: 3) { coord in
        coord.row * 10 + coord.column
    }
    
    let flipped = matrix.flippedHorizontally()
    
    #expect(flipped.rows == 2)
    #expect(flipped.columns == 3)
    #expect(flipped[0, 0] == 2)
    #expect(flipped[0, 1] == 1)
    #expect(flipped[0, 2] == 0)
    #expect(flipped[1, 0] == 12)
    #expect(flipped[1, 1] == 11)
    #expect(flipped[1, 2] == 10)
}

@Test func flippedVertically() {
    let matrix = Matrix(rows: 3, columns: 2) { coord in
        coord.row * 10 + coord.column
    }
    
    let flipped = matrix.flippedVertically()
    
    #expect(flipped.rows == 3)
    #expect(flipped.columns == 2)
    #expect(flipped[0, 0] == 20)
    #expect(flipped[0, 1] == 21)
    #expect(flipped[1, 0] == 10)
    #expect(flipped[2, 0] == 0)
}

@Test func rotated90Clockwise() {
    let matrix = Matrix(rows: 2, columns: 3) { coord in
        coord.row * 10 + coord.column
    }
    
    let rotated = matrix.rotated90Clockwise()
    
    #expect(rotated.rows == 3)
    #expect(rotated.columns == 2)
    #expect(rotated[0, 0] == 10)
    #expect(rotated[0, 1] == 0)
    #expect(rotated[1, 0] == 11)
    #expect(rotated[1, 1] == 1)
    #expect(rotated[2, 0] == 12)
    #expect(rotated[2, 1] == 2)
}

@Test func rotated90CounterClockwise() {
    let matrix = Matrix(rows: 2, columns: 3) { coord in
        coord.row * 10 + coord.column
    }
    
    let rotated = matrix.rotated90CounterClockwise()
    
    #expect(rotated.rows == 3)
    #expect(rotated.columns == 2)
    #expect(rotated[0, 0] == 2)
    #expect(rotated[0, 1] == 12)
    #expect(rotated[1, 0] == 1)
    #expect(rotated[1, 1] == 11)
    #expect(rotated[2, 0] == 0)
    #expect(rotated[2, 1] == 10)
}

@Test func rotated180() {
    let matrix = Matrix(rows: 2, columns: 3) { coord in
        coord.row * 10 + coord.column
    }
    
    let rotated = matrix.rotated180()
    
    #expect(rotated.rows == 2)
    #expect(rotated.columns == 3)
    #expect(rotated[0, 0] == 12)
    #expect(rotated[0, 1] == 11)
    #expect(rotated[0, 2] == 10)
    #expect(rotated[1, 0] == 2)
    #expect(rotated[1, 1] == 1)
    #expect(rotated[1, 2] == 0)
}

// MARK: - Submatrix Tests

@Test func submatrix() {
    let matrix = Matrix(rows: 4, columns: 4) { coord in
        coord.row * 10 + coord.column
    }
    
    let sub = matrix.submatrix(rowRange: 1..<3, columnRange: 1..<3)
    
    #expect(sub.rows == 2)
    #expect(sub.columns == 2)
    #expect(sub[0, 0] == 11)
    #expect(sub[0, 1] == 12)
    #expect(sub[1, 0] == 21)
    #expect(sub[1, 1] == 22)
}

@Test func neighborsWithDiagonals() {
    let matrix = Matrix(rows: 3, columns: 3) { coord in
        coord.row * 3 + coord.column
    }
    
    let neighbors = matrix.neighbors(of: (row: 1, column: 1), includeDiagonals: true)
    
    #expect(neighbors.count == 8)
    #expect(neighbors.contains(0))
    #expect(neighbors.contains(1))
    #expect(neighbors.contains(2))
    #expect(neighbors.contains(3))
    #expect(neighbors.contains(5))
    #expect(neighbors.contains(6))
    #expect(neighbors.contains(7))
    #expect(neighbors.contains(8))
}

@Test func neighborsWithoutDiagonals() {
    let matrix = Matrix(rows: 3, columns: 3) { coord in
        coord.row * 3 + coord.column
    }
    
    let neighbors = matrix.neighbors(of: (row: 1, column: 1), includeDiagonals: false)
    
    #expect(neighbors.count == 4)
    #expect(neighbors.contains(1))
    #expect(neighbors.contains(3))
    #expect(neighbors.contains(5))
    #expect(neighbors.contains(7))
}

@Test func neighborsAtCorner() {
    let matrix = Matrix(rows: 3, columns: 3) { coord in
        coord.row * 3 + coord.column
    }
    
    let neighbors = matrix.neighbors(of: (row: 0, column: 0), includeDiagonals: true)
    
    #expect(neighbors.count == 3)
    #expect(neighbors.contains(1))
    #expect(neighbors.contains(3))
    #expect(neighbors.contains(4))
}

@Test func neighborCoordinates() {
    let matrix = Matrix(rows: 3, columns: 3, repeatedValue: 0)
    
    let coords = matrix.neighborCoordinates(of: (row: 1, column: 1), includeDiagonals: false)
    
    #expect(coords.count == 4)
}

// MARK: - Query Tests

@Test func containsWhere() {
    let matrix = Matrix(rows: 2, columns: 2) { coord in
        coord.row * 2 + coord.column
    }
    
    #expect(matrix.contains { $0 == 3 } == true)
    #expect(matrix.contains { $0 == 99 } == false)
}

@Test func allSatisfy() {
    let matrix = Matrix(rows: 2, columns: 2, repeatedValue: 5)
    
    #expect(matrix.allSatisfy { $0 == 5 } == true)
    #expect(matrix.allSatisfy { $0 > 0 } == true)
    #expect(matrix.allSatisfy { $0 > 5 } == false)
}

@Test func firstWhere() {
    let matrix = Matrix(rows: 2, columns: 2) { coord in
        coord.row * 2 + coord.column
    }
    
    #expect(matrix.first { $0 > 1 } == 2)
    #expect(matrix.first { $0 > 10 } == nil)
}

@Test func filterElements() {
    let matrix = Matrix(rows: 3, columns: 3) { coord in
        coord.row * 3 + coord.column
    }
    
    let filtered = matrix.filter { $0 % 2 == 0 }
    
    #expect(filtered.count == 5)
    #expect(filtered.map { $0.1 }.sorted() == [0, 2, 4, 6, 8])
}

// MARK: - Mutation Tests

@Test func fillWithValue() {
    var matrix = Matrix(rows: 2, columns: 2, repeatedValue: 0)
    
    matrix.fill(with: 42)
    
    #expect(matrix.allSatisfy { $0 == 42 })
}

@Test func fillRow() {
    var matrix = Matrix(rows: 3, columns: 3, repeatedValue: 0)
    
    matrix.fillRow(1, with: 5)
    
    #expect(matrix.row(0) == [0, 0, 0])
    #expect(matrix.row(1) == [5, 5, 5])
    #expect(matrix.row(2) == [0, 0, 0])
}

@Test func fillColumn() {
    var matrix = Matrix(rows: 3, columns: 3, repeatedValue: 0)
    
    matrix.fillColumn(1, with: 7)
    
    #expect(matrix.column(0) == [0, 0, 0])
    #expect(matrix.column(1) == [7, 7, 7])
    #expect(matrix.column(2) == [0, 0, 0])
}

@Test func swapRows() {
    var matrix = Matrix(rows: 3, columns: 2) { coord in
        coord.row * 10 + coord.column
    }
    
    matrix.swapRows(0, 2)
    
    #expect(matrix.row(0) == [20, 21])
    #expect(matrix.row(1) == [10, 11])
    #expect(matrix.row(2) == [0, 1])
}

@Test func swapColumns() {
    var matrix = Matrix(rows: 2, columns: 3) { coord in
        coord.row * 10 + coord.column
    }
    
    matrix.swapColumns(0, 2)
    
    #expect(matrix.column(0) == [2, 12])
    #expect(matrix.column(1) == [1, 11])
    #expect(matrix.column(2) == [0, 10])
}

// MARK: - Row/Column Insertion Tests

@Test func insertingRow() {
    let matrix: Matrix<Int> = [
        [1, 2, 3],
        [4, 5, 6]
    ]
    
    let result = matrix.insertingRow([7, 8, 9], at: 1)
    
    #expect(result.rows == 3)
    #expect(result.columns == 3)
    #expect(result.row(0) == [1, 2, 3])
    #expect(result.row(1) == [7, 8, 9])
    #expect(result.row(2) == [4, 5, 6])
}

@Test func insertingRowAtEnd() {
    let matrix: Matrix<Int> = [
        [1, 2],
        [3, 4]
    ]
    
    let result = matrix.insertingRow([5, 6], at: 2)
    
    #expect(result.rows == 3)
    #expect(result.row(2) == [5, 6])
}

@Test func insertingColumn() {
    let matrix: Matrix<Int> = [
        [1, 2],
        [3, 4]
    ]
    
    let result = matrix.insertingColumn([5, 6], at: 1)
    
    #expect(result.rows == 2)
    #expect(result.columns == 3)
    #expect(result.row(0) == [1, 5, 2])
    #expect(result.row(1) == [3, 6, 4])
}

@Test func removingRow() {
    let matrix: Matrix<Int> = [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9]
    ]
    
    let result = matrix.removingRow(at: 1)
    
    #expect(result.rows == 2)
    #expect(result.row(0) == [1, 2, 3])
    #expect(result.row(1) == [7, 8, 9])
}

@Test func removingColumn() {
    let matrix: Matrix<Int> = [
        [1, 2, 3],
        [4, 5, 6]
    ]
    
    let result = matrix.removingColumn(at: 1)
    
    #expect(result.columns == 2)
    #expect(result.row(0) == [1, 3])
    #expect(result.row(1) == [4, 6])
}

@Test func appendingRow() {
    let matrix: Matrix<Int> = [
        [1, 2],
        [3, 4]
    ]
    
    let result = matrix.appendingRow([5, 6])
    
    #expect(result.rows == 3)
    #expect(result.row(2) == [5, 6])
}

@Test func appendingColumn() {
    let matrix: Matrix<Int> = [
        [1, 2],
        [3, 4]
    ]
    
    let result = matrix.appendingColumn([5, 6])
    
    #expect(result.columns == 3)
    #expect(result.column(2) == [5, 6])
}

// MARK: - Reshape Tests

@Test func reshape() {
    let matrix: Matrix<Int> = [
        [1, 2, 3, 4, 5, 6]
    ]
    
    let reshaped = matrix.reshaped(rows: 2, columns: 3)
    
    #expect(reshaped != nil)
    #expect(reshaped?.rows == 2)
    #expect(reshaped?.columns == 3)
    #expect(reshaped?.row(0) == [1, 2, 3])
    #expect(reshaped?.row(1) == [4, 5, 6])
}

@Test func reshapeInvalid() {
    let matrix: Matrix<Int> = [
        [1, 2, 3],
        [4, 5, 6]
    ]
    
    let reshaped = matrix.reshaped(rows: 2, columns: 2)
    
    #expect(reshaped == nil)
}

@Test func reshapeWithNegativeDimensionsReturnsNil() {
    let matrix: Matrix<Int> = [
        [1, 2, 3],
        [4, 5, 6]
    ]
    
    #expect(matrix.reshaped(rows: -1, columns: 6) == nil)
    #expect(matrix.reshaped(rows: 2, columns: -3) == nil)
}

@Test func to2DArray() {
    let matrix: Matrix<Int> = [
        [1, 2, 3],
        [4, 5, 6]
    ]
    
    let array = matrix.to2DArray()
    
    #expect(array.count == 2)
    #expect(array[0] == [1, 2, 3])
    #expect(array[1] == [4, 5, 6])
}

// MARK: - Range Subscript Tests

@Test func rangeSubscript() {
    let matrix: Matrix<Int> = [
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 10, 11, 12]
    ]
    
    let sub = matrix[0..<2, 1..<3]
    
    #expect(sub.rows == 2)
    #expect(sub.columns == 2)
    #expect(sub[0, 0] == 2)
    #expect(sub[0, 1] == 3)
    #expect(sub[1, 0] == 6)
    #expect(sub[1, 1] == 7)
}

@Test func closedRangeSubscript() {
    let matrix: Matrix<Int> = [
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 10, 11, 12]
    ]
    
    let sub = matrix[0...1, 1...2]
    
    #expect(sub.rows == 2)
    #expect(sub.columns == 2)
    #expect(sub[0, 0] == 2)
    #expect(sub[1, 1] == 7)
}

// MARK: - Pretty Print Tests

@Test func prettyPrinted() {
    let matrix: Matrix<Int> = [
        [1, 2],
        [3, 4]
    ]
    
    let pretty = matrix.prettyPrinted(columnWidth: 4)
    
    #expect(pretty.contains("│"))
    #expect(pretty.contains("1"))
    #expect(pretty.contains("4"))
}

// MARK: - Empty Matrix Safety Tests

@Test func insertingRowIntoZeroColumnMatrix() {
    let matrix = Matrix<Int>(rows: 1, columns: 0, repeatedValue: 0)
    let result = matrix.insertingRow([], at: 1)
    
    #expect(result.rows == 2)
    #expect(result.columns == 0)
    #expect(result.count == 0)
}

@Test func removingRowFromZeroColumnMatrix() {
    let matrix = Matrix<Int>(rows: 2, columns: 0, repeatedValue: 0)
    let result = matrix.removingRow(at: 0)
    
    #expect(result.rows == 1)
    #expect(result.columns == 0)
    #expect(result.count == 0)
}

@Test func reshapeEmptyMatrixToEmptyMatrix() {
    let matrix = Matrix<Int>(rows: 0, columns: 0, repeatedValue: 0)
    let reshaped = matrix.reshaped(rows: 0, columns: 0)
    
    #expect(reshaped != nil)
    #expect(reshaped?.rows == 0)
    #expect(reshaped?.columns == 0)
    #expect(reshaped?.count == 0)
}
