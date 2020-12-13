import Foundation

class Day13: DayNN {
	init() {
		super.init("Shuttle Search")
		self.part1Tests = [
			testPart1(fileNumber: 1, expectedResult: "295"),
		]
		self.part2Tests = [
			testPart2(fileNumber: 1, expectedResult: "1068781"),
			test(input: "17,x,13,19", function: { return self.solvePart2($0) }, expectedResult: "3417"),
			test(input: "67,7,59,61", function: { return self.solvePart2($0) }, expectedResult: "754018"),
			test(input: "67,x,7,59,61", function: { return self.solvePart2($0) }, expectedResult: "779210"),
			test(input: "67,7,x,59,61", function: { return self.solvePart2($0) }, expectedResult: "1261476"),
			test(input: "1789,37,47,1889", function: { return self.solvePart2($0) }, expectedResult: "1202161486"),
		]
	}

	// MARK: - Solving

	override func solvePart1(inputLines: [String]) -> String {
		func parseBusNumbers(_ s: String) -> [Int] {
			let elements = s.components(separatedBy: ",")
			let validElements = elements.filter { $0 != "x" }
			return validElements.map { Int($0)! }
		}

		let earliestTime = Int(inputLines[0])!
		let busNumbers = parseBusNumbers(inputLines[1])

		var shortestWait = Int.max
		var bestBus = -1
		for bus in busNumbers {
			let timeSinceLastBus = earliestTime % bus
			if timeSinceLastBus == 0 {
				return "0"
			}
			let timeToNextBus = bus - timeSinceLastBus
			if timeToNextBus < shortestWait {
				shortestWait = timeToNextBus
				bestBus = bus
			}
		}

		return String(bestBus * shortestWait)
	}

	/// The key was the Chinese Remainder Theorem.
	func solvePart2(_ s: String) -> String {
		let elements = s.components(separatedBy: ",")
		var pairs: [(offset: Int, modulus: Int)] = []
		for (i, s) in elements.enumerated() {
			if s != "x" {
				pairs.append((offset: i, modulus: Int(s)!))
			}
		}

		var t = 0
		var jumpSize = 1
		for pair in pairs {
			while true {
				if (t + pair.offset) % pair.modulus == 0 {
					break
				}
				t += jumpSize
			}
			jumpSize *= pair.modulus
		}

		return String(t)
	}

	override func solvePart2(inputLines: [String]) -> String {
		return solvePart2(inputLines[1])
	}

}


