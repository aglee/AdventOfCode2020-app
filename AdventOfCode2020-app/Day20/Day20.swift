import Foundation

class Day20: DayNN {
	init() {
		super.init("Jurassic Jigsaw")
		self.part1Tests = [
			testPart1(fileNumber: 1, expectedResult: "20899048083289"),
		]
		self.part2Tests = [
			testPart2(fileNumber: 1, expectedResult: "273"),
		]
	}

	// MARK: - Solving

	override func solvePart1(inputLines: [String]) -> String {
		let tileSet = TileSet(inputLines)
		let tileNumbersOfCornerTiles = tileSet.cornerTiles.map { $0.number }
		return String(tileNumbersOfCornerTiles.reduce(1, *))
	}

	override func solvePart2(inputLines: [String]) -> String {
		let tileSet = TileSet(inputLines)
		var imageCharGrid = tileSet.assembledImage()
		imageCharGrid.flipAndRotateUntilSeaMonstersAreMarked()

		var numHashes = 0
		for y in 0..<imageCharGrid.height {
			for x in 0..<imageCharGrid.width {
				if imageCharGrid[x, y] == "#" {
					numHashes += 1
				}
			}
		}
		return String(numHashes)
	}
}


