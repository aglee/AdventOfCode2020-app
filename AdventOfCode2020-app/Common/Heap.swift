////// Modified the code from this Ray Wenderlich tutorial:
/// <https://www.raywenderlich.com/586-swift-algorithm-club-heap-and-priority-queue-data-structure>.
struct Heap<Element> {
	// MARK: - Properties

	private(set) var elements: [Element]
	var isEmpty: Bool { return elements.isEmpty }
	var count: Int { return elements.count }

	/// Returns true if the **first** argument is higher priority, i.e. firstArg > secondArg.
	let priorityFunction : (Element, Element) -> Bool

	// MARK: - Init/deinit

	init(elements: [Element] = [], priorityFunction: @escaping (Element, Element) -> Bool) {
		self.elements = elements
		self.priorityFunction = priorityFunction
		buildHeap()
	}

	// MARK: - Priority queue

	func peek() -> Element? {
		return elements.first
	}

	mutating func insert(_ element: Element) {
		elements.append(element)
		siftUp(elementAtIndex: count - 1)
	}

	mutating func pop() -> Element? {
		guard !isEmpty
			else { return nil }
		swapElement(at: 0, with: count - 1)
		let element = elements.removeLast()
		if !isEmpty {
			siftDown(elementAtIndex: 0)
		}
		return element
	}

	// MARK: - Private methods

	/// Used by init.
	private mutating func buildHeap() {
		for index in (0 ..< count / 2).reversed() {
			siftDown(elementAtIndex: index)
		}
	}

	mutating func siftUp(elementAtIndex index: Int) {
		let parent = parentIndex(of: index)
		guard !isRoot(index),
			isHigherPriority(at: index, than: parent)
			else { return }
		swapElement(at: index, with: parent)
		siftUp(elementAtIndex: parent)
	}

	private mutating func siftDown(elementAtIndex index: Int) {
		let childIndex = highestPriorityIndex(for: index) // 1
		if index == childIndex { // 2
			return
		}
		swapElement(at: index, with: childIndex) // 3
		siftDown(elementAtIndex: childIndex)
	}

	private func isRoot(_ index: Int) -> Bool {
		return (index == 0)
	}

	private func leftChildIndex(of index: Int) -> Int {
		return (2 * index) + 1
	}

	private func rightChildIndex(of index: Int) -> Int {
		return (2 * index) + 2
	}

	private func parentIndex(of index: Int) -> Int {
		return (index - 1) / 2
	}

	private func isHigherPriority(at firstIndex: Int, than secondIndex: Int) -> Bool {
		return priorityFunction(elements[firstIndex], elements[secondIndex])
	}

	private func highestPriorityIndex(of parentIndex: Int, and childIndex: Int) -> Int {
		guard childIndex < count && isHigherPriority(at: childIndex, than: parentIndex)
			else { return parentIndex }
		return childIndex
	}

	private func highestPriorityIndex(for parent: Int) -> Int {
		return highestPriorityIndex(of: highestPriorityIndex(of: parent, and: leftChildIndex(of: parent)), and: rightChildIndex(of: parent))
	}

	private mutating func swapElement(at firstIndex: Int, with secondIndex: Int) {
		if firstIndex != secondIndex {
			elements.swapAt(firstIndex, secondIndex)
		}
	}
}

