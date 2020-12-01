import Foundation

class NodeLookup {
	private var nodesByName = [String: Node]()

	var rootNodes: [Node] {
		return nodesByName.values.filter { $0.parents.count == 0 }
	}

	func getOrCreateNode(name: String) -> Node {
		if let node = nodesByName[name] {
			return node
		} else {
			let node = Node(name)
			nodesByName[name] = node
			return node
		}
	}
}

