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

	/// Assumes all numbers are single non-zero digits, and that the input string is
	/// well-formed (no unexpected characters, parens are balanced, etc.).
	func evalForPart1(_ s: String) -> Int {
		func eval() -> Int {
			func processValue(_ value: Int) {
				if result == nil {
					result = value
				} else {
					if op == "+" {
						result = result! + value
					} else if op == "*" {
						result = result! * value
					} else {
						abort()
					}
					op = nil
				}

//				print("processed value \(value), result is \(result!)")
			}

//			print("ENTERING eval")
			var op: String?
			var result: Int?
			while charIndex < chars.count {
				let ch = chars[charIndex]
				charIndex += 1

				switch ch {
				case " ":
					// We can ignore spaces.
					()
				case "1"..."9":
					processValue(Int(ch)!)
				case "+", "*":
					assert(op == nil)
					op = ch
				case "(":
					processValue(eval())
				case ")":
//					print("EXITING eval on closing paren with result \(result!)")
					return result!
				default:
					abort()
				}
			}
//			print("EXITING eval with result \(result!)")
			return result!
		}

		let chars = s.map { String($0) }
		var charIndex = 0
		return eval()
	}

	func evalForPart2(_ s: String) -> Int {
		let expr = parseExpression(s)
		expr.applyPrecedence()
		return expr.eval()
	}

	override func solvePart1(inputLines: [String]) -> String {
		return String(inputLines.map({ evalForPart1($0) }).reduce(0, +))
	}

	override func solvePart2(inputLines: [String]) -> String {
		return String(inputLines.map({ evalForPart2($0) }).reduce(0, +))
	}
}


