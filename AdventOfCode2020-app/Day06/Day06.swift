import Foundation

class Day06: DayNN {
	init() {
		super.init("Custom Customs")
		self.part1Tests = [
			testPart1(fileNumber: 1, expectedResult: "6"),
			test(fileNumber: 2,
				 function: { self.sumString(self.countsForPart1($0)) },
				 expectedResult: "3 + 3 + 3 + 1 + 1"),
		]
		self.part2Tests = [
			test(fileNumber: 2,
				 function: { self.sumString(self.countsForPart2($0)) },
				 expectedResult: "3 + 0 + 1 + 1 + 1"),
		]
	}

	/// `[1, 2, 3] => "1 + 2 + 3"`
	private func sumString(_ nums: [Int]) -> String {
		return nums.map { String($0) }.joined(separator: " + ")
	}

	// MARK: - Solving

	private func countsForPart1(_ inputLines: [String]) -> [Int] {
		func questionsAnsweredYesBy_ANY_(inGroup group: [String]) -> Set<Character> {
			var questionsAnswered = Set<Character>()
			for line in group {
				questionsAnswered.formUnion(line)
			}
			//print(questionsAnswered.sorted())
			return questionsAnswered
		}

		let groups = groupedLines(inputLines)
		let setsOfLetters = groups.map { questionsAnsweredYesBy_ANY_(inGroup: $0) }
		return setsOfLetters.map { $0.count }
	}

	override func solvePart1(inputLines: [String]) -> String {
		let total = countsForPart1(inputLines).reduce(0, { $0 + $1 })
		return String(total)
	}

	private func countsForPart2(_ inputLines: [String]) -> [Int] {
		func questionsAnsweredYesBy_ALL_(inGroup group: [String]) -> Set<Character> {
			var questionsAnswered = Set("abcdefghijklmnopqrstuvwxyz")
			for line in group {
				questionsAnswered.formIntersection(line)
			}
			//print(questionsAnswered.sorted())
			return questionsAnswered
		}

		let groups = groupedLines(inputLines)
		let setsOfLetters = groups.map { questionsAnsweredYesBy_ALL_(inGroup: $0) }
		return setsOfLetters.map { $0.count }
	}

	override func solvePart2(inputLines: [String]) -> String {
		let total = countsForPart2(inputLines).reduce(0, { $0 + $1 })
		return String(total)
	}
}


