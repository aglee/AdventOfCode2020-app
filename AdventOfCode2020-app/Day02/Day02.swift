import Foundation

struct PasswordRule {
	private(set) var minCount: Int
	private(set) var maxCount: Int
	private(set) var requiredLetter: String

	func isValidPasswordPart1(_ s: String) -> Bool {
		let occurrenceCount = s.map({ String($0) }).filter({ $0 == requiredLetter }).count
		return (occurrenceCount >= minCount) && (occurrenceCount <= maxCount)
	}

	/// In Part 2 we use the two given numbers as character positions within the password.
	///
	/// **NOTE:** They are **1-based** indexes, not 0-based.
	func isValidPasswordPart2(_ s: String) -> Bool {
		let inputLetters = s.map { String($0) }
		let minMatches = (inputLetters[minCount - 1] == requiredLetter)
		let maxMatches = (inputLetters[maxCount - 1] == requiredLetter)
		return (minMatches && !maxMatches) || (!minMatches && maxMatches)
	}
}

class Day02: DayNN {
	init() {
		super.init("Password Philosophy")
		self.part1Tests = [
			testPart1(fileNumber: 1, expectedResult: "2")
		]
		self.part2Tests = [
			testPart2(fileNumber: 1, expectedResult: "1")
		]
	}

	// MARK: - Solving

	override func solvePart1(inputLines: [String]) -> String {
		func inputLineHasValidPassword(_ s: String) -> Bool {
			let (rule, password) = parseInputLine(s)
			return rule.isValidPasswordPart1(password)
		}

		let numValidInputLines = inputLines.filter({ inputLineHasValidPassword($0) }).count
		return String(numValidInputLines)
	}

	override func solvePart2(inputLines: [String]) -> String {
		func inputLineHasValidPassword(_ s: String) -> Bool {
			let (rule, password) = parseInputLine(s)
			return rule.isValidPasswordPart2(password)
		}

		let numValidInputLines = inputLines.filter({ inputLineHasValidPassword($0) }).count
		return String(numValidInputLines)
	}

	// MARK: - Private stuff

	/// Input lines look like this: "1-3 x: abcde".
	private func parseInputLine(_ s: String) -> (rule: PasswordRule, password: String) {
		// If the input is "1-3 x: abcde", then:
		// - `ruleString` will be "1-3 x"
		// - `password`   will be "abcde"
		let ruleAndPassword = s.components(separatedBy: ": ")
		let (ruleString, password) = (ruleAndPassword[0], String(ruleAndPassword[1]))

		// - `rangeString` will be "1-3"
		// - `letter`      will be "x"
		let rangeAndLetter = ruleString.split(separator: " ")
		let (rangeString, letter) = (rangeAndLetter[0], String(rangeAndLetter[1]))

		// - `minCount` will be 1
		// - `maxCount` will be 3
		let minAndMax = rangeString.split(separator: "-")
		let (minCount, maxCount) = (Int(minAndMax[0])!, Int(minAndMax[1])!)

		return (PasswordRule(minCount: minCount, maxCount: maxCount, requiredLetter: letter),
				password)
	}
}


