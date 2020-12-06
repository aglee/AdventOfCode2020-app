import Foundation

struct BoardingPass {
	let row: Int
	let column: Int
	var seatID: Int { return row*8 + column }
	var displayString: String  { return "row \(row), column \(column), seat ID \(seatID)" }

	/// To get the row number, treat the first 7 characters as a binary number with
	/// digits "F" and "B" instead of "0" and "1".  To get the column number, treat
	/// the last 3 characters as a binary number with digits "L" and "R" instead of
	/// "0" and "1".
	init(_ s: String) {
		assert(s.count == 10, "Seat specification must have 10 characters")
		let rowString =
			s.prefix(7)
			.replacingOccurrences(of: "F", with: "0")
			.replacingOccurrences(of: "B", with: "1")
		let columnString =
			s.suffix(3)
			.replacingOccurrences(of: "L", with: "0")
			.replacingOccurrences(of: "R", with: "1")

		self.row = Int(rowString, radix: 2)!
		self.column = Int(columnString, radix: 2)!
	}
}

class Day05: DayNN {
	init() {
		super.init("Binary Boarding")
		self.part1Tests = [
			boardingPassTest("FBFBBFFRLR", row: 44, column: 5),
			boardingPassTest("BFFFBBFRRR", row: 70, column: 7),
			boardingPassTest("FFFBBBFRRR", row: 14, column: 7),
			boardingPassTest("BBFFBBFRLL", row: 102, column: 4),
		]
		self.part2Tests = []
	}

	/// A boarding pass with the given seat specifier should return the given values for
	/// row and column.
	private func boardingPassTest(_ s: String, row: Int, column: Int) -> Test {
		let seatID = 8*row + column
		return Test(name: "\(s) (\(seatID))",
					testBlock: { BoardingPass(s).displayString },
					expectedResult: "row \(row), column \(column), seat ID \(seatID)")
	}

	// MARK: - Solving

	override func solvePart1(inputLines: [String]) -> String {
		let seatIDs = inputLines.map { BoardingPass($0).seatID }
		return String(seatIDs.max()!)
	}

	override func solvePart2(inputLines: [String]) -> String {
		let sortedSeatIDs = inputLines.map { BoardingPass($0).seatID }.sorted()
		// As a sanity check I printed the list so that I could check my answer by
		// inspecting the list by eye.  Good thing I did this before submitting my answer,
		// because it was wrong.  I was returning `i` when I should have been returning
		// `sortedSeatIDs[0] + i`.
		//print(sortedSeatIDs)
		for i in 0..<sortedSeatIDs.count {
			if sortedSeatIDs[i] != sortedSeatIDs[0] + i {
				return String(sortedSeatIDs[0] + i)
			}
		}
		assert(false, "Shouldn't have gotten this far")
	}
}


