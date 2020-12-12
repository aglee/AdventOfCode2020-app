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
		var x = 0
		var y = 0
		var dir: MoveDirection = .right
		var manhattan: Int { return abs(x) + abs(y) }

		func move(_ m: Move) {
			switch m.action {
			case "N": y -= m.amount
			case "S": y += m.amount
			case "E": x += m.amount
			case "W": x -= m.amount
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
				let moveUnit = dir.delta
				x += m.amount * moveUnit.x
				y += m.amount * moveUnit.y
			default: abort()
			}
		}

		var description: String {
			return "(\(x), \(y), \(dir))"
		}
	}

	class ShipForPart2: CustomStringConvertible {
		var x = 0
		var y = 0
		var wayX = 10
		var wayY = -1
		var manhattan: Int { return abs(x) + abs(y) }

		func move(_ m: Move) {
			switch m.action {
			case "N": wayY -= m.amount
			case "S": wayY += m.amount
			case "E": wayX += m.amount
			case "W": wayX -= m.amount
			case "L":
				switch m.amount {
				case 90: (wayX, wayY) = (wayY, -wayX)
				case 180: (wayX, wayY) = (-wayX, -wayY)
				case 270: (wayX, wayY) = (-wayY, wayX)
				default: abort()
				}
			case "R":
				switch m.amount {
				case 90: (wayX, wayY) = (-wayY, wayX)
				case 180: (wayX, wayY) = (-wayX, -wayY)
				case 270: (wayX, wayY) = (wayY, -wayX)
				default: abort()
				}
			case "F":
				x += m.amount * wayX
				y += m.amount * wayY
			default: abort()
			}
		}

		var description: String {
			return "(\(x), \(y), \(wayX), \(wayY))"
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

		return String(ship.manhattan)
	}

	override func solvePart2(inputLines: [String]) -> String {
		let ship = ShipForPart2()
		let moves = movesFromLines(inputLines)

		for m in moves {
			ship.move(m)
		}

		return String(ship.manhattan)
	}
}


