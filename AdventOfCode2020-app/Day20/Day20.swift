import Foundation

class Day20: DayNN {
	init() {
		super.init("Jurassic Jigsaw")
		self.part1Tests = [
			testPart1(fileNumber: 1, expectedResult: "20899048083289"),
		]
		self.part2Tests = [
			testPart2(fileNumber: 1, expectedResult: "xxx"),
		]
	}

	// MARK: - Solving

	struct CountedSet {
		private(set) var counts = [Int: Int]()

		mutating func add(_ n: Int) {
			if let count = counts[n] {
				counts[n] = count + 1
			} else {
				counts[n] = 1
			}
		}

		func dump() {
			for (n, count) in counts.sorted(by: { $0.key < $1.key }) {
				print("\(n): \(count)")
			}
		}
	}

	struct BucketSet {
		private(set) var buckets = [Int: [Int]]()

		mutating func add(bucketID: Int, value: Int) {
			if let _ = buckets[bucketID] {
				buckets[bucketID]!.append(value)
			} else {
				buckets[bucketID] = [value]
			}
		}

		func dump() {
			for (bucketID, bucket) in buckets.sorted(by: { $0.key < $1.key }) {
				print("\(bucketID): \(bucket)")
			}
		}
	}

	class Tile: CustomStringConvertible {

		var description: String { return String(number) }


		let number: Int
		private let grid: CharGrid
		var possibleEdgeNumbers: [Int] {
			return [
				grid.rows.first!,
				grid.rows.last!,
				grid.rows.map { $0.first! },
				grid.rows.map { $0.last! },

				grid.rows.first!.reversed(),
				grid.rows.last!.reversed(),
				grid.rows.map { $0.first! }.reversed(),
				grid.rows.map { $0.last! }.reversed(),
			].map { edgeToInt($0) }
		}
		var topEdgeNumber: Int { edgeToInt(grid.rows.first!) }
		var bottomEdgeNumber: Int { edgeToInt(grid.rows.last!) }
		var leftEdgeNumber: Int { edgeToInt(grid.rows.map { $0.first! }) }
		var rightEdgeNumber: Int { edgeToInt(grid.rows.map { $0.last! }) }

		init(_ lines: [String]) {
			var lines = lines

			// "Tile 2311:"
			var firstLine = lines.removeFirst()
			firstLine.removeFirst(5)
			firstLine.removeLast()
			self.number = Int(firstLine)!
			self.grid = CharGrid(inputLines: lines)

			assert(Set(possibleEdgeNumbers).count == 8,
				   "This only works if edges and their flips are unique.")
		}

		func transformUntil(_ condition: () -> Bool) {
			// Rotate the grid and see if we can satisfy the condition.
			for _ in 0..<4 {
				grid.rotateCounterclockwise()
				if condition() {
					return
				}
			}

			// Rotating the original grid didn't work.  Flip the grid and try again.
			grid.flipLeftToRight()
			for _ in 0..<4 {
				grid.rotateCounterclockwise()
				if condition() {
					return
				}
			}

			// The input data is supposed to be such that we never get here.  If we do,
			// it's a bug.
			abort()
		}

		private func edgeToInt(_ chars: [String]) -> Int {
			var result = 0
			for ch in chars {
				result <<= 1
				if ch == "#" {
					result += 1
				}
			}
			return result
		}
	}

	func findCornerTiles(_ tiles: [Tile]) -> [Int] {
		var edgeNumBuckets = BucketSet()
		for tile in tiles {
			for edgeNum in tile.possibleEdgeNumbers {
				edgeNumBuckets.add(bucketID: edgeNum, value: tile.number)
			}
		}

		let ones = edgeNumBuckets.buckets.filter { $1.count == 1 }
		let singletonEdgeNumbers = Set(ones.keys)

		var cornerTileNumbers = [Int]()
		for tile in tiles {
			if tile.possibleEdgeNumbers.filter({ singletonEdgeNumbers.contains($0) }).count == 4 {
				cornerTileNumbers.append(tile.number)
			}
		}
		return cornerTileNumbers
	}

