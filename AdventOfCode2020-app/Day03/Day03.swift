import Foundation

struct Terrain {
	/// Contains a 2-dimensional array of 1-character strings, with "#" meaning tree and
	/// "." meaning no tree.  According to the puzzle description, the terrain consists of
	/// this grid repeated horizontally over and over.
	var gridRows: [[String]]
	var gridWidth: Int { return gridRows[0].count }
	var gridHeight: Int { return gridRows.count }

	init(inputLines: [String]) {
		self.gridRows = inputLines.map { $0.map { String($0) } }
	}

	func isTree(x: Int, y: Int) -> Bool {
		return gridRows[y % gridHeight][x % gridWidth] == "#"
	}

	func countTrees(deltaX: Int, deltaY: Int) -> Int {
		var treesEncountered = 0

		// We're told that our starting point of (0, 0) has no tree, so we start counting
		// at the next point, which is (deltaX, deltaY).
		var (x, y) = (deltaX, deltaY)
		while y < gridHeight {
			if isTree(x: x, y: y) {
				treesEncountered += 1
			}
			x += deltaX
			y += deltaY
		}
		return treesEncountered
	}

	func printGrid() {
		for row in gridRows {
			print(row.joined())
		}
	}
}

class Day03: DayNN {
	override var expectedPart1TestResults: [Int : String] {
		return [1: "7"]
	}
	override var expectedPart2TestResults: [Int : String] {
		return [1: "336"]
	}

	init() {
		super.init("Toboggan Trajectory")
	}

	// MARK: - Solving

	override func solvePart1(inputLines: [String]) -> String {
		let t = Terrain(inputLines: inputLines)
		return String(t.countTrees(deltaX: 3, deltaY: 1))
	}

	override func solvePart2(inputLines: [String]) -> String {
		let t = Terrain(inputLines: inputLines)
		var result = 1
		for (deltaX, deltaY) in [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)] {
			result *= t.countTrees(deltaX: deltaX, deltaY: deltaY)
		}
		return String(result)
	}
}


