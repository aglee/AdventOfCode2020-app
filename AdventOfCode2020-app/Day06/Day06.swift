import Foundation

class Day06: DayNN {
	init() {
		super.init("Custom Customs")
		self.part1Tests = [
			testPart1(fileNumber: 1, expectedOutput: "6"),
			testPart1(fileNumber: 2, expectedOutput: "11"),
		]
		self.part2Tests = [
			testPart2(fileNumber: 2, expectedOutput: "6"),
		]
	}

	// MARK: - Solving

	override func solvePart1(inputLines: [String]) -> String {
		func questionsAnsweredYesBy_ANY_(inGroup group: [String]) -> Set<Character> {
			var questionsAnswered = Set<Character>()
			for line in group {
				questionsAnswered.formUnion(line)
			}
			//print(questionsAnswered.sorted())
			return questionsAnswered
		}

		let groups = groupedLines(inputLines)
		return String(groups.reduce(0, { $0 + questionsAnsweredYesBy_ANY_(inGroup: $1).count }))
	}

	override func solvePart2(inputLines: [String]) -> String {
		func questionsAnsweredYesBy_ALL_(inGroup group: [String]) -> Set<Character> {
			var questionsAnswered = Set("abcdefghijklmnopqrstuvwxyz")
			for line in group {
				questionsAnswered.formIntersection(line)
			}
			//print(questionsAnswered.sorted())
			return questionsAnswered
		}

		let groups = groupedLines(inputLines)
		return String(groups.reduce(0, { $0 + questionsAnsweredYesBy_ALL_(inGroup: $1).count }))
	}
}


