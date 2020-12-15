import Foundation

class MemoryGame {
	var numTurnsTaken = 0
	var lastNumberSpoken = -1
	var turnNumbersWhenSpoken = [Int: [Int]]()


	var spokenNumbers = [Int]()


	init(_ s: String) {
		let inputNums = s.split(separator: ",").map { Int($0)! }
		for n in inputNums {
			speak(n)
		}
	}

	func takeOneTurn() {
		let whenSpoken = turnNumbersWhenSpoken[lastNumberSpoken]!
		if whenSpoken.count == 1 {
			speak(0)
		} else {
			speak(whenSpoken[whenSpoken.count - 1] - whenSpoken[whenSpoken.count - 2])
		}
	}

	func speak(_ n: Int) {


//		spokenNumbers.append(n)


		numTurnsTaken += 1
		lastNumberSpoken = n
		if let whenSpoken = turnNumbersWhenSpoken[n] {
			turnNumbersWhenSpoken[n] = [whenSpoken.last!, numTurnsTaken]
		} else {
			turnNumbersWhenSpoken[n] = [numTurnsTaken]
		}
	}
}

class Day15: DayNN {
	init() {
		super.init("PUT_DESCRIPTION_HERE")
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
//			test(input: "0,3,6", function: { return self.solvePart2($0) }, expectedResult: "175594"),
//			test(input: "1,3,2", function: { return self.solvePart2($0) }, expectedResult: "2578"),
		]
	}

	// MARK: - Solving

	private func solvePart1(_ s: String) -> String {
		let game = MemoryGame(s)
		while game.numTurnsTaken < 2020 {
			game.takeOneTurn()
		}
		return String(game.lastNumberSpoken)
	}

	private func solvePart2(_ s: String) -> String {
		NSLog("START")
		let game = MemoryGame(s)
		while game.numTurnsTaken < 30_000_000 {
			if game.numTurnsTaken % 1_000_000 == 0 {
				NSLog("    numTurnsTaken = %ld", game.numTurnsTaken)
			}
			game.takeOneTurn()
		}
		NSLog("FINISH")
		return String(game.lastNumberSpoken)
	}

	override func solvePart1(inputLines: [String]) -> String {
		return solvePart1(inputLines[0])
	}

	override func solvePart2(inputLines: [String]) -> String {
		return solvePart2(inputLines[0])
	}
}


