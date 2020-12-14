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
		return DecoderForPart1().runProgram(inputLines)
	}

	override func solvePart2(inputLines: [String]) -> String {
		return DecoderForPart2().runProgram(inputLines)
	}

	/// Abstract base class with two subclasses, for solving Parts 1 and 2.
	class Decoder {
		/// The computer's memory storage.
		fileprivate var mem = Memory()

		/// Subclasses override this.  Uses `s` to generate bitmasks that are used
		/// internally, and are specific to each subclass.
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
					// Case 1: The input line has the form "mask = ...".
					updateMasks(using: rhs)
				} else {
					// Case 2: The input line has the form "mem[1234] = 5678".  In this
					// example we would want to parse 1234 and 5678 as the "raw" address
					// and "raw" value.
					var addressString = lhs
					addressString.removeFirst(4)  // Remove the leading "mem["
					addressString.removeLast()  // Remove the trailing "]"
					let rawAddress = Int(addressString)!
					let rawValue = Int(rhs)!

					// Update memory using the raw address and value.  These won't be
					// the actual memory address and value used.  Our subclass's
					// implementation of `updateMemory` will decide what actual value or
					// values are stored at what actual address or addresses.
					updateMemory(rawAddress: rawAddress, rawValue: rawValue)
				}
			}

			// Both Part 1 and Part 2 want the sum of the contents of memory after we've
			// run the given program.
			let sumOfMemoryContents = mem.valuesByAddress.values.reduce(0, +)
			return String(sumOfMemoryContents)
		}

		/// Every element of `chars` must be either "0" or "1".
		func maskFromChars(_ chars: [String]) -> Int {
			return Int(chars.joined(), radix: 2)!
		}
	}

	class DecoderForPart1: Decoder {
		// These bitmasks are applied to raw *values* before they are stored in memory.
		private var unchangedBitmask = 0
		private var overwriteBitmask = 0

		override func updateMasks(using s: String) {
			let chars = s.map { String($0) }
			self.unchangedBitmask = maskFromChars(chars.map { $0 == "X" ? "1" : "0" })
			self.overwriteBitmask = maskFromChars(chars.map { $0 == "X" ? "0" : $0 })
		}

		/// Uses the current masks to derive a value based on `rawValue`.  Stores that
		/// derived value at `rawAddress`.
		override func updateMemory(rawAddress: Int, rawValue: Int) {
			mem[rawAddress] = ((rawValue & unchangedBitmask) | overwriteBitmask)
		}
	}

	class DecoderForPart2: Decoder {
		// These bitmasks are applied to memory *addresses*.
		private var unchangedBitmask = 0
		private var forcedOnesBitmask = 0
		private var maskForZeroingOutFloatingBits = 0
		private var floatingMasks = [Int]()

		override func updateMasks(using s: String) {
			let chars = s.map { String($0) }

			unchangedBitmask = maskFromChars(chars.map { $0 == "0" ? "1" : "0" })
			forcedOnesBitmask = maskFromChars(chars.map { $0 == "1" ? "1" : "0" })
			maskForZeroingOutFloatingBits = maskFromChars(chars.map { $0 == "X" ? "0" : "1" })
			floatingMasks = calculateFloatingMasks(chars)
		}

		/// Uses the current masks to derive one or more addresses from `rawAddress`.
		/// Stores `rawValue` at all those addresses.
		override func updateMemory(rawAddress: Int, rawValue: Int) {
			let address = ((rawAddress & unchangedBitmask) | forcedOnesBitmask)

			for floatingMask in floatingMasks {
				mem[address | floatingMask] = rawValue
			}
		}

		private func calculateFloatingMasks(_ chars: [String]) -> [Int] {
			// Find all the array indices where `chars` contains an "X".
			let floatingBitPositions = (0..<chars.count).filter { chars[$0] == "X" }

			// Iterate over all possible subsets of those array indices.  Each of those
			// subsets defines an element to add to the result.
			var result = [Int]()
			for subsetBits in 0..<(1 << floatingBitPositions.count) {
				var maskChars = Array(repeating: "0", count: chars.count)
				for bit in 0..<floatingBitPositions.count {
					if subsetBits & (1 << bit) != 0 {
						maskChars[floatingBitPositions[bit]] = "1"
					}
				}
				result.append(maskFromChars(maskChars))
			}

			return result
		}
	}
}


