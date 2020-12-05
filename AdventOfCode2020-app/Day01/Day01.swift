import Foundation

class Day01: DayNN {
	init() {
		super.init("Report Repair")
		self.part1Tests = [
			testPart1(fileNumber: 1, expectedOutput: "514579")
		]
		self.part2Tests = [
			testPart2(fileNumber: 1, expectedOutput: "241861950")
		]
	}

	// MARK: - Solving

	override func solvePart1(inputLines: [String]) -> String {
		let nums = inputLines.map { Int($0)! }
		for k in nums {
			if nums.contains(2020 - k) {
				return String(k * (2020 - k))
			}
		}

		// We shouldn't get this far.
		abort()
	}

	override func solvePart2(inputLines: [String]) -> String {
		let nums = inputLines.map { Int($0)! }

		for i in 0..<(nums.count - 2) {
			for j in (i + 1)..<(nums.count - 1) {
				for k in (j + 1)..<nums.count {
					if nums[i] + nums[j] + nums[k] == 2020 {
						return String(nums[i] * nums[j] * nums[k])
					}
				}
			}
		}

		// We shouldn't get this far.
		abort()
	}
}


