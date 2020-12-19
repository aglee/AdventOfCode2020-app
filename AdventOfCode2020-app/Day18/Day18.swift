import Foundation

class Day18: DayNN {
	init() {
		super.init("Operation Order")
		self.part1Tests = [
			test(input: "1 + 2 * 3 + 4 * 5 + 6",
				 function: { return String(self.evalForPart1($0)) },
				 expectedResult: "71"),
			test(input: "1 + (2 * 3) + (4 * (5 + 6))",
				 function: { return String(self.evalForPart1($0)) },
				 expectedResult: "51"),
			test(input: "2 * 3 + (4 * 5)",
				 function: { return String(self.evalForPart1($0)) },
				 expectedResult: "26"),
			test(input: "5 + (8 * 3 + 9 + 3 * 4 * 3)",
				 function: { return String(self.evalForPart1($0)) },
				 expectedResult: "437"),
			test(input: "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))",
				 function: { return String(self.evalForPart1($0)) },
				 expectedResult: "12240"),
			test(input: "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2",
				 function: { return String(self.evalForPart1($0)) },
				 expectedResult: "13632"),
		]
		self.part2Tests = [
			test(input: "1 + 2 * 3 + 4 * 5 + 6",
				 function: { return String(self.evalForPart2($0)) },
				 expectedResult: "231"),
			test(input: "1 + (2 * 3) + (4 * (5 + 6))",
				 function: { return String(self.evalForPart2($0)) },
				 expectedResult: "51"),
			test(input: "2 * 3 + (4 * 5)",
				 function: { return String(self.evalForPart2($0)) },
				 expectedResult: "46"),
			test(input: "5 + (8 * 3 + 9 + 3 * 4 * 3)",
				 function: { return String(self.evalForPart2($0)) },
				 expectedResult: "1445"),
			test(input: "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))",
				 function: { return String(self.evalForPart2($0)) },
				 expectedResult: "669060"),
			test(input: "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2",
				 function: { return String(self.evalForPart2($0)) },
				 expectedResult: "23340"),
		]
	}

	// MARK: - Solving

	func evalForPart1(_ s: String) -> Int {
		CompoundExpression.useOperatorPrecedence = false
		return parseExpression(s).eval()
	}

	func evalForPart2(_ s: String) -> Int {
		CompoundExpression.useOperatorPrecedence = true
		return parseExpression(s).eval()
	}

	override func solvePart1(inputLines: [String]) -> String {
		CompoundExpression.useOperatorPrecedence = false
		return String(inputLines.map({ evalForPart1($0) }).reduce(0, +))
	}

	override func solvePart2(inputLines: [String]) -> String {
		return String(inputLines.map({ evalForPart2($0) }).reduce(0, +))
	}
}


