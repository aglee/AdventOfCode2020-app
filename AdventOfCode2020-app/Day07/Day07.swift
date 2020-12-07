import Foundation


struct LuggageRuleset {
	typealias BagColor = String

	/// Remembering this order helps with debugging.  I can compare the output of
	/// `dumpParentToChildRelationships` to the input file.
	private var parentsInOrderGiven: [BagColor] = []
	/// Key is parent color.  Value is a mapping of child colors to the corresponding amounts.
	private var bagChildren: [BagColor: [BagColor: Int]] = [:]
	/// Key is child color.  Value is set of all parent colors that have that color as a child.
	/// If `bagParents[color]` is nil, that color has no parent.
	private var bagParents: [BagColor: Set<BagColor>] = [:]

	init(_ inputLines: [String]) {
		for line in inputLines {
			addRule(line)
		}
//		dumpParentToChildRelationships()
//		dumpChildToParentRelationships()
	}

	/// Used during debugging.
	private func dumpParentToChildRelationships() {
		print("--- parent -> child ---")
		for parentColor in parentsInOrderGiven {
			let children = bagChildren[parentColor]!
			let childStrings = children.map { "(\($0.key), \($0.value))" }
			let childrenString = childStrings.joined(separator: ", ")
			print("\(parentColor) -> \(childrenString)")
		}
		print()
	}

	/// Used during debugging.
	private func dumpChildToParentRelationships() {
		print("--- child -> parent ---")
		for (childColor, parentColors) in bagParents {
			print("\(childColor) -> \(Array(parentColors))")
		}
		print()
	}

	/// Each line of the input specifies a "parent" color and one or more "child" colors.
	/// Each child color has an associated count.
	///
	/// "light red bags contain 1 bright white bag, 2 muted yellow bags."
	private mutating func addRule(_ line: String) {
		// Parse the parent color.
		let parentAndChildren = line.components(separatedBy: " bags contain ")
		let parentColor = parentAndChildren[0]  // "light red"
		let childrenString = parentAndChildren[1]  // "1 bright white bag, 2 muted yellow bags."
		assert(bagChildren[parentColor] == nil, "Expected every rule to have a distinct parent color.")
		parentsInOrderGiven.append(parentColor)

		// Special case: parent has no children.
		if childrenString == "no other bags." {
			bagChildren[parentColor] = [:]
			return
		}

		// Parse the list of child colors and their amounts.
		var children: [BagColor: Int] = [:]
		let childStrings = childrenString.components(separatedBy: ", ")
		for childString in childStrings {  // "1 bright white bag"
			// Parse the color and amount.
			var words = childString.components(separatedBy: " ")  // ["1", "bright", "white", "bag"]
			words.removeLast()  // ["1", "bright", "white"]
			let count = Int(words.removeFirst())!  // count is 1, words is ["bright", "white"]
			let childColor = words.joined(separator: " ")  // "bright white"

			// Add the parent-child relationship.
			assert(children[childColor] == nil, "Expected each of a parent's child colors to be distinct.")
			children[childColor] = count

			// Add the child-parent relationship.
			if bagParents[childColor] == nil {
				bagParents[childColor] = Set<BagColor>()
			}
			bagParents[childColor]?.insert(parentColor)
		}
		bagChildren[parentColor] = children
	}

	/// Result **DOES NOT INCLUDE** the given color.
	func ancestorsExclusive(of color: BagColor) -> Set<BagColor> {
		var result = Set<BagColor>()

		// Breadth-first traversal of the child-parent graph.
		var queue = Array(bagParents[color]!)
		while queue.count > 0 {
			let currentColor = queue.removeFirst()
			result.insert(currentColor)

			if let parents = bagParents[currentColor] {
				queue.append(contentsOf: parents)
			}
		}

		return result
	}

	/// Result **INCLUDES** the given color.
	func numberOfDescendantsInclusive(of color: BagColor) -> Int {
		var result = 1

		for (childColor, count) in bagChildren[color]! {
			result += count * numberOfDescendantsInclusive(of: childColor)
		}

		return result
	}
}

class Day07: DayNN {
	init() {
		super.init("DayXX")
		self.part1Tests = [
			testPart1(fileNumber: 1, expectedResult: "4"),
		]
		self.part2Tests = [
			testPart2(fileNumber: 1, expectedResult: "32"),
			testPart2(fileNumber: 2, expectedResult: "126"),
		]
	}

	// MARK: - Solving

	override func solvePart1(inputLines: [String]) -> String {
		let ruleSet = LuggageRuleset(inputLines)
		let ancestors = ruleSet.ancestorsExclusive(of: "shiny gold")
		return String(ancestors.count)
	}

	override func solvePart2(inputLines: [String]) -> String {
		let ruleSet = LuggageRuleset(inputLines)
		return String(ruleSet.numberOfDescendantsInclusive(of: "shiny gold") - 1)
	}

}


