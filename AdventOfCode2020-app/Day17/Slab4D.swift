struct Point4D: Hashable {
	var x = 0
	var y = 0
	var z = 0
	var w = 0

	init(_ x: Int, _ y: Int, _ z: Int, _ w: Int) {
		(self.x, self.y, self.z, self.w) = (x, y, z, w)
	}
}

class Slab4D {
	var minX = 0
	var maxX = 0
	var minY = 0
	var maxY = 0
	var minZ = 0
	var maxZ = 0
	var minW = 0
	var maxW = 0
	var activePoints = Set<Point4D>()

	init(_ inputLines: [String]) {
		for y in 0..<inputLines.count {
			let chars = inputLines[y].map { String($0) }
			for x in 0..<chars.count {
				if chars[x] == "#" {
					addActive(x, y, 0, 0)
				}
			}
		}
	}

	convenience init() {
		self.init([])
	}

	func addActive(_ x: Int, _ y: Int, _ z: Int, _ w: Int) {
		if x < minX { minX = x }
		if x > maxX { maxX = x }
		if y < minY { minY = y }
		if y > maxY { maxY = y }
		if z < minZ { minZ = z }
		if z > maxZ { maxZ = z }
		if w < minW { minW = w }
		if w > maxW { maxW = w }
		activePoints.insert(Point4D(x, y, z, w))
	}

	func cycle() -> Slab4D {
		let newSlab = Slab4D()

		for x in (minX - 1)...(maxX + 1) {
			for y in (minY - 1)...(maxY + 1) {
				for z in (minZ - 1)...(maxZ + 1) {
					for w in (minW - 1)...(maxW + 1) {
						let point = Point4D(x, y, z, w)
						let numActiveNeighbors = (neighbors(of: point)
													.filter { activePoints.contains($0) }
													.count)
						if activePoints.contains(point) {
							if numActiveNeighbors == 2 || numActiveNeighbors == 3 {
								newSlab.addActive(x, y, z, w)
							}
						} else {
							if numActiveNeighbors == 3 {
								newSlab.addActive(x, y, z, w)
							}
						}
					}
				}
			}
		}

		return newSlab
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

