import Foundation

class Day14: DayNN {
	init() {
		super.init("Docking Data")
		self.part1Tests = [
			testPart1(fileNumber: 1, expectedResult: "165"),
		]
		self.part2Tests = [
			testPart2(fileNumber: 2, expectedResult: "208"),
		]
	}

	// MARK: - Solving

	override func solvePart1(inputLines: [String]) -> String {
		return SeaportComputerForPart1().runProgram(inputLines)
	}

	override func solvePart2(inputLines: [String]) -> String {
		return SeaportComputerForPart2().runProgram(inputLines)
	}

	class SeaportComputer {
		fileprivate var mem = Memory()

		/// Subclasses override this.
		func updateMasks(using s: String) {
			abort()
		}

		/// Subclasses override this.  Each subclass does its own tweak to the address or
		/// value before updating `mem`.
		func updateMemory(rawAddress: Int, rawValue: Int) {
			abort()
		}

		func runProgram(_ inputLines: [String]) -> String {
			for line in inputLines {
				let lhsAndRhs = line.components(separatedBy: " = ")
				let lhs = lhsAndRhs[0]
				let rhs = lhsAndRhs[1]

				if lhs == "mask" {
					updateMasks(using: rhs)
				} else {
					// Parse the memory address and value.  Given "mem[1234]" and "5678",
					// we want 1234 and 5678.
					var addressString = lhs
					addressString.removeFirst(4)  // Remove the leading "mem["
					addressString.removeLast()  // Remove the trailing "]"
					let rawAddress = Int(addressString)!
					let rawValue = Int(rhs)!

					// Update memory using the given address and value.
					updateMemory(rawAddress: rawAddress, rawValue: rawValue)
				}
			}

			let sumOfMemoryContents = mem.valuesByAddress.values.reduce(0, +)
			return String(sumOfMemoryContents)
		}

		/// Every element of `chars` must be either "0" or "1".
		func intFromChars(_ chars: [String]) -> Int {
			return Int(chars.joined(), radix: 2)!
		}
	}

	class SeaportComputerForPart1: SeaportComputer {
		// These bitmasks are applied to the *values* placed in memory locations.
		private var unchangedBitmask = 0
		private var overwriteBitmask = 0

		override func updateMasks(using s: String) {
			let chars = s.map { String($0) }

			self.unchangedBitmask = intFromChars(chars.map { $0 == "X" ? "1" : "0" })
			self.overwriteBitmask = intFromChars(chars.map { $0 == "X" ? "0" : $0 })
		}

		override func updateMemory(rawAddress: Int, rawValue: Int) {
			mem[rawAddress] = ((rawValue & unchangedBitmask) | overwriteBitmask)
		}
	}

	class SeaportComputerForPart2: SeaportComputer {
		// These bitmasks are applied to memory *addresses*.
		private var unchangedBitmask = 0
		private var forcedOnesBitmask = 0
		private var maskForZeroingOutFloatingBits = 0
		private var floatingMasks = [Int]()

		override func updateMasks(using s: String) {
			let chars = s.map { String($0) }

			unchangedBitmask = intFromChars(chars.map { $0 == "0" ? "1" : "0" })
			forcedOnesBitmask = intFromChars(chars.map { $0 == "1" ? "1" : "0" })
			maskForZeroingOutFloatingBits = intFromChars(chars.map { $0 == "X" ? "0" : "1" })

			floatingMasks = []
			let floatingBitPositions = (0..<chars.count).filter { chars[$0] == "X" }  // NOTE: These are array indices, so they start at the left end.
			// Iterate over all possible subsets of `floatingBitPositions`.
			for subsetBits in 0..<(1 << floatingBitPositions.count) {
				var maskChars = Array(repeating: "0", count: chars.count)
				for bit in 0..<floatingBitPositions.count {
					if subsetBits & (1 << bit) != 0 {
						maskChars[floatingBitPositions[bit]] = "1"
					}
				}
				floatingMasks.append(intFromChars(maskChars))
			}
		}

		override func updateMemory(rawAddress: Int, rawValue: Int) {
			let address = ((rawAddress & unchangedBitmask) | forcedOnesBitmask)

			for floatingMask in floatingMasks {
				mem[address | floatingMask] = rawValue
			}
		}
	}
}


