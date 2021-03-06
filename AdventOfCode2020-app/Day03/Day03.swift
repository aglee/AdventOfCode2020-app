import Foundation

extension CharGrid {
	/// "#" means tree and "." means no tree.  The overall terrain consists of this grid
	/// repeated horizontally over and over.
	func countTrees(deltaX: Int, deltaY: Int) -> Int {
		var treesEncountered = 0

		// We're told that our starting point of (0, 0) has no tree, so we start counting
		// at the next point, which is (deltaX, deltaY).
		var (x, y) = (deltaX, deltaY)
		while y < height {
			if self[x % width, y % height] == "#" {
				treesEncountered += 1
			}
			(x, y) = (x + deltaX, y + deltaY)
		}
		return treesEncountered
	}
}

class Day03: DayNN {
	init() {
		super.init("Toboggan Trajectory")
		self.part1Tests = [
			testPart1(fileNumber: 1, expectedResult: "7")
		]
		self.part2Tests = [
			testPart2(fileNumber: 1, expectedResult: "336")
		]
	}

	// MARK: - Solving

	override func solvePart1(inputLines: [String]) -> String {
		let t = CharGrid(inputLines: inputLines)
		return String(t.countTrees(deltaX: 3, deltaY: 1))
	}

	override func solvePart2(inputLines: [String]) -> String {
		let t = CharGrid(inputLines: inputLines)
		var result = 1
		for (deltaX, deltaY) in [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)] {
			result *= t.countTrees(deltaX: deltaX, deltaY: deltaY)
		}
		return String(result)
	}
}


