import Foundation

class Tile {
	let number: Int
	private var grid: CharGrid
	var possibleEdgeNumbers: [Int] {
		return [
			grid.rows.first!,
			grid.rows.last!,
			grid.rows.map { $0.first! },
			grid.rows.map { $0.last! },

			grid.rows.first!.reversed(),
			grid.rows.last!.reversed(),
			grid.rows.map { $0.first! }.reversed(),
			grid.rows.map { $0.last! }.reversed(),
		].map { edgeToInt($0) }
	}
	var topEdgeNumber: Int { edgeToInt(grid.rows.first!) }
	var bottomEdgeNumber: Int { edgeToInt(grid.rows.last!) }
	var leftEdgeNumber: Int { edgeToInt(grid.rows.map { $0.first! }) }
	var rightEdgeNumber: Int { edgeToInt(grid.rows.map { $0.last! }) }

	init(_ lines: [String]) {
		var lines = lines

		// Parse the tile number, e.g. "Tile 2311:" becomes 2311.
		var firstLine = lines.removeFirst()
		firstLine.removeFirst(5)
		firstLine.removeLast()
		self.number = Int(firstLine)!

		// The remaining lines contain the grid itself.
		self.grid = CharGrid(inputLines: lines)

		// Sanity check.
		assert(Set(possibleEdgeNumbers).count == 8,
			   "This only works if edges and their flips are unique.")
	}

	/// Try all combinations of rotating and flipping the grid until the condition is
	/// satisfied.
	func flipAndRotateUntil(_ condition: () -> Bool) {
		// Rotate the grid and see if we can satisfy the condition.
		for _ in 0..<4 {
			grid.rotateCounterclockwise()
			if condition() {
				return
			}
		}

		// Rotating the original grid didn't work.  Flip the grid and try again.
		grid.flipLeftToRight()
		for _ in 0..<4 {
			grid.rotateCounterclockwise()
			if condition() {
				return
			}
		}

		// The input data is supposed to be such that we never get here.  If we do,
		// it's a bug.
		abort()
	}

	func rowStringsWithoutEdges() -> [String] {
		var rowsOfChars = grid.rows

		// Remove the top and bottom edges.
		rowsOfChars.removeFirst()
		rowsOfChars.removeLast()

		// Remove the left and right edges.
		for rowIndex in 0..<rowsOfChars.count {
			rowsOfChars[rowIndex].removeFirst()
			rowsOfChars[rowIndex].removeLast()
		}

		// Convert the now-reduced rows to strings
		return rowsOfChars.map { $0.joined() }
	}

	private func edgeToInt(_ chars: [String]) -> Int {
		var result = 0
		for ch in chars {
			result <<= 1
			if ch == "#" {
				result += 1
			}
		}
		return result
	}
}

class TileSet {
	/// The tiles contained in this set.
	let tiles: [Tile]

	/// Each value is a list of the tiles that have the key as a possible edge number.
	let tilesByPossibleEdgeNumber: [Int: [Tile]]

	/// All the numbers that are a possible edge number for exactly one tile in the set.
	var singletonEdgeNumbers: Set<Int> {
		return Set(tilesByPossibleEdgeNumber.filter { $1.count == 1 }.keys)
	}

	/// Tiles that must be on the corners of the image.
	var cornerTiles: [Tile] {
		return tiles.filter { singletonEdgesForTile($0).count == 4 }
	}

	init(_ inputLines: [String]) {
		// Create Tile instances by parsing the input.
		let groups = groupedLines(inputLines)
		self.tiles = groups.map { Tile($0) }

		// Calculate the set of all the tiles' possible edge numbers, and map them to the
		// tiles they are possible for.
		var tilesByPossibleEdgeNumber = [Int: [Tile]]()
		for tile in tiles {
			for edgeNumber in tile.possibleEdgeNumbers {
				if let _ = tilesByPossibleEdgeNumber[edgeNumber] {
					tilesByPossibleEdgeNumber[edgeNumber]!.append(tile)
				} else {
					tilesByPossibleEdgeNumber[edgeNumber] = [tile]
				}
			}
		}
		self.tilesByPossibleEdgeNumber = tilesByPossibleEdgeNumber
	}

	func singletonEdgesForTile(_ tile: Tile) -> [Int] {
		return tile.possibleEdgeNumbers.filter({ singletonEdgeNumbers.contains($0) })
	}
}
