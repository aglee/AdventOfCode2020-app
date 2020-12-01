import Foundation

/// Node within a directed graph.
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

	/// Traverses the sub-graph rooted at self, performing the given action on each
	/// visited node, until either the action returns `.shouldStop` or all descendant
	/// nodes have been visited.
	func depthFirst(action: (Node)->FlowControl) -> FlowControl {
		for child in children {
			if child.depthFirst(action: action) == .shouldStop {
				return .shouldStop
			}
		}
		return action(self)
	}
}


