import Foundation

class Day24: DayNN {
	init() {
		super.init("PUT_DESCRIPTION_HERE")
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
		return f.part1(inputLines)
	}

	override func solvePart2(inputLines: [String]) -> String {
		let f = Floor()
		return f.part2(inputLines)
	}
}


