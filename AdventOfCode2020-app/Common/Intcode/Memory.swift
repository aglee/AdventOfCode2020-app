//
//  Memory.swift
//  AdventOfCode2020-app
//
//  Created by Andy Lee on 11/30/20.
//

import Foundation

/// Represents an infinitely large memory buffer, where the value at each address is an
/// Int, and which is initialized to all zeroes.
///
/// You can access memory values using subscript notation as if it were an array of Int:
///
/// ```
/// myMemory[a] = b
/// b = myMemory[a]
/// ```
struct Memory {
	/// Maps addresses to values.
	private var valuesByAddress = [Int: Int]()

	init(memoryValues: [Int]) {
		for (address, value) in memoryValues.enumerated() {
			valuesByAddress[address] = value
		}
	}

	subscript(address: Int) -> Int {
		get {
			assert(address >= 0, "Can't get memory from negative address \(address)")
			return valuesByAddress[address] ?? 0
		}
		set {
			assert(address >= 0, "Can't set memory at negative address \(address)")
			valuesByAddress[address] = (newValue == 0 ? nil : newValue)
		}
	}
}

