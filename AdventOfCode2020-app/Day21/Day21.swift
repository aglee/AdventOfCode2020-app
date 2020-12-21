import Foundation

class Day21: DayNN {
	init() {
		super.init("Allergen Assessment")
		self.part1Tests = [
			testPart1(fileNumber: 1, expectedResult: "5"),
		]
		self.part2Tests = [
			testPart2(fileNumber: 1, expectedResult: "mxmxvkd,sqjhc,fvjkl"),
		]
	}

	// MARK: - Solving

	override func solvePart1(inputLines: [String]) -> String {
		let menu = Menu(inputLines)
		return menu.solvePart1()
	}

	override func solvePart2(inputLines: [String]) -> String {
		let menu = Menu(inputLines)
		return menu.solvePart2()
	}
}


