import Foundation

class Floor {
	var blackTiles = Set<GridPoint>()

	func move(_ line: String) {
		var curr = GridPoint.zero
		var prevChar = ""
		for ch in line.map({ String($0) }) {
			switch ch {
			case "e":
				if prevChar == "n" {
					// Move northeast.
					curr.x += 0
					curr.y += 1
				} else if prevChar == "s" {
					// Move southeast.
					curr.x += 1
					curr.y += -1
				} else {
					// Move east.
					curr.x += 1
					curr.y += 0
				}
			case "w":
				if prevChar == "n" {
					// Move northwest.
					curr.x += -1
					curr.y += 1
				} else if prevChar == "s" {
					// Move southwest.
					curr.x += 0
					curr.y += -1
				} else {
					// Move west.
					curr.x += -1
					curr.y += 0
				}
			case "n", "s":
				// Don't move for now -- the next letter will be "e" or "w".
				()
			default:
				abort()
			}
			prevChar = ch
		}

		// Flip the tile we're on.
		if blackTiles.contains(curr) {
			blackTiles.remove(curr)
		} else {
			blackTiles.insert(curr)
		}
	}

	func part1(_ inputLines: [String]) -> String {
		for line in inputLines {
			move(line)
		}
		return String(blackTiles.count)
	}

	func countBlackNeighbors(_ point: GridPoint) -> Int {
		var result = 0
		for (dx, dy) in [(0, 1), (1, -1), (1, 0), (-1, 1), (0, -1),(-1, 0)] {
			if blackTiles.contains(point.plus(GridPoint(dx, dy))) {
				result += 1
			}
		}
		return result
	}

	func blackTilesPlusNeighboringPoints() -> Set<GridPoint> {
		var result = blackTiles
		for point in blackTiles {
			result.insert(point)
			for (dx, dy) in [(0, 1), (1, -1), (1, 0), (-1, 1), (0, -1),(-1, 0)] {
				result.insert(point.plus(GridPoint(dx, dy)))
			}
		}
		return result
	}

	func oneConwayPass() {
		let pointsToCheck = blackTilesPlusNeighboringPoints()
		var newBlackTiles = Set<GridPoint>()

		for point in pointsToCheck {
			let numBlackNeighbors = countBlackNeighbors(point)
			if blackTiles.contains(point) {
				// Does this black tile stay black?
				if numBlackNeighbors == 0 || numBlackNeighbors > 2 {
					// Flip to white.
				} else {
					// Remain black.
					newBlackTiles.insert(point)
				}
			} else {
				// Does this white tile stay white?
				if numBlackNeighbors == 2 {
					// Flip to black.
					newBlackTiles.insert(point)
				} else {
					// Remain white.
				}
			}
		}

		blackTiles = newBlackTiles
	}

	func part2(_ inputLines: [String]) -> String {
		for line in inputLines {
			move(line)
		}

		for _ in 0..<100 {
			oneConwayPass()
		}

		return String(blackTiles.count)
	}

}