	override func solvePart1(inputLines: [String]) -> String {
		let groups = groupedLines(inputLines)
		let tiles = groups.map { Tile($0) }
		let cornerTileNumbers = findCornerTiles(tiles)
		let product = cornerTileNumbers.reduce(1, *)
		return String(product)
	}

	override func solvePart2(inputLines: [String]) -> String {

		let groups = groupedLines(inputLines)
		let tiles = groups.map { Tile($0) }

		// Keys are edge numbers, each value is a list of tile numbers that can have the
		// key as one of its possible edge numbers.
		var edgeNumBuckets = BucketSet()
		for tile in tiles {
			for edgeNum in tile.possibleEdgeNumbers {
				edgeNumBuckets.add(bucketID: edgeNum, value: tile.number)
			}
		}

		let ones = edgeNumBuckets.buckets.filter { $1.count == 1 }
		let singletonEdgeNumbers = Set(ones.keys)

		var gridOfTiles = [[Tile]]()  // 2-dimensional array of tile numbers.
		for tile in tiles {
			if tile.possibleEdgeNumbers.filter({ singletonEdgeNumbers.contains($0) }).count == 4 {
				gridOfTiles.append([tile])
				break
			}
		}
		assert(gridOfTiles.count == 1 && gridOfTiles[0].count == 1,
			   "Something's wrong -- we should have found a corner tile.")


		var tilesByTileNumber = [Int: Tile]()
		for tile in tiles { tilesByTileNumber[tile.number] = tile }

		let topLeftTile = gridOfTiles[0][0]
		topLeftTile.transformUntil {
			singletonEdgeNumbers.contains(topLeftTile.topEdgeNumber)
			&& singletonEdgeNumbers.contains(topLeftTile.leftEdgeNumber)
		}

		while true {
			// Fill in the current last row of the image grid -- it should have 1 element.
			// We will add tiles to the row until we can't any more.
			assert(gridOfTiles[gridOfTiles.count - 1].count == 1)
			while true {
				let currentTile = gridOfTiles[gridOfTiles.count - 1].last!
				let currentTileNumber = currentTile.number
				let rightEdge = currentTile.rightEdgeNumber
				let bucket = edgeNumBuckets.buckets[rightEdge]!
				assert(bucket.contains(currentTileNumber))
				if bucket.count == 1 {
					// There is no tile we can match to this tile, which means we've reached
					// the right edge of the image.
					break
				}
				assert(bucket.count == 2)
				let nextTileNumber = (bucket[0] == currentTileNumber ? bucket[1] : bucket[0])
				let nextTile = tilesByTileNumber[nextTileNumber]!
				nextTile.transformUntil { nextTile.leftEdgeNumber == rightEdge }
				gridOfTiles[gridOfTiles.count - 1].append(nextTile)
			}

			// Fill in the first tile of the next row of the image grid.  If we can't,
			// then we're done.
			let tile = gridOfTiles[gridOfTiles.count - 1][0]
			let tileNumber = tile.number
			let bottomEdge = tile.bottomEdgeNumber
			let bucket = edgeNumBuckets.buckets[bottomEdge]!
			assert(bucket.contains(tileNumber))
			if bucket.count == 1 {
				// There is no tile we can match to this tile, which means we've reached
				// the bottom edge of the image.
				break
			}
			let nextTileNumber = (bucket[0] == tileNumber ? bucket[1] : bucket[0])
			let nextTile = tilesByTileNumber[nextTileNumber]!
			nextTile.transformUntil { nextTile.topEdgeNumber == bottomEdge }
			gridOfTiles.append([nextTile])
		}
		print()
		print(gridOfTiles)


		return "xxx"
	}
}


