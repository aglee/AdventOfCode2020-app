import Foundation

class Day17: DayNN {
	init() {
		super.init("Conway Cubes")
		self.part1Tests = [
			testPart1(fileNumber: 1, expectedResult: "112"),
		]
		self.part2Tests = [
			testPart2(fileNumber: 1, expectedResult: "848"),
		]
	}

	// MARK: - Solving

	override func solvePart1(inputLines: [String]) -> String {
		var activePoints = PointSet3D(inputLines)
		for _ in 0..<6 {
			activePoints = activePoints.cycle()
		}
		return String(activePoints.allPoints.count)
	}

	override func solvePart2(inputLines: [String]) -> String {
		var activePoints = PointSet4D(inputLines)
		for _ in 0..<6 {
			activePoints = activePoints.cycle()
		}
		return String(activePoints.allPoints.count)
	}
}


