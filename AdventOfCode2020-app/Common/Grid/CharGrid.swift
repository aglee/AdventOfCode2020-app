import Foundation

/// A non-empty rectangular collection of 1-character strings -- basically syntactic sugar
/// around a 2-dimensional array.
class CharGrid: Equatable {
	private var rows: [[String]]
	var width: Int { return rows[0].count }
	var height: Int { return rows.count }

	static let deltasIncludingDiagonals = [(-1, -1), (0, -1), (1, -1),
										   (-1, 0),           (1, 0),
										   (-1, 1),  (0, 1),  (1, 1)]
	static let deltasWithoutDiagonals = [(0, -1), (-1, 0), (1, 0), (0, 1)]

	init(inputLines: [String]) {
		assert(inputLines.count > 0, "`inputLines` must be non-empty.")
		assert(inputLines[0].count > 0, "The strings in `inputLines` must be non-empty.")
		assert(
			inputLines.filter({ $0.count != inputLines[0].count }).count == 0,
			"The strings in `inputLines` must all have the same length."
		)
		self.rows = inputLines.map { $0.map { String($0) } }
	}

	func neighboringPoints(of point: GridPoint) -> [GridPoint] {
		var result: [GridPoint] = []

		for (dx, dy) in CharGrid.deltasIncludingDiagonals {
			let (newX, newY) = (point.x + dx, point.y + dy)
			if isInBounds(newX, newY) {
				result.append(GridPoint(newX, newY))
			}
		}

		return result
	}

	func isInBounds(_ x: Int, _ y: Int) -> Bool {
		return (x >= 0 && x < width) && (y >= 0 && y < height)
	}

	func isInBounds(_ point: GridPoint) -> Bool {
		return isInBounds(point.x, point.y)
	}

	func printGrid() {
		for row in rows {
			print(row.joined())
		}
	}

	// MARK: - Subscripts

	/// The setter fails an assertion if `newValue` does not have exactly one character.
	subscript(x: Int, y: Int) -> String {
		get { return rows[y][x] }
		set {
			assert(newValue.count == 1, "Expected a 1-character string, got [\(newValue)].")
			rows[y][x] = newValue
		}
	}

	/// The setter fails an assertion if `newValue` does not have exactly one character.
	subscript(point: GridPoint) -> String {
		get { return self[point.x, point.y] }
		set { self[point.x, point.y] = newValue }
	}

	// MARK: - Equatable

	static func == (left: CharGrid, right: CharGrid) -> Bool {
		return left.rows == right.rows
	}
}

