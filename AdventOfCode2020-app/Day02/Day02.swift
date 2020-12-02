//
//  Day01.swift
//  AdventOfCode2020-app
//
//  Created by Andy Lee on 11/30/20.
//

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
	func isValidPasswordPart2(_ s: String) -> Bool {
		let inputLetters = s.map { String($0) }
		let minMatches = (inputLetters[minCount] == requiredLetter)
		let maxMatches = (inputLetters[maxCount] == requiredLetter)
		return (minMatches && !maxMatches) || (!minMatches && maxMatches)
	}
}

class Day02: DayNN {
	override var expectedPart1TestResults: [Int : String] {
		return [1: "2"]
	}
	override var expectedPart2TestResults: [Int : String] {
		return [1: "1"]
	}

	init() {
		super.init("Password Philosophy")
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
		// - `rule`     will be "1-3 x"
		// - `password` will be "abcde"
		let ruleAndPassword = s.split(separator: ":")
		let (ruleString, password) = (ruleAndPassword[0], String(ruleAndPassword[1]))

		// - `range`  will be "1-3"
		// - `letter` will be "x"
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


