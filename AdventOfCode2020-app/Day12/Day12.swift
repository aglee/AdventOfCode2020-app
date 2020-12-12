import Foundation

class Day12: DayNN {
	init() {
		super.init("Rain Risk")
		self.part1Tests = [
			testPart1(fileNumber: 1, expectedResult: "25"),
		]
		self.part2Tests = [
			testPart2(fileNumber: 1, expectedResult: "286"),
		]
	}

	// MARK: - Solving

	typealias Move = (action: String, amount: Int)

	class ShipForPart1: CustomStringConvertible {
		var loc = GridPoint.zero
		var dir: MoveDirection = .right

		func move(_ m: Move) {
			switch m.action {
			case "N": loc.moveUp(m.amount)
			case "S": loc.moveDown(m.amount)
			case "E": loc.moveRight(m.amount)
			case "W": loc.moveLeft(m.amount)
			case "L":
				switch m.amount {
				case 90: dir = dir.turned(.turnLeft)
				case 180: dir = dir.reversed()
				case 270: dir = dir.turned(.turnRight)
				default: abort()
				}
			case "R":
				switch m.amount {
				case 90: dir = dir.turned(.turnRight)
				case 180: dir = dir.reversed()
				case 270: dir = dir.turned(.turnLeft)
				default: abort()
				}
			case "F":
				loc = loc.plus(dir.delta.times(m.amount))
			default: abort()
			}
		}

		var description: String {
			return "(\(loc), \(dir))"
		}
	}

	class ShipForPart2: CustomStringConvertible {
		var loc = GridPoint.zero
		var waypoint = GridPoint(10, -1)

		func move(_ m: Move) {
			switch m.action {
			case "N": waypoint.moveUp(m.amount)
			case "S": waypoint.moveDown(m.amount)
			case "E": waypoint.moveRight(m.amount)
			case "W": waypoint.moveLeft(m.amount)
			case "L":
				switch m.amount {
				case 90: waypoint.rotate90Left()
				case 180: waypoint.rotate180()
				case 270: waypoint.rotate90Right()
				default: abort()
				}
			case "R":
				switch m.amount {
				case 90: waypoint.rotate90Right()
				case 180: waypoint.rotate180()
				case 270: waypoint.rotate90Left()
				default: abort()
				}
			case "F":
				loc = loc.plus(waypoint.times(m.amount))
			default: abort()
			}
		}

		var description: String {
			return "(\(loc), \(waypoint))"
		}
	}

	func movesFromLines(_ inputLines: [String]) -> [Move] {
		func parseLine(_ s: String) -> Move {
			return (String(s.prefix(1)), Int(s.suffix(from: s.index(after: s.startIndex)))! )
		}

		return inputLines.map { parseLine($0) }
	}

	override func solvePart1(inputLines: [String]) -> String {
		let ship = ShipForPart1()
		let moves = movesFromLines(inputLines)

		for m in moves {
			ship.move(m)
		}

		return String(ship.loc.manhattan)
	}

	override func solvePart2(inputLines: [String]) -> String {
		let ship = ShipForPart2()
		let moves = movesFromLines(inputLines)

		for m in moves {
			ship.move(m)
		}

		return String(ship.loc.manhattan)
	}
}


