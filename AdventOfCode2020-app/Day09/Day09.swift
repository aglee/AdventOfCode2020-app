import Foundation

/// Used to solve Part 1.  By "window" I mean "subsequence of the list of numbers".
func findBadNumber(numbers: [Int], windowSize: Int) -> Int {
	for windowStart in 0..<(numbers.count - windowSize) {
		// Calculate all possible pairwise sums within the window.
		var possibleSums = Set<Int>()
		for i in windowStart..<(windowStart + windowSize - 1) {
			for j in (i + 1)..<(windowStart + windowSize) {
				if numbers[i] != numbers[j] {
					possibleSums.insert(numbers[i] + numbers[j])
				}
			}
		}

		// If the number immediately after the window is *not* one of those sums, we have
		// our answer.
		if !possibleSums.contains(numbers[windowStart + windowSize]) {
			return numbers[windowStart + windowSize]
		}
	}

	// We should not get this far.
	abort()
}

/// Used to solve Part 2.  Note that Part 2 requires finding the **min and max** within
/// the subsequence.
func findSubsequenceWithSum(numbers: [Int], targetSum: Int) -> (firstIndex: Int, lastIndex: Int) {
	var (firstIndex, lastIndex) = (0, 0)
	var currentSum = numbers[firstIndex]
	while true {
		// If the current sum is too small, make it bigger by incrementing `lastIndex`.
		// If the current sum is too big, make it smaller by incrementing `firstIndex`.
		if currentSum == targetSum {
			return(firstIndex, lastIndex)
		} else if currentSum < targetSum {
			lastIndex += 1
			currentSum += numbers[lastIndex]
		} else {
			currentSum -= numbers[firstIndex]
			firstIndex += 1
		}
	}
}

class Day09: DayNN {
	init() {
		super.init("Encoding Error")
		self.part1Tests = [
			test(fileNumber: 1,
				 function: { self.solvePart1(inputLines: $0, windowSize: 5) },
				 expectedResult: "127")
		]
		self.part2Tests = [
			test(fileNumber: 1,
				 function: { self.solvePart2(inputLines: $0, windowSize: 5) },
				 expectedResult: "62")
		]
	}

	// MARK: - Solving

	private func solvePart1(inputLines: [String], windowSize: Int) -> String {
		let numbers = inputLines.map { Int($0)! }
		return String(findBadNumber(numbers: numbers, windowSize: windowSize))
	}

	override func solvePart1(inputLines: [String]) -> String {
		return solvePart1(inputLines: inputLines, windowSize: 25)
	}

	private func solvePart2(inputLines: [String], windowSize: Int) -> String {
		let numbers = inputLines.map { Int($0)! }
		let targetSum = findBadNumber(numbers: numbers, windowSize: windowSize)
		let (firstIndex, lastIndex) = findSubsequenceWithSum(numbers: numbers, targetSum: targetSum)
		let subsequence = numbers[firstIndex...lastIndex]
		let (smallest, largest) = (subsequence.min()!, subsequence.max()!)
		return String(smallest + largest)
	}

	override func solvePart2(inputLines: [String]) -> String {
		return solvePart2(inputLines: inputLines, windowSize: 25)
	}

}


