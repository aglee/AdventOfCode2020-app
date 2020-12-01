import Foundation

/// Performs a [topological sort](https://en.wikipedia.org/wiki/Topological_sorting).
///
/// **NOTE:** This function destroys the graph.  If you need to preserve the graph, make
/// a copy.
func topSort(rootNodes: [Node]) -> [Node] {
	var result = [Node]()
	var rootNodes = rootNodes
	while rootNodes.count > 0 {
		// Remove a root node from the graph.  If doing so causes any of its children to
		// become root nodes, add them to the collection of root nodes.
		let node = rootNodes.removeLast()
		result.append(node)
		for child in node.children {
			node.removeChild(child)
			if child.parents.count == 0 {
				rootNodes.append(child)
			}
		}
	}
	return result
}

