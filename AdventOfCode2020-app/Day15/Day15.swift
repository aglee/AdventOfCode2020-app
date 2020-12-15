import Foundation

class MemoryGame {
	private var lastNumberSpoken = -1

	/// The turn number on which `lastNumberSpoken` was spoken.  Turn numbers are 1-based:
	/// the first turn has turn number 1, the second turn number 2, etc.
	private var lastTurnNumber = 0

	/// Keys are all the numbers that have ever been spoken, *except* for the last.
	/// Values are the turn number of the last time that number was spoken.
	private var history = [Int: Int]()

	func play(input: String, numTurns: Int) -> String {
		assert(!input.isEmpty, "This only works if the input string is non-empty.")
		let inputNums = input.split(separator: ",").map { Int($0)! }
		for n in inputNums {
			speak(n)
		}
		while lastTurnNumber < numTurns {
			speakNext()
		}
		return String(lastNumberSpoken)
	}

	private func speakNext() {
		assert(history.count > 0,
			   "This method should only be called after the initial numbers have all been spoken.")
		if let whenLastNumberWasPreviouslySpoken = history[lastNumberSpoken] {
			speak(lastTurnNumber - whenLastNumberWasPreviouslySpoken)
		} else {
			speak(0)
		}
	}

	private func speak(_ n: Int) {
		if lastTurnNumber > 0 {
			history[lastNumberSpoken] = lastTurnNumber
		}
		lastTurnNumber += 1
		lastNumberSpoken = n
	}
}

class Day15: DayNN {
	init() {
		super.init("Rambunctious Recitation")
		self.part1Tests = [
			test(input: "0,3,6", function: { return self.solvePart1($0) }, expectedResult: "436"),
			test(input: "1,3,2", function: { return self.solvePart1($0) }, expectedResult: "1"),
			test(input: "2,1,3", function: { return self.solvePart1($0) }, expectedResult: "10"),
			test(input: "1,2,3", function: { return self.solvePart1($0) }, expectedResult: "27"),
			test(input: "2,3,1", function: { return self.solvePart1($0) }, expectedResult: "78"),
			test(input: "3,2,1", function: { return self.solvePart1($0) }, expectedResult: "438"),
			test(input: "3,1,2", function: { return self.solvePart1($0) }, expectedResult: "1836"),
		]
		self.part2Tests = [
			// These tests take 7 seconds each on my first-gen M1 MBA.  I figure it's
			// enough to run just one of them to be comfortable that my solution works.
			test(input: "0,3,6", function: { return self.solvePart2($0) }, expectedResult: "175594"),
//			test(input: "1,3,2", function: { return self.solvePart2($0) }, expectedResult: "2578"),
//			test(input: "2,1,3", function: { return self.solvePart2($0) }, expectedResult: "3544142"),
//			test(input: "1,2,3", function: { return self.solvePart2($0) }, expectedResult: "261214"),
//			test(input: "2,3,1", function: { return self.solvePart2($0) }, expectedResult: "6895259"),
//			test(input: "3,2,1", function: { return self.solvePart2($0) }, expectedResult: "18"),
//			test(input: "3,1,2", function: { return self.solvePart2($0) }, expectedResult: "362"),
		]
	}

	// MARK: - Solving

	private func solvePart1(_ s: String) -> String {
		return MemoryGame().play(input: s, numTurns: 2020)
	}

	private func solvePart2(_ s: String) -> String {
		return MemoryGame().play(input: s, numTurns: 30_000_000)
	}

	override func solvePart1(inputLines: [String]) -> String {
		return solvePart1(inputLines[0])
	}

	override func solvePart2(inputLines: [String]) -> String {
		return solvePart2(inputLines[0])
	}
}


