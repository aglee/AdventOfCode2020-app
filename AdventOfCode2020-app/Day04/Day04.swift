import Foundation

class Day04: DayNN {
	init() {
		super.init("Passport Processing")
		self.part1Tests = [
			testValidString(Passport.isValidBirthYear, "2002", true),
			testValidString(Passport.isValidBirthYear, "2003", false),

			testValidString(Passport.isValidHeight, "60in", true),
			testValidString(Passport.isValidHeight, "190cm", true),
			testValidString(Passport.isValidHeight, "190in", false),
			testValidString(Passport.isValidHeight, "190", false),

			testValidString(Passport.isValidHairColor, "#123abc", true),
			testValidString(Passport.isValidHairColor, "#123abz", false),
			testValidString(Passport.isValidHairColor, "123abc", false),

			testValidString(Passport.isValidEyeColor, "brn", true),
			testValidString(Passport.isValidEyeColor, "wat", false),

			testValidString(Passport.isValidPassportID, "000000001", true),
			testValidString(Passport.isValidPassportID, "0123456789", false),

			testPart1(fileNumber: 1, expectedOutput: "2"),
		]
		self.part2Tests = [
			testPart2(fileNumber: 2, expectedOutput: "0"),
			testPart2(fileNumber: 3, expectedOutput: "4"),
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


