import Foundation

class Day04: DayNN {
	override var expectedPart1TestResults: [Int : String] {
		return [1: "2"]
	}
	override var expectedPart2TestResults: [Int : String] {
		// No passports are valid in file 2.  All are valid in file 3.
		return [2: "0", 3: "4"]
	}

	init() {
		super.init("Passport Processing")
	}

	// MARK: - Solving

	override func solvePart1(inputLines: [String]) -> String {
		let passports = Passport.passports(linesToParse: inputLines)
		let numValid = passports.filter({ $0.hasRequiredFields() }).count
		return String(numValid)
	}

	override func solvePart2(inputLines: [String]) -> String {
		let passports = Passport.passports(linesToParse: inputLines)
		let numValid = passports.filter({ $0.isStrictlyValid() }).count
		return String(numValid)
	}

	// MARK: - Private stuff

}


