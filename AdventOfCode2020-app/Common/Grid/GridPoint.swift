import Foundation

/// Represents a 2D point with integer coordinates.  The y axis grows *downward* (positive
/// y is *below* the origin).
struct GridPoint: Hashable, CustomStringConvertible {
	//TODO: Use custom operators for `+` etc.

	static let zero = GridPoint(0, 0)

	var x: Int
	var y: Int
	var manhattan: Int { return abs(x) + abs(y) }

	init(_ x: Int, _ y: Int) {
		self.x = x
		self.y = y
	}

	init(_ coords:(x: Int, y: Int)) {
		self.init(coords.x, coords.y)
	}

	func manhattan(_ otherPoint: GridPoint) -> Int {
		return abs(x - otherPoint.x) + abs(y - otherPoint.y)
	}

	mutating func add(_ dx: Int, _ dy: Int) {
		(x, y) = (x + dx, y + dy)
	}

	mutating func subtract(_ dx: Int, _ dy: Int) {
		(x, y) = (x - dx, y - dy)
	}

	mutating func moveByOne(_ dir: MoveDirection) {
		let delta = dir.delta
		add(delta.x, delta.y)
	}

	mutating func moveUp(_ amount: Int) {
		y -= amount
	}

	mutating func moveDown(_ amount: Int) {
		y += amount
	}

	mutating func moveLeft(_ amount: Int) {
		x -= amount
	}

	mutating func moveRight(_ amount: Int) {
		x += amount
	}

	/// Rotates the point 90 degrees counterclockwise around the origin.
	mutating func rotate90Left() {
		(x, y) = (y, -x)
	}

	/// Rotates the point 90 degrees clockwise around the origin.
	mutating func rotate90Right() {
		(x, y) = (-y, x)
	}

	/// Rotates the point 180 degrees around the origin.
	mutating func rotate180() {
		(x, y) = (-x, -y)
	}

	func minus(_ otherPoint: GridPoint) -> GridPoint {
		return GridPoint(x - otherPoint.x, y - otherPoint.y)
	}

	func plus(_ otherPoint: GridPoint) -> GridPoint {
		return GridPoint(x + otherPoint.x, y + otherPoint.y)
	}

	func times(_ multiplier: Int) -> GridPoint {
		return GridPoint(multiplier * x, multiplier * y)
	}

	func movedByOne(_ dir: MoveDirection) -> GridPoint {
		return self.plus(dir.delta)
	}

	/// Rotates the point 90 degrees counterclockwise around the origin.
	func rotated90Left() -> GridPoint {
		return GridPoint(y, -x)
	}

	/// Rotates the point 90 degrees clockwise around the origin.
	func rotated90Right() -> GridPoint {
		return GridPoint(-y, x)
	}

	/// Rotates the point 180 degrees around the origin.
	func rotated180() -> GridPoint {
		return GridPoint(-x, -y)
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


