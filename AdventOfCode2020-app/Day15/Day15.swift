import Foundation

class MemoryGame {
	private var numTurnsTaken = 0
	private var lastNumberSpoken = -1

	/// Turn numbers in this dictionary are 1-based.
	private var lastTwoTurnsWhenSpoken = [Int: [Int]]()

	func play(input: String, numTurns: Int) -> String {
		let inputNums = input.split(separator: ",").map { Int($0)! }
		for n in inputNums {
			speak(n)
		}

		while numTurnsTaken < numTurns {
			takeOneTurn()
		}
		return String(lastNumberSpoken)
	}

	private func takeOneTurn() {
		let whenSpoken = lastTwoTurnsWhenSpoken[lastNumberSpoken]!
		if whenSpoken.count == 1 {
			speak(0)
		} else {
			speak(whenSpoken[whenSpoken.count - 1] - whenSpoken[whenSpoken.count - 2])
		}
	}

	private func speak(_ n: Int) {
		numTurnsTaken += 1
		lastNumberSpoken = n
		if let whenSpoken = lastTwoTurnsWhenSpoken[n] {
			lastTwoTurnsWhenSpoken[n] = [whenSpoken.last!, numTurnsTaken]
		} else {
			lastTwoTurnsWhenSpoken[n] = [numTurnsTaken]
		}
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
			// These tests take 14 seconds each with my brute-force implementation.
			// Unless and until I figure out a faster solution, I figure I can uncomment
			// them if I ever want to confirm for myself that they pass.  I ran the first
			// two and they passed, plus I got the right answer using the "real" input.
//			test(input: "0,3,6", function: { return self.solvePart2($0) }, expectedResult: "175594"),
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


