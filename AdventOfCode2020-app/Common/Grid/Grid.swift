import Foundation

/// Collection of elements arranged at integer coordinates on a plane.  The `y` coordinate
/// increases *downward* -- you can think of it as a row number.
///
/// This is for the cases where we don't know the bounds of the grid beforehand, and/or we
/// may need to use points with negative coordinates, and/or we may need to deal with
/// coordinates so large an array would use too much memory.
struct Grid {
	private var tiles = [GridPoint: GridElement]()
	private(set) var minX = 0
	private(set) var minY = 0
	private(set) var maxX = 10
	private(set) var maxY = 5

	init(lines: [String]) {
		for y in 0..<lines.count {
			let line = NSString(string: lines[y])
			for x in 0..<line.length {
				let ch = line.substring(with: NSRange(location: x, length: 1))
				self[x, y] = GridElement(rawValue: ch)!
			}
		}
	}

	init() {
		self.init(lines: [])
	}

	func printGrid() {
		for line in gridAsLinesOfText() {
			print(line)
		}
	}

	func gridAsLinesOfText() -> [String] {
		var lines = [String]()
		for y in minY...maxY {
			var rowString = ""
			for x in minX...maxX {
				rowString += self[x, y].symbolForPrinting
			}
			lines.append(rowString)
		}
		return lines
	}

	/// Absence of a value at `tiles[point]` means that square is empty.
	subscript(point: GridPoint) -> GridElement {
		get { return tiles[point] ?? .emptySignifier }
		set {
			tiles[point] = (newValue == .emptySignifier ? nil : newValue)

			if newValue != .emptySignifier {
				minX = min(minX, point.x)
				minY = min(minY, point.y)
				maxX = max(maxX, point.x)
				maxY = max(maxY, point.y)
			}
		}
	}

	subscript(x: Int, y: Int) -> GridElement {
		get { return self[GridPoint(x, y)] }
		set { self[GridPoint(x, y)] = newValue }
	}
}

