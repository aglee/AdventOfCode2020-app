import Foundation

//TODO: [agl] Make this generic.

/// A 2-dimensional array of strings.  Some operations crash if the grid is empty.
///
/// For Advent of Code, the elements are pretty much always single-character strings, but
/// that is not enforced.
struct CharGrid: Equatable {
	private(set) var rows: [[String]]
	var width: Int { return rows.count == 0 ? 0 : rows[0].count }
	var height: Int { return rows.count }

	init(rows: [[String]]) {
		assert(rows.count == 0 || (rows.filter { $0.count != rows[0].count }.count == 0),
			   "The rows of a grid must all have the same number of elements.")
		self.rows = rows
	}

	/// Returns an empty grid.
	init() {
		self.init(rows: [])
	}

	/// Initializes every element of the grid to be a single-character string.
	init(inputLines: [String]) {
		self.init(rows: inputLines.map { $0.map { String($0) } })
	}

	// MARK: - Point arithmetic

	static let deltasIncludingDiagonals = [(-1, -1), (0, -1), (1, -1),
										   (-1, 0),           (1, 0),
										   (-1, 1),  (0, 1),  (1, 1)]
	static let deltasWithoutDiagonals = [(0, -1), (-1, 0), (1, 0), (0, 1)]

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

	// MARK: - Flipping and rotation

	mutating func flipLeftToRight() {
		rows = rows.map { $0.reversed() }
	}

	mutating func flipTopToBottom() {
		rows = rows.reversed()
	}

	/// Rotates by 90 degrees.
	mutating func rotateCounterclockwise() {
		// Make a list of the grid's columns.  Rotating means those columns will become
		// rows.  We reverse the list of columns because under counterclockwise rotation,
		// the first column will become the last row.
		rows = (0..<width).map { x in  // For x in 0..<width.
			rows.map { $0[x] }  // Return the x'th column.
		}.reversed()  // Reverse the resulting list of columns.
	}

	// MARK: - Adding and removing rows

	mutating func removeFirstRow() {
		rows.removeFirst()
	}

	mutating func removeLastRow() {
		rows.removeLast()
	}

	mutating func removeFirstColumn() {
		rows = rows.map { Array($0[1..<$0.count]) }
	}

	mutating func removeLastColumn() {
		rows = rows.map { Array($0[0..<($0.count - 1)]) }
	}

	mutating func appendRows(from otherGrid: CharGrid) {
		if rows.isEmpty {
			rows = otherGrid.rows
		} else {
			assert(width == otherGrid.width, "Grids have different widths.")
			rows.append(contentsOf: otherGrid.rows)
		}
	}

	mutating func appendColumns(from otherGrid: CharGrid) {
		if rows.isEmpty {
			rows = otherGrid.rows
		} else {
			assert(height == otherGrid.height, "Grids have different heights.")
			for rowIndex in 0..<rows.count {
				rows[rowIndex].append(contentsOf: otherGrid.rows[rowIndex])
			}
		}
	}

	// MARK: - Debugging

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

