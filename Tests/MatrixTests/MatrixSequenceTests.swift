import Testing

@testable import Matrix

// MARK: - Sequence Tests

@Test func sequenceIteration() {
  let matrix: Matrix<Int> = [
    [1, 2, 3],
    [4, 5, 6],
  ]

  var collected: [Int] = []
  for element in matrix {
    collected.append(element)
  }

  #expect(collected == [1, 2, 3, 4, 5, 6])
}

@Test func sequenceReduce() {
  let matrix: Matrix<Int> = [
    [1, 2, 3],
    [4, 5, 6],
  ]

  let sum = matrix.reduce(0, +)

  #expect(sum == 21)
}

@Test func sequenceMap() {
  let matrix: Matrix<Int> = [
    [1, 2],
    [3, 4],
  ]

  let doubled = matrix.map { $0 * 2 }

  #expect(Array(doubled) == [2, 4, 6, 8])
}
