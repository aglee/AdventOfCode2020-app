/// Same as `Point3D`, but in 4 dimensions.
struct Point4D: Hashable {
	let x: Int, y: Int, z: Int, w: Int

	init(_ x: Int, _ y: Int, _ z: Int, _ w: Int) {
		(self.x, self.y, self.z, self.w) = (x, y, z, w)
	}
}

/// Same as `ActiveSet3D`, but in 4 dimensions.
struct PointSet4D {
	private(set) var (minX, maxX) = (0, 0)
	private(set) var (minY, maxY) = (0, 0)
	private(set) var (minZ, maxZ) = (0, 0)
	private(set) var (minW, maxW) = (0, 0)
	private(set) var allPoints = Set<Point4D>()

	init(_ inputLines: [String]) {
		for y in 0..<inputLines.count {
			let chars = inputLines[y].map { String($0) }
			for x in 0..<chars.count {
				if chars[x] == "#" {
					add(x, y, 0, 0)
				}
			}
		}
	}

	init() {
		self.init([])
	}

	mutating func add(_ x: Int, _ y: Int, _ z: Int, _ w: Int) {
		if x < minX { minX = x }
		if x > maxX { maxX = x }
		if y < minY { minY = y }
		if y > maxY { maxY = y }
		if z < minZ { minZ = z }
		if z > maxZ { maxZ = z }
		if w < minW { minW = w }
		if w > maxW { maxW = w }
		allPoints.insert(Point4D(x, y, z, w))
	}

	/// Applies the Conway-ish rules and returns the resulting set of active points.
	func cycle() -> PointSet4D {
		var newActiveSet = PointSet4D()

		// Examine all points in a box **one larger in every direction** than the bounding
		// box of all our active points.  Any point outside that box has no active
		// neighbors, so will remain inactive.
		for x in (minX - 1)...(maxX + 1) {
			for y in (minY - 1)...(maxY + 1) {
				for z in (minZ - 1)...(maxZ + 1) {
					for w in (minW - 1)...(maxW + 1) {
						let point = Point4D(x, y, z, w)
						let numActiveNeighbors = (neighbors(of: point)
													.filter { allPoints.contains($0) }
													.count)
						if allPoints.contains(point) {
							if numActiveNeighbors == 2 || numActiveNeighbors == 3 {
								newActiveSet.add(x, y, z, w)
							}
						} else {
							if numActiveNeighbors == 3 {
								newActiveSet.add(x, y, z, w)
							}
						}
					}
				}
			}
		}

		return newActiveSet
	}

	func neighbors(of point: Point4D) -> [Point4D] {
		var result = [Point4D]()
		for dx in [-1, 0, 1] {
			for dy in [-1, 0, 1] {
				for dz in [-1, 0, 1] {
					for dw in [-1, 0, 1] {
						if (dx, dy, dz, dw) != (0, 0, 0, 0) {
							result.append(Point4D(point.x + dx,
												  point.y + dy,
												  point.z + dz,
												  point.w + dw))
						}
					}
				}
			}
		}
		return result
	}
}

