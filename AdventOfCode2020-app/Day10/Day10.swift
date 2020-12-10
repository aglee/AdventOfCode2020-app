import Foundation

class Day10: DayNN {
	init() {
		super.init("Adapter Array")
		self.part1Tests = [
			testPart1(fileNumber: 1, expectedResult: "35"),
			testPart1(fileNumber: 2, expectedResult: "220"),
		]
		self.part2Tests = [
			testPart2(fileNumber: 1, expectedResult: "8"),
			testPart2(fileNumber: 2, expectedResult: "19208"),
		]
	}

	// MARK: - Solving

	// Chaining all the adapters we're given means sorting the array of numbers, since
	// each adapter must have a higer rating than the previous one.  Part 1 can be
	// expressed as: in traversing the sorted array of numbers, how many jumps are 1's
	// and how many are 3's?
	override func solvePart1(inputLines: [String]) -> String {
		let adapters = inputLines.map { Int($0)! }.sorted()
		var jolts = 0
		var ones = 0
		var threes = 0
		for num in adapters {
			if num - jolts == 1 {
				ones += 1
			} else if num - jolts == 3 {
				threes += 1
			}
			jolts = num
		}

		// Add 1 to the `threes` count, corresponding to the jump from the last adapter to
		// the device's built-in adapter.
		return String(ones * (threes + 1))
	}

	// Part 2 can be expressed as: how many subsequences of the sorted array are there
	// such that any pair of consecutive elements differ by at most 3?
	override func solvePart2(inputLines: [String]) -> String {
		// Insert the starting 0, representing the charging outlet at which we'll start
		// chaining adapters, at the beginning of the list.  This makes the logic a little
		// simpler.
		var adapters = inputLines.map { Int($0)! }.sorted()
		adapters.insert(0, at: 0)
		let numAdapters = adapters.count

		// Calculate the array of "jumps" from each number to the next.
		var jumps = Array(repeating: 0, count: numAdapters)
		jumps[0] = adapters[0]
		for i in (1..<numAdapters) {
			jumps[i] = adapters[i] - adapters[i - 1]
		}

		// The `waysToProceed` array will contain the number of ways for a subsequence to
		// proceed from `adapters[i]`, if that adapter is in the subsequence.  We're going
		// to fill in `waysToProceed` backwards, from the end to the beginning.  Note that
		// all valid subsequences must end on the last adapter in the list, because every
		// jump has to be at most 3, and the device's built-in adapter is rated 3 higher
		// than the highest-rated adapter in the list.
		var waysToProceed = Array(repeating: 0, count: numAdapters)

		// Once we've reached the last adapter in the list (call it Z), there's only one
		// way to proceed, namely to connect to the device.
		waysToProceed[numAdapters - 1] = 1

		// If a subsequence includes the second-to-last adapter in the list (call it Y),
		// there is only one way to proceed, namely Y-Z (remember, the subsequence must
		// include the last adapter).
		waysToProceed[numAdapters - 2] = 1

		// If a subsequence includes the third-to-last adapter in the list (call it X),
		// there are two cases.
		if jumps[numAdapters - 2] + jumps[numAdapters - 1] <= 3 {
			// Case 1: X-Y-Z and X-Z are both possible ways to proceed.
			waysToProceed[numAdapters - 3] = 2
		} else {
			// Case 2: X-Z is the only possible way to proceed.
			waysToProceed[numAdapters - 3] = 1
		}

		// Now that we have the last 3 elements of `waysToProceed`, fill in the remaining
		// numbers, working backwards.
		for i in (0...(numAdapters - 4)).reversed() {
			// We can always go from i to i+1.
			waysToProceed[i] = waysToProceed[i + 1]

			// Can we go from i to i+2?  If so, add those possibilities.
			if jumps[i + 1] + jumps[i + 2] <= 3 {
				waysToProceed[i] += waysToProceed[i + 2]
			}

			// Can we go from i to i + 3?  If so, add those possibilities.
			if jumps[i + 1] + jumps[i + 2] + jumps[i + 3] <= 3 {
				waysToProceed[i] += waysToProceed[i + 3]
			}
		}

		// The answer we want is the number of ways to proceed from the charging outlet,
		// which is represented by the initial 0 in the list.
		return String(waysToProceed[0])
	}
}


