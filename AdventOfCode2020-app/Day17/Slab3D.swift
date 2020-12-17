struct Point3D: Hashable {
	var x = 0
	var y = 0
	var z = 0

	init(_ x: Int, _ y: Int, _ z: Int) {
		(self.x, self.y, self.z) = (x, y, z)
	}
}

class Slab3D {
	var minX = 0
	var maxX = 0
	var minY = 0
	var maxY = 0
	var minZ = 0
	var maxZ = 0
	var activePoints = Set<Point3D>()

	init(_ inputLines: [String]) {
		for y in 0..<inputLines.count {
			let chars = inputLines[y].map { String($0) }
			for x in 0..<chars.count {
				if chars[x] == "#" {
					addActive(x, y, 0)
				}
			}
		}
	}

	convenience init() {
		self.init([])
	}

	func addActive(_ x: Int, _ y: Int, _ z: Int) {
		if x < minX { minX = x }
		if x > maxX { maxX = x }
		if y < minY { minY = y }
		if y > maxY { maxY = y }
		if z < minZ { minZ = z }
		if z > maxZ { maxZ = z }
		activePoints.insert(Point3D(x, y, z))
	}

	func cycle() -> Slab3D {
		let newSlab = Slab3D()

		for x in (minX - 1)...(maxX + 1) {
			for y in (minY - 1)...(maxY + 1) {
				for z in (minZ - 1)...(maxZ + 1) {
					let point = Point3D(x, y, z)
					let numActiveNeighbors = (neighbors(of: point)
												.filter { activePoints.contains($0) }
												.count)
					if activePoints.contains(point) {
						if numActiveNeighbors == 2 || numActiveNeighbors == 3 {
							newSlab.addActive(x, y, z)
						}
					} else {
						if numActiveNeighbors == 3 {
							newSlab.addActive(x, y, z)
						}
					}
				}
			}
		}

		return newSlab
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
					line += (activePoints.contains(point) ? "#" : ".")
				}
				print(line)
			}
			print()
		}
	}
}

