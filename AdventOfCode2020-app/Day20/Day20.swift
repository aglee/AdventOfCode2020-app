import Foundation

class Day20: DayNN {
	init() {
		super.init("PUT_DESCRIPTION_HERE")
		self.part1Tests = [
			testPart1(fileNumber: 1, expectedResult: "xxx"),
		]
		self.part2Tests = [
			testPart2(fileNumber: 1, expectedResult: "xxx"),
		]
	}

	// MARK: - Solving

	struct CountedSet {
		var counts = [Int: Int]()

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

	struct Tile {
		let number: Int
		let grid: CharGrid
		let edgeNumbers: Set<Int>

		init(_ lines: [String]) {
			func edgeToInt(_ chars: [String]) -> Int {
				var result = 0
				for ch in chars {
					result <<= 1
					if ch == "#" {
						result += 1
					}
				}
				return result
			}

			var lines = lines

			// "Tile 2311:"
			var firstLine = lines.removeFirst()
			firstLine.removeFirst(5)
			firstLine.removeLast()
			self.number = Int(firstLine)!
			self.grid = CharGrid(inputLines: lines)
			self.edgeNumbers = Set([
				grid.rows.first!,
				grid.rows.last!,
				grid.rows.map { $0.first! },
				grid.rows.map { $0.last! },

				grid.rows.first!.reversed(),
				grid.rows.last!.reversed(),
				grid.rows.map { $0.first! }.reversed(),
				grid.rows.map { $0.last! }.reversed(),
			].map { edgeToInt($0) })
			if edgeNumbers.count != 8 {
				print(0)
			}
		}
	}

	override func solvePart1(inputLines: [String]) -> String {
		let groups = groupedLines(inputLines)
		let tiles = groups.map { Tile($0) }

		var edgeNumCounts = CountedSet()
		for tile in tiles {
			for edgeNum in tile.edgeNumbers {
				edgeNumCounts.add(edgeNum)
			}
		}

		print()
		let ones = edgeNumCounts.counts.filter { $1 == 1 }
		let uniqueEdgeNumbers = Set(ones.keys)
		print(uniqueEdgeNumbers)

		var result = 1
		for tile in tiles {
			if tile.edgeNumbers.filter { uniqueEdgeNumbers.contains($0) }.count == 4 {
				print("CORNER:", tile.number)
				result *= tile.number
			}
		}
		print(result)
//		edgeNumCounts.dump()

		return "xxx"
	}

	override func solvePart2(inputLines: [String]) -> String {
		return "xxx"
	}
}


