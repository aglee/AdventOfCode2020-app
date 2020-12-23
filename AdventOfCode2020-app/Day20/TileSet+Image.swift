import Foundation

extension TileSet {
	private func tileWhoseLeftEdgeMatchesTheRightEdgeOfTile(_ tile: Tile) -> Tile? {
		let edgeNumberToMatch = tile.rightEdgeNumber
		let bucket = tilesByPossibleEdgeNumber[edgeNumberToMatch]!
		assert(bucket.contains { $0 === tile })
		if bucket.count == 1 {
			// There is no other tile that has `edgeNumberToMatch` as a possible edge number.
			return nil
		} else if bucket.count == 2 {
			// There is exactly one other tile that has `edgeNumberToMatch` as a possible edge number.
			let matchingTile = (bucket[0] === tile ? bucket[1] : bucket[0])
			matchingTile.flipAndRotateUntil {
				matchingTile.leftEdgeNumber == edgeNumberToMatch
			}
			return matchingTile
		}
		// The puzzle input has been constructed so that we should never get here.
		abort()
	}

	private func tileWhoseTopEdgeMatchesTheBottomEdgeOfTile(_ tile: Tile) -> Tile? {
		let edgeNumberToMatch = tile.bottomEdgeNumber
		let bucket = tilesByPossibleEdgeNumber[edgeNumberToMatch]!
//TODO:FIX				assert(bucket.contains(tile))
		if bucket.count == 1 {
			// There is no other tile that has `edgeNumberToMatch` as a possible edge number.
			return nil
		} else if bucket.count == 2 {
			// There is exactly one other tile that has `edgeNumberToMatch` as a possible edge number.
			let matchingTile = (bucket[0] === tile ? bucket[1] : bucket[0])
			matchingTile.flipAndRotateUntil {
				matchingTile.topEdgeNumber == edgeNumberToMatch
			}
			return matchingTile
		}
		// The puzzle input has been constructed so that every bucket should contain
		// 1 or 2 tiles.  If not, there is a bug in this code.
		abort()
	}

	private func assembledGridOfTiles() -> [[Tile]] {
		// Pick a corner tile and orient it to be the top left corner.
		let topLeftTile = cornerTiles[0]
		topLeftTile.flipAndRotateUntil {
			singletonEdgeNumbers.contains(topLeftTile.topEdgeNumber)
			&& singletonEdgeNumbers.contains(topLeftTile.leftEdgeNumber)
		}

		// Construct a grid of tiles, starting with the chosen top-left corner tile.
		var gridOfTiles = [[topLeftTile]]
		while true {
			// The current last row of the image grid should have 1 element.
			// Add tiles to the row until we can't any more.
			assert(gridOfTiles[gridOfTiles.count - 1].count == 1)
			while true {
				let currentTile = gridOfTiles[gridOfTiles.count - 1].last!
				if let nextTile = tileWhoseLeftEdgeMatchesTheRightEdgeOfTile(currentTile) {
					gridOfTiles[gridOfTiles.count - 1].append(nextTile)
				} else {
					// We couldn't find a neighbor tile, so we must have reached the end of the row.
					break
				}
			}

			// Prepare to fill in the next row of the image grid by filling in its first tile.  If we can't, then the image grid is complete.
			let tile = gridOfTiles[gridOfTiles.count - 1][0]
			let bottomEdge = tile.bottomEdgeNumber
			let bucket = tilesByPossibleEdgeNumber[bottomEdge]!
			assert(bucket.contains { $0 === tile })
			if bucket.count == 1 {
				// There is no tile we can match to this tile, which means we've reached
				// the bottom edge of the image.
				break
			}
			if let nextTile = tileWhoseTopEdgeMatchesTheBottomEdgeOfTile(tile) {
				gridOfTiles.append([nextTile])
			} else {
				// The image grid is complete.
				break
			}
		}

		return gridOfTiles
	}

	/// Assembles the tiles into a grid according to the rules.  Removes the tile edges
	/// and combines the resulting tiles into a `CharGrid`.
	func assembledImage() -> CharGrid {
		let gridOfTiles = assembledGridOfTiles()
		var imageGrid = CharGrid()
		for rowOfTiles in gridOfTiles {
			let rowOfCharGridsWithEdgesRemoved: [CharGrid] = rowOfTiles.map {
				var grid = $0.grid
				grid.removeFirstRow()
				grid.removeLastRow()
				grid.removeFirstColumn()
				grid.removeLastColumn()
				return grid
			}
			let joinedRowOfCharGrids = rowOfCharGridsWithEdgesRemoved.reduce(into: CharGrid(), { $0.appendColumns(from: $1) })
			imageGrid.appendRows(from: joinedRowOfCharGrids)
		}

		return imageGrid
	}
}
