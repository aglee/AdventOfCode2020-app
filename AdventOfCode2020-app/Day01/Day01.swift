//
//  Day01.swift
//  AdventOfCode2020-app
//
//  Created by Andy Lee on 11/30/20.
//

import Foundation

class Day01: DayNN {
	override var expectedPart1TestResults: [Int : String] {
		return [1: "514579"]
	}
	override var expectedPart2TestResults: [Int : String] {
		return [1: "241861950"]
	}

	init() {
		super.init(dayNumber: 1, title: "Report Repair")
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


