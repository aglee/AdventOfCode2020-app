import Foundation

class Cup {
	let number: Int
	var next: Cup {
		get { realNext! }
		set { realNext = newValue }
	}
	private var realNext: Cup?

	init(_ n: Int) {
		self.number = n
	}
}

/// Implements the game using a circular linked list of cups.
class CupCircle {
	var currentCup: Cup
	var lookup = [Int: Cup]()

	/// It's assumed `digitString` contains the digits 1...n.
	convenience init(_ digitString: String) {
		let cupNumbers = digitString.map { Int(String($0))! }
		self.init(cupNumbers: cupNumbers)
	}

	init(cupNumbers: [Int]) {
		for num in cupNumbers {
			lookup[num] = Cup(num)
		}

		self.currentCup = lookup[cupNumbers[0]]!
		for i in 1..<cupNumbers.count {
			lookup[cupNumbers[i - 1]]!.next = lookup[cupNumbers[i]]!
		}
		lookup[cupNumbers.last!]!.next = self.currentCup
	}

	/// This was mainly a convenience to not have force-unwrap dictionary lookups all over
	/// the place, but it turned out not to be that many places.
	func cupWithNumber(_ cupNumber: Int) -> Cup {
		return lookup[cupNumber]!
	}

	func move() {
		func prevCupByNumber(_ cup: Cup) -> Cup {
			let num = ((cup.number == 1) ? lookup.count : cup.number - 1)
			return cupWithNumber(num)
		}

		func destCup() -> Cup {
			var result = prevCupByNumber(currentCup)
			while snippedNumbers.contains(result.number) {
				result = prevCupByNumber(result)
			}
			return result
		}

		// Remove the next 3 cups after the current cup.
		let snippedNumbers = [currentCup.next.number, currentCup.next.next.number, currentCup.next.next.next.number]
		let snipFirst = currentCup.next
		let snipLast = currentCup.next.next.next
		currentCup.next = snipLast.next

		// Figure out the "destination" cup.
		let dest = destCup()

		// Splice the snipped cups back into the circle, after the destination cup.
		snipLast.next = dest.next
		dest.next = snipFirst

		// Set the new current cup.
		currentCup = currentCup.next
	}

	func debugString() -> String {
		func str(_ n: Int) -> String {
			return ((n == currentCup.number) ? "(\(n))" : "\(n)")
		}

		var curr = cupWithNumber(1).next
		var output = "\(str(curr.number))"
		for _ in 0..<(lookup.count - 1) {
			curr = curr.next
			output += "\(str(curr.number))"
		}
		return output
	}

	func outputString() -> String {
		var curr = cupWithNumber(1).next
		var output = "\(curr.number)"
		for _ in 0..<(lookup.count - 2) {
			curr = curr.next
			output += "\(curr.number)"
		}
		return output
	}
}

class Day23: DayNN {
	init() {
		super.init("Crab Cups")
		self.part1Tests = [
			testPart1(fileNumber: 1, expectedResult: "67384529"),
		]
		self.part2Tests = [
			testPart2(fileNumber: 1, expectedResult: "149245887792"),
		]
	}

	// MARK: - Solving

	override func solvePart1(inputLines: [String]) -> String {
		let circ = CupCircle(inputLines[0])
		for _ in 0..<100 {
			circ.move()
		}
		return circ.outputString()
	}

	override func solvePart2(inputLines: [String]) -> String {
		let digits = inputLines[0]
		var cupNumbers = digits.map { Int(String($0))! }
		for num in (digits.count + 1)...1_000_000 {
			cupNumbers.append(num)
		}
		let circ = CupCircle(cupNumbers: cupNumbers)
		for _ in 0..<10_000_000 {
			circ.move()
		}
		let cup1 = circ.cupWithNumber(1).next
		let cup2 = cup1.next
		return String(cup1.number * cup2.number)
	}
}


