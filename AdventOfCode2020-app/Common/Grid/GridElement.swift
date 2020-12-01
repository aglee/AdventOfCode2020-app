import Foundation

/// Contents of one point on a Grid.
///
/// Implementation is based on Advent of Code requirements that vary from year to year.
enum GridElement: String {
	case empty = "."
	case hyphen = "-"
	case star = "*"

	static let emptySignifier = GridElement.empty

	var symbolForPrinting: String {
		return rawValue
	}
}




