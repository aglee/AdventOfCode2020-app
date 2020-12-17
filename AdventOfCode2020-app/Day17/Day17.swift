import Foundation

class Day17: DayNN {
	init() {
		super.init("PUT_DESCRIPTION_HERE")
		self.part1Tests = [
			testPart1(fileNumber: 1, expectedResult: "112"),
		]
		self.part2Tests = [
			testPart2(fileNumber: 1, expectedResult: "848"),
		]
	}

	// MARK: - Solving

	override func solvePart1(inputLines: [String]) -> String {
		var slab = Slab3D(inputLines)
		for _ in 0..<6 {
			slab = slab.cycle()
		}
		return String(slab.activePoints.count)
	}

	override func solvePart2(inputLines: [String]) -> String {
		var slab = Slab4D(inputLines)
		for _ in 0..<6 {
			slab = slab.cycle()
		}
		return String(slab.activePoints.count)
	}
}


