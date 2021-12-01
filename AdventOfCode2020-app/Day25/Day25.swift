import Foundation

class Day25: DayNN {
	init() {
		super.init("Combo Breaker")
		self.part1Tests = [
			test(input: "5764801",
				 function: { String(self.loopSizeProducingPublicKey(Int($0)!)) },
				 expectedResult: "8"),
			test(input: "17807724",
				 function: { String(self.loopSizeProducingPublicKey(Int($0)!)) },
				 expectedResult: "11"),
			testPart1(fileNumber: 1, expectedResult: "14897079"),
		]
		self.part2Tests = [
			// There's no Part 2 on Day 25. :)
		]
	}

	// MARK: - Solving

	func transform(subjectNumber: Int, loopSize: Int) -> Int {
		var value = 1
		for _ in 0..<loopSize {
			value = (value * subjectNumber) % 20201227
		}
		return value
	}

	func loopSizeProducingPublicKey(_ publicKey: Int) -> Int {
		var loopSize = 0
		var value = 1
		while true {
			if value == publicKey {
				return loopSize
			}
			value = (value * 7) % 20201227
			loopSize += 1
		}
	}

	override func solvePart1(inputLines: [String]) -> String {
		let publicKey1 = Int(inputLines[0])!
		let publicKey2 = Int(inputLines[1])!

		let loopSize1 = loopSizeProducingPublicKey(publicKey1)
		let loopSize2 = loopSizeProducingPublicKey(publicKey2)

		let encryptionKey1 = transform(subjectNumber: publicKey2, loopSize: loopSize1)
		let encryptionKey2 = transform(subjectNumber: publicKey1, loopSize: loopSize2)
		assert(encryptionKey1 == encryptionKey2)

		return String(encryptionKey1)
	}

	override func solvePart2(inputLines: [String]) -> String {
		return "There is no Part 2 for Day 25. :)"
	}
}


