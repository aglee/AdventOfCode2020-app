import Foundation

/// Node within a bidirectional directed graph.
class Node {
	enum FlowControl {
		case shouldStop, shouldContinue
	}

	let name: String
	private(set) var parents = [Node]()
	private(set) var children = [Node]()

	init(_ name: String) {
		self.name = name
	}

	func addChild(_ child: Node) {
		assert(!child.parents.contains(where: { $0 === self }))
		child.parents.append(self)
		children.append(child)
	}

	func removeChild(_ child: Node) {
		assert(child.parents.contains(where: { $0 === self }))
		child.parents.append(self)
		child.parents.removeAll(where: { $0 === self })
		children.removeAll(where: { $0 === child })
	}

	/// Does a depth-first traversal of the graph rooted at self, performing the given
	/// action on each visited node, until either the action returns `.shouldStop` or all
	/// descendant nodes have been visited.
	///
	/// Does not check for cycles, so this could potentially lead to an infinite
	/// recursion.  It's up to you to deal with this possibility, either because you know
	/// there are no cycles or because you add your own cycle handling.
	func depthFirst(action: (Node)->FlowControl) -> FlowControl {
		for child in children {
			if child.depthFirst(action: action) == .shouldStop {
				return .shouldStop
			}
		}
		return action(self)
	}
}


