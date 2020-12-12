import Foundation

let FLOOR = "."
let OCCUPIED_SEAT = "#"
let EMPTY_SEAT = "L"

class SeatGrid: CharGrid {
	var nearbyOccupiedThreshold: Int { return 4 }

	private var cachedPointsOfInterest: [GridPoint: [GridPoint]] = [:]

	required override init(inputLines: [String]) {
		super.init(inputLines: inputLines)

		for x in 0..<width {
			for y in 0..<height {
				cachedPointsOfInterest[GridPoint(x, y)] = pointsOfInterest(x, y)
			}
		}
	}

	/// Called by `onePass(outputGrid:)`.  Returns the value that should go into
	/// `outputGrid` based on the corresponding value in the receiver.
	func newValueForPoint(_ x: Int, _ y: Int) -> String {
		let currentValue = self[x, y]

		if currentValue == FLOOR {
			return FLOOR
		}

		let numAdjacentOccupied = numOccupiedSeats(amongPoints: cachedPointsOfInterest[GridPoint(x, y)]!)

		switch currentValue {
		case EMPTY_SEAT:
			return (numAdjacentOccupied == 0 ? OCCUPIED_SEAT : EMPTY_SEAT)
		case OCCUPIED_SEAT:
			return (numAdjacentOccupied >= nearbyOccupiedThreshold ? EMPTY_SEAT : OCCUPIED_SEAT)
		default:
			abort()
		}
	}

	/// Returns points that should be examined by `newValueForPoint(_, _)`.
	func pointsOfInterest(_ x: Int, _ y: Int) -> [GridPoint] {
		neighboringPoints(of: GridPoint(x, y))
	}

	/// Sets the value of every point in `outputGrid`, based on the corresponding value in
	/// `self`.  Returns the number of points at which `newValueForPoint(_, _)` returned a
	/// different value.
	func onePass(outputGrid: SeatGrid) -> Int {
		var numSeatsChanged = 0
		for x in 0..<width {
			for y in 0..<height {
				let oldValue = self[x, y]
				let newValue = newValueForPoint(x, y)

				if newValue != oldValue {
					numSeatsChanged += 1
				}

				outputGrid[x, y] = newValue
			}
		}
		return numSeatsChanged
	}

	func numOccupiedSeats(amongPoints points: [GridPoint]) -> Int {
		let valuesAtTheGivenPoints = points.map { self[$0] }
		return valuesAtTheGivenPoints.reduce(0, { $0 + ($1 == OCCUPIED_SEAT ? 1 : 0) })
	}

	func numOccupiedSeats() -> Int {
		var result = 0
		for x in 0..<width {
			for y in 0..<height {
				if self[x, y] == OCCUPIED_SEAT {
					result += 1
				}
			}
		}
		return result
	}

	static func solve(_ inputLines: [String]) -> String {
		var grid1 = Self(inputLines: inputLines)
		var grid2 = Self(inputLines: inputLines)

		while true {
			let numSeatsChanged = grid1.onePass(outputGrid: grid2)
			if numSeatsChanged == 0 {
				return String(grid2.numOccupiedSeats())
			}
			(grid1, grid2) = (grid2, grid1)
		}
	}
}

class SeatGridPart2: SeatGrid {
	override var nearbyOccupiedThreshold: Int { return 5 }

	override func pointsOfInterest(_ x: Int, _ y: Int) -> [GridPoint] {
		var result: [GridPoint] = []

		// Look for a seat in each of the eight possible directions.
		for (dx, dy) in CharGrid.deltasIncludingDiagonals {
			if let visiblePoint = visibleSeatPoint(startX: x, startY: y, dx: dx, dy: dy) {
				result.append(visiblePoint)
			}
		}

		return result
	}

	/// Search in one direction for a seat (occupied or unoccupied) visible from point
	/// `(startX, startY)`.
	func visibleSeatPoint(startX: Int, startY: Int, dx: Int, dy: Int) -> GridPoint? {
		assert(dx != 0 || dy != 0, "At least one delta must be non-zero.")
		var (x, y) = (startX, startY)
		while true {
			(x, y) = (x + dx, y + dy)

			if !isInBounds(x, y) {
				return nil
			}

			if self[x, y] != FLOOR {
				return GridPoint(x, y)
			}
		}
	}
}

class Day11: DayNN {
	init() {
		super.init("Seating System")
		self.part1Tests = [
			testPart1(fileNumber: 1, expectedResult: "37"),
		]
		self.part2Tests = [
			testPart2(fileNumber: 1, expectedResult: "26"),
		]
	}

	// MARK: - Solving

	override func solvePart1(inputLines: [String]) -> String {
		return SeatGrid.solve(inputLines)
	}

	override func solvePart2(inputLines: [String]) -> String {
		return SeatGridPart2.solve(inputLines)
	}
}


