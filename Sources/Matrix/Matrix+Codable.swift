extension Matrix: Codable where T: Codable {
  enum CodingKeys: String, CodingKey {
    case rows
    case columns
    case grid
  }

  /// Creates a new matrix by decoding from the given decoder.
  ///
  /// - Parameters:
  ///   - decoder: The decoder to read data from.
  /// - Throws: An error if reading from the decoder fails, or if the data is corrupted.
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let rows = try container.decode(Int.self, forKey: .rows)
    let columns = try container.decode(Int.self, forKey: .columns)
    let grid = try container.decode([T].self, forKey: .grid)

    guard grid.count == rows * columns else {
      throw DecodingError.dataCorruptedError(
        forKey: .grid,
        in: container,
        debugDescription: "Grid size \(grid.count) does not match dimensions \(rows)x\(columns)"
      )
    }

    self.rows = rows
    self.columns = columns
    self.grid = grid
  }

  /// Encodes this matrix into the given encoder.
  ///
  /// - Parameters:
  ///   - encoder: The encoder to write data to.
  /// - Throws: An error if any values are invalid for the given encoder's format.
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(rows, forKey: .rows)
    try container.encode(columns, forKey: .columns)
    try container.encode(grid, forKey: .grid)
  }
}
