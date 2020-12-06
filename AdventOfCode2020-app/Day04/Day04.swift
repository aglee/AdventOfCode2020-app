import Foundation

class Day04: DayNN {
	init() {
		super.init("Passport Processing")
		self.part1Tests = [
			test(input: "2002", function: Passport.isValidBirthYear, expectedResult: true),
			test(input: "2003", function: Passport.isValidBirthYear, expectedResult: false),

			test(input: "60in", function: Passport.isValidHeight, expectedResult: true),
			test(input: "190cm", function: Passport.isValidHeight, expectedResult: true),
			test(input: "190in", function: Passport.isValidHeight, expectedResult: false),
			test(input: "190", function: Passport.isValidHeight, expectedResult: false),

			test(input: "#123abc", function: Passport.isValidHairColor, expectedResult: true),
			test(input: "#123abz", function: Passport.isValidHairColor, expectedResult: false),
			test(input: "123abc", function: Passport.isValidHairColor, expectedResult: false),

			test(input: "brn", function: Passport.isValidEyeColor, expectedResult: true),
			test(input: "wat", function: Passport.isValidEyeColor, expectedResult: false),

			test(input: "000000001", function: Passport.isValidPassportID, expectedResult: true),
			test(input: "0123456789", function: Passport.isValidPassportID, expectedResult: false),

			testPart1(fileNumber: 1, expectedResult: "2"),
		]
		self.part2Tests = [
			testPart2(fileNumber: 2, expectedResult: "0"),
			testPart2(fileNumber: 3, expectedResult: "4"),
		]
	}

	// MARK: - Solving

	override func solvePart1(inputLines: [String]) -> String {
		let passports = Passport.passports(linesToParse: inputLines)
		let numValid = passports.filter({ $0.hasRequiredFields() }).count
		return String(numValid)
	}

	override func solvePart2(inputLines: [String]) -> String {
		let passports = Passport.passports(linesToParse: inputLines)
		let numValid = passports.filter({ $0.hasRequiredValidFields() }).count
		return String(numValid)
	}

	// MARK: - Private stuff

}


