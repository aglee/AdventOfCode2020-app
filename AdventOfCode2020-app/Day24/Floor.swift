import Foundation

/// Maps a grid of hexagons onto the same coordinate system for a grid of squares.
///
///```text
///      +     +
///     / \   / \
///    /   \ /   \
///---+-----+-----+---
///   | nw  |  ne | ...
///   |-1,1 | 0,1 |
///---+-----+-----+---
///  / \   / \   / \
/// /   \ /   \ /   \
///+-----+-----+-----+
///|west |start| east| ...
///|-1,0 | 0,0 | 1,0 |
///+-----+-----+-----+
/// \   / \   / \   /
///  \ /   \ /   \ /
///---+-----+-----+---
///   | sw  |  se | ...
///   | 0,-1| 1,-1|
///---+-----+-----+---
///    \   / \   /
///     \ /   \ /
///      +     +
class Floor {
	private var blackTiles = Set<GridPoint>()

	let northeast = GridPoint(0, 1)
	let southeast = GridPoint(1, -1)
	let east = GridPoint(1, 0)
	let northwest = GridPoint(-1, 1)
	let southwest = GridPoint(0, -1)
	let west = GridPoint(-1, 0)
	var allDirections: [GridPoint] {
		[northeast, southeast, east,
		 northwest, southwest, west]
	}
	var numBlackTiles: Int { blackTiles.count }

	/// Follows the given directions to arrive at a tile location.
	func locateTile(directions: String) -> GridPoint {
		// Start at (0, 0).
		var currentPoint = GridPoint.zero

		// Iterate through the characters in the string.  Move whenever we encounter
		// either "e" or "w".  The direction we move depends on whether the previous
		// character was "n", "s", or neither.
		var prevChar = ""
		for ch in directions.map({ String($0) }) {
			switch ch {
			case "e":
				switch prevChar {
				case "n": currentPoint = currentPoint.plus(northeast)
				case "s": currentPoint = currentPoint.plus(southeast)
				default: currentPoint = currentPoint.plus(east)
				}
			case "w":
				switch prevChar {
				case "n": currentPoint = currentPoint.plus(northwest)
				case "s": currentPoint = currentPoint.plus(southwest)
				default: currentPoint = currentPoint.plus(west)
				}
			case "n", "s":
				// Do nothing except remember this letter.  We expect the next letter will
				// be either "e" (so we will move northeast or southeast) or "w" (so we
				// will move northwest or southwest).
				()
			default:
				abort()
			}
			prevChar = ch
		}

		return currentPoint
	}

	/// Same as `locateTile(directions:)` but for grins implemented using a regular
	/// expression.
	func locateTileUsingRegex(directions: String) -> GridPoint {
		// Start at (0, 0).
		var currentPoint = GridPoint.zero

		// Iterate through the characters in the string.  Move whenever we encounter
		// either "e" or "w".  The direction we move depends on whether the previous
		// character was "n", "s", or neither.
		var prevChar = ""
		for ch in directions.map({ String($0) }) {
			switch ch {
			case "e":
				switch prevChar {
				case "n": currentPoint = currentPoint.plus(northeast)
				case "s": currentPoint = currentPoint.plus(southeast)
				default: currentPoint = currentPoint.plus(east)
				}
			case "w":
				switch prevChar {
				case "n": currentPoint = currentPoint.plus(northwest)
				case "s": currentPoint = currentPoint.plus(southwest)
				default: currentPoint = currentPoint.plus(west)
				}
			case "n", "s":
				// Do nothing except remember this letter.  We expect the next letter will
				// be either "e" (so we will move northeast or southeast) or "w" (so we
				// will move northwest or southwest).
				()
			default:
				abort()
			}
			prevChar = ch
		}

		return currentPoint
	}

	/// Change the tile at the given location to white if it's black, and vice versa.
	func flipTileColor(_ point: GridPoint) {
		if blackTiles.contains(point) {
			blackTiles.remove(point)
		} else {
			blackTiles.insert(point)
		}
	}

	/// Flips tile colors according the rules in the puzzle description.  Similar to one
	/// pass of a Game of Life.
	func oneConwayPass() {
		var newBlackTiles = Set<GridPoint>()

		for point in blackTilesPlusNeighboringPoints() {
			let numBlackNeighbors = countNeighboringBlackTiles(point)
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

	// MARK: - Private

	private func countNeighboringBlackTiles(_ point: GridPoint) -> Int {
		var result = 0
		for delta in allDirections {
			if blackTiles.contains(point.plus(delta)) {
				result += 1
			}
		}
		return result
	}

	/// Returns the locations of the black tiles plus all their neighboring white tiles.
	private func blackTilesPlusNeighboringPoints() -> Set<GridPoint> {
		var result = blackTiles
		for point in blackTiles {
			for delta in allDirections {
				result.insert(point.plus(delta))
			}
		}
		return result
	}
}
