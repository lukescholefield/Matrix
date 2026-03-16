import Foundation
import Testing

@testable import Matrix

// MARK: - Codable Tests

@Test func encodeAndDecode() throws {
  let original: Matrix<Int> = [
    [1, 2, 3],
    [4, 5, 6],
  ]

  let encoder = JSONEncoder()
  let data = try encoder.encode(original)

  let decoder = JSONDecoder()
  let decoded = try decoder.decode(Matrix<Int>.self, from: data)

  #expect(decoded == original)
}

@Test func encodeAndDecodeWithStrings() throws {
  let original: Matrix<String> = [
    ["a", "b"],
    ["c", "d"],
  ]

  let encoder = JSONEncoder()
  let data = try encoder.encode(original)

  let decoder = JSONDecoder()
  let decoded = try decoder.decode(Matrix<String>.self, from: data)

  #expect(decoded == original)
}

@Test func encodeAndDecodeWithDoubles() throws {
  let original: Matrix<Double> = [
    [1.5, 2.5],
    [3.5, 4.5],
  ]

  let encoder = JSONEncoder()
  let data = try encoder.encode(original)

  let decoder = JSONDecoder()
  let decoded = try decoder.decode(Matrix<Double>.self, from: data)

  #expect(decoded == original)
}

@Test func decodeInvalidDataThrows() {
  let invalidJSON = """
    {"rows": 2, "columns": 2, "grid": [1, 2, 3]}
    """.data(using: .utf8)!

  let decoder = JSONDecoder()

  #expect(throws: DecodingError.self) {
    _ = try decoder.decode(Matrix<Int>.self, from: invalidJSON)
  }
}

@Test func encodedJSONStructure() throws {
  let matrix: Matrix<Int> = [
    [1, 2],
    [3, 4],
  ]

  let encoder = JSONEncoder()
  encoder.outputFormatting = .sortedKeys
  let data = try encoder.encode(matrix)
  let jsonString = String(data: data, encoding: .utf8)!

  #expect(jsonString.contains("\"rows\":2"))
  #expect(jsonString.contains("\"columns\":2"))
  #expect(jsonString.contains("\"grid\":[1,2,3,4]"))
}
