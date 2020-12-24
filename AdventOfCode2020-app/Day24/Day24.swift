import Foundation

class Day24: DayNN {
	init() {
		super.init("Lobby Layout")
		self.part1Tests = [
			testPart1(fileNumber: 1, expectedResult: "10"),
		]
		self.part2Tests = [
			testPart2(fileNumber: 1, expectedResult: "2208"),
		]
	}

	// MARK: - Solving

	override func solvePart1(inputLines: [String]) -> String {
		let f = Floor()
		for line in inputLines {
			f.flipTileColor(f.locateTile(directions: line))
		}
		return String(f.numBlackTiles)
	}

	override func solvePart2(inputLines: [String]) -> String {
		// Repeat Part 1.
		let f = Floor()
		for line in inputLines {
			f.flipTileColor(f.locateTile(directions: line))
		}

		// Flip more tiles using Game of Life rules.
		for _ in 0..<100 {
			f.oneConwayPass()
		}

		// Done.
		return String(f.numBlackTiles)
	}
}


