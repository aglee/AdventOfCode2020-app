import Foundation

/// Represents a coordinate on an infinite 2-dimensional grid.
///
/// The stuff here assumes the y axis grows *downward*.
struct GridPoint: Hashable, CustomStringConvertible {
	static let zero = GridPoint(0, 0)

	let x: Int
	let y: Int

	func manhattan() -> Int {
		return abs(x) + abs(y)
	}

	func manhattan(_ otherPoint: GridPoint) -> Int {
		return abs(x - otherPoint.x) + abs(y - otherPoint.y)
	}

	func minus(_ otherPoint: GridPoint) -> GridPoint {
		return GridPoint(x - otherPoint.x, y - otherPoint.y)
	}

	func plus(_ otherPoint: GridPoint) -> GridPoint {
		return GridPoint(x + otherPoint.x, y + otherPoint.y)
	}

	var description: String {
		return "(\(x), \(y))"
	}
}

func manhattan(_ p1: GridPoint, _ p2: GridPoint) -> Int {
	return p1.manhattan(p2)
}

enum TurnDirection: Int {
	case turnLeft
	case turnRight
}

enum MoveDirection: Int {
	case up
	case down
	case left
	case right

	var delta: GridPoint {
		switch self {
		case .up: return GridPoint(0, -1)
		case .down: return GridPoint(0, 1)
		case .left: return GridPoint(-1, 0)
		case .right: return GridPoint(1, 0)
		}
	}

	func reversed() -> MoveDirection {
		switch self {
		case .up: return .down
		case .down: return .up
		case .left: return .right
		case .right: return .left
		}
	}

	func turned(_ turn: TurnDirection) -> MoveDirection {
		switch self {
		case .up:
			switch turn {
			case .turnLeft: return .left
			case .turnRight: return .right
			}
		case .down:
			switch turn {
			case .turnLeft: return .right
			case .turnRight: return .left
			}
		case .left:
			switch turn {
			case .turnLeft: return .down
			case .turnRight: return .up
			}
		case .right:
			switch turn {
			case .turnLeft: return .up
			case .turnRight: return .down
			}
		}
	}
}

extension GridPoint {
	init(_ x: Int, _ y: Int) {
		self.init(x: x, y: y)
	}

	init(_ coords:(x: Int, y: Int)) {
		self.init(coords.x, coords.y)
	}

	func moved(_ dir: MoveDirection) -> GridPoint {
		return self.plus(dir.delta)
	}
}

