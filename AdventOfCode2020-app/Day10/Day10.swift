import Foundation

class Day10: DayNN {
	init() {
		super.init("DayXX")
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

	override func solvePart1(inputLines: [String]) -> String {
		let sortedAdapterRatings = inputLines.map { Int($0)! }.sorted()
		var jolts = 0
		var ones = 0
		var threes = 0
		for num in sortedAdapterRatings {
			if num - jolts == 1 {
				ones += 1
			} else if num - jolts == 3 {
				threes += 1
			}
			jolts = num
		}

		return String(ones * (threes + 1))
	}

	override func solvePart2(inputLines: [String]) -> String {
		// Insert the starting 0 at the beginning of the list of adapters.
		var sortedAdapterRatings = inputLines.map { Int($0)! }.sorted()
		sortedAdapterRatings.insert(0, at: 0)
		let numAdapters = sortedAdapterRatings.count

		var jumps = Array(repeating: 0, count: numAdapters)
		jumps[0] = sortedAdapterRatings[0]
		for i in (1..<numAdapters) {
			jumps[i] = sortedAdapterRatings[i] - sortedAdapterRatings[i - 1]
		}

		// This array will contain the number of ways to proceed if our chain has brought us to adapter[i].  We're going to fill in the array from last element to first.  Note that all valid paths through the sequence must end on the last adapter in the chain.
		var waysToProceed = Array(repeating: 0, count: numAdapters)

		// Once we've reached the last adapter in the chain (call it Z), there's only one way to proceed, namely to connect to the device.
		waysToProceed[numAdapters - 1] = 1

		// If we've reached the second-to-last adapter in the chain (call it Y), there is again only one way to proceed, namely Y-Z (remember, our chain has to include the last adapter).
		waysToProceed[numAdapters - 2] = 1

		// If we've reached the third-to-last adapter in the chain (call it X) there are two cases: (a) if Y and Z both have jumps of 1, then there are 2 ways to proceed, namely X-Y-Z and X-Z; (b) otherwise there is only one way to proceed, namely X-Z.
		if jumps[numAdapters - 2] + jumps[numAdapters - 1] <= 3 {
			// Case 1: X-Y-Z and X-Z are both possibilities.
			waysToProceed[numAdapters - 3] = 2
		} else {
			// Case 2: only X-Z is a possibility.
			waysToProceed[numAdapters - 3] = 1
		}

		// Now we fill in the remaining numbers of ways to proceed, working backwards.
		for i in (0...(numAdapters - 4)).reversed() {
			// We can always go from i to i+1, so start with that.
			waysToProceed[i] = waysToProceed[i + 1]

			// Can we go from i to i+2?
			if jumps[i + 1] + jumps[i + 2] <= 3 {
				waysToProceed[i] += waysToProceed[i + 2]
			}

			// Can we go from i to i + 3?
			if jumps[i + 1] + jumps[i + 2] + jumps[i + 3] <= 3 {
				waysToProceed[i] += waysToProceed[i + 3]
			}
		}

		// The answer we want is the number of ways to proceed from the starting 0.
		return String(waysToProceed[0])
	}

}


