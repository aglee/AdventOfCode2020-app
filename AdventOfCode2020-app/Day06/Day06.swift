import Foundation

class Day06: DayNN {
	init() {
		super.init("Custom Customs")
		self.part1Tests = [
			testPart1(fileNumber: 1, expectedResult: "6"),
			test(fileNumber: 2,
				 function: {
					let groups = groupedLines($0)
					let setsOfLetters = groups.map { self.questionsAnsweredYesBy_ANY_(inGroup: $0) }
					let counts = setsOfLetters.map { $0.count }
					return counts.map { String($0) }.joined(separator: " + ")
				 },
				 expectedResult: "3 + 3 + 3 + 1 + 1"),
		]
		self.part2Tests = [
			testPart2(fileNumber: 2, expectedResult: "6"),
		]
	}

	// MARK: - Solving

	func questionsAnsweredYesBy_ANY_(inGroup group: [String]) -> Set<Character> {
		var questionsAnswered = Set<Character>()
		for line in group {
			questionsAnswered.formUnion(line)
		}
		//print(questionsAnswered.sorted())
		return questionsAnswered
	}

	override func solvePart1(inputLines: [String]) -> String {
		let groups = groupedLines(inputLines)
		return String(groups.reduce(0, { $0 + questionsAnsweredYesBy_ANY_(inGroup: $1).count }))
	}

	func questionsAnsweredYesBy_ALL_(inGroup group: [String]) -> Set<Character> {
		var questionsAnswered = Set("abcdefghijklmnopqrstuvwxyz")
		for line in group {
			questionsAnswered.formIntersection(line)
		}
		//print(questionsAnswered.sorted())
		return questionsAnswered
	}

	override func solvePart2(inputLines: [String]) -> String {
		let groups = groupedLines(inputLines)
		return String(groups.reduce(0, { $0 + questionsAnsweredYesBy_ALL_(inGroup: $1).count }))
	}
}


