import Foundation

/// A non-empty rectangular collection of 1-character strings -- basically syntactic sugar
/// around a 2-dimensional array.
class CharGrid {
	/// Contains a 2-dimensional array of 1-character strings, with "#" meaning tree and
	/// "." meaning no tree.  According to the puzzle description, the terrain consists of
	/// this grid repeated horizontally over and over.
	private var rows: [[String]]
	var width: Int { return rows[0].count }
	var height: Int { return rows.count }

	init(inputLines: [String]) {
		assert(inputLines.count > 0, "`inputLines` must be non-empty.")
		assert(inputLines[0].count > 0, "The strings in `inputLines` must be non-empty.")
		assert(
			inputLines.filter({ $0.count != inputLines[0].count }).count == 0,
			"The strings in `inputLines` must all have the same length."
		)
		self.rows = inputLines.map { $0.map { String($0) } }
	}

	/// The setter fails an assertion if `newValue` does not have exactly one character.
	subscript(x: Int, y: Int) -> String {
		get { return rows[y][x] }
		set {
			assert(newValue.count == 1, "Expected a 1-character string, got [\(newValue)].")
			rows[y][x] = newValue
		}
	}

	func printGrid() {
		for row in rows {
			print(row.joined())
		}
	}
}

