import Foundation

func ERRORPRINT(_ s: String) {
	print("ERROR: \(s)")
}

var DEBUGPRINT_ENABLED = false
func DEBUGPRINT(_ s: String) {
	if DEBUGPRINT_ENABLED {
//		print("DEBUG: \(s)")
		print(s)
	}
}

func compareInts(_ a: Int, _ b: Int) -> ComparisonResult {
	if (a < b) { return .orderedAscending}
	if (a > b) { return .orderedDescending }
	return .orderedSame
}

extension String {
	func toArray() -> [String] {
		var arr = [String]()
		let s = NSString(string: self)
		for charIndex in 0..<s.length {
			arr.append(s.substring(with: NSRange(location: charIndex, length: 1)))
		}
		return arr
	}
}

/// Splits the given array into groups separated by empty lines.  Consecutive empty lines
/// are treated as a single empty line.
func groupedLines(_ inputLines: [String]) -> [[String]] {
	var groups = [[String]]()
	var currentGroup: [String]?
	for line in inputLines {
		if line.count == 0 {
			if let g = currentGroup {
				groups.append(g)
			}
			currentGroup = nil
		} else {
			if currentGroup == nil {
				currentGroup = [String]()
			}
			currentGroup?.append(line)
		}
	}
	if let p = currentGroup {
		groups.append(p)
	}
	return groups
}

