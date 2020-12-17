struct Point3D: Hashable {
	let x: Int, y: Int, z: Int

	init(_ x: Int, _ y: Int, _ z: Int) {
		(self.x, self.y, self.z) = (x, y, z)
	}
}

/// Set of points in 3-space.  The min and max properties give the bounding box containing
/// all points in the set.
struct PointSet3D {
	private(set) var (minX, maxX) = (0, 0)
	private(set) var (minY, maxY) = (0, 0)
	private(set) var (minZ, maxZ) = (0, 0)
	private(set) var allPoints = Set<Point3D>()

	init(_ inputLines: [String]) {
		for y in 0..<inputLines.count {
			let chars = inputLines[y].map { String($0) }
			for x in 0..<chars.count {
				if chars[x] == "#" {
					add(x, y, 0)
				}
			}
		}
	}

	init() {
		self.init([])
	}

	mutating func add(_ x: Int, _ y: Int, _ z: Int) {
		if x < minX { minX = x }
		if x > maxX { maxX = x }
		if y < minY { minY = y }
		if y > maxY { maxY = y }
		if z < minZ { minZ = z }
		if z > maxZ { maxZ = z }
		allPoints.insert(Point3D(x, y, z))
	}

	/// Applies the Conway-ish rules and returns the resulting set of active points.
	func cycle() -> PointSet3D {
		var newActiveSet = PointSet3D()

		// Examine all points in a box **one larger in every direction** than the bounding
		// box of all our active points.  Any point outside that box has no active
		// neighbors, so will remain inactive.
		for x in (minX - 1)...(maxX + 1) {
			for y in (minY - 1)...(maxY + 1) {
				for z in (minZ - 1)...(maxZ + 1) {
					let point = Point3D(x, y, z)
					let numActiveNeighbors = (neighbors(of: point)
												.filter { allPoints.contains($0) }
												.count)
					if allPoints.contains(point) {
						// Active points *remain* active if they have the right number of
						// active neighbors.
						if numActiveNeighbors == 2 || numActiveNeighbors == 3 {
							newActiveSet.add(x, y, z)
						}
					} else {
						// Inactive points *become* active if they have the right number
						// of active neighbors.
						if numActiveNeighbors == 3 {
							newActiveSet.add(x, y, z)
						}
					}
				}
			}
		}

		return newActiveSet
	}

	func neighbors(of point: Point3D) -> [Point3D] {
		var result = [Point3D]()
		for dx in [-1, 0, 1] {
			for dy in [-1, 0, 1] {
				for dz in [-1, 0, 1] {
					if (dx, dy, dz) != (0, 0, 0) {
						result.append(Point3D(point.x + dx, point.y + dy, point.z + dz))
					}
				}
			}
		}
		return result
	}

	func dump() {
		for z in minZ...maxZ {
			print("z=\(z)")
			for y in minY...maxY {
				var line = ""
				for x in minX...maxX {
					let point = Point3D(x, y, z)
					line += (allPoints.contains(point) ? "#" : ".")
				}
				print(line)
			}
			print()
		}
	}
}

