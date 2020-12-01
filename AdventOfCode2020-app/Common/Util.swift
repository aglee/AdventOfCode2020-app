import Foundation

func ERRORPRINT(_ s: String) {
	print("ERROR: \(s)")
}

var DEBUGPRINT_ENABLED = true
func DEBUGPRINT(_ s: String) {
	if DEBUGPRINT_ENABLED {
		print("DEBUG: \(s)")
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

