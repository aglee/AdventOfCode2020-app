import Foundation

extension CharGrid {
	/// Returns true if at least one sea monster was found.  It's assumed there is only
	/// one orientation where this will return true.
	private func markSeaMonsters() -> Bool {
		func monsterOffsets(_ s: String) -> [Int] {
			let chars = s.map { String($0) }
			return (0..<chars.count).filter { chars[$0] == "#" }
		}

		func gridHasMonsterAt(_ x: Int, _ y: Int) -> Bool {
			for dy in 0..<offsets.count {
				for dx in offsets[dy] {
					if self[x + dx, y + dy] != "#" {
						return false
					}
				}
			}
			return true
		}

		/// I'm assuming monsters don't overlap.  We'll see.
		func markMonsterAt(_ x: Int, _ y: Int) {
			for dy in 0..<offsets.count {
				for dx in offsets[dy] {
					self[x + dx, y + dy] = "O"
				}
			}
		}

		let patternChars = ["                  # ",
							"#    ##    ##    ###",
							" #  #  #  #  #  #   "]
		let offsets = patternChars.map { monsterOffsets($0) }
		var foundMonster = false
		for y in 0...(height - patternChars.count) {
			for x in 0...(width - patternChars[0].count) {
				if gridHasMonsterAt(x, y) {
					markMonsterAt(x, y)
					foundMonster = true
				}
			}
		}

		return foundMonster
	}

	/// Flip and rotate the grid until at least one sea monster is found.  Mark all
	/// sea monsters in the resulting grid with "O".
	func flipAndRotateUntilSeaMonstersAreMarked() {
		// Try all 4 rotations of the grid and see if we can satisfy the condition.
		if markSeaMonsters() { return }
		for _ in 0..<3 {
			rotateCounterclockwise()
			if markSeaMonsters() { return }
		}

		// Flip the grid and again try all 4 rotations.
		flipLeftToRight()
		if markSeaMonsters() { return }
		for _ in 0..<3 {
			rotateCounterclockwise()
			if markSeaMonsters() {
				return
			}
		}

		// The input data is supposed to be such that we never get here.  If we do,
		// it's a bug.
		abort()
	}
}
