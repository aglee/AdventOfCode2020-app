import Foundation

class Day19: DayNN {
	init() {
		super.init("PUT_DESCRIPTION_HERE")
		self.part1Tests = [
			test(fileNumber: 1,
				 function: {
					let matchResults = self.matchingResults($0, tweakForPart2: false)
					return matchResults.map { String($0) }.joined(separator: ",")
				 },
				 expectedResult: "true,false,true,false,false"),
			testPart1(fileNumber: 1, expectedResult: "2"),
		]
		self.part2Tests = [
			// Note one of these tests uses Part 1.  The puzzle description for Part 2
			// points out the result we get if we use the Part 1 algorithm.
			testPart1(fileNumber: 2, expectedResult: "3"),
			testPart2(fileNumber: 2, expectedResult: "12"),
		]
	}

	// MARK: - Solving

	struct Production: CustomStringConvertible {
		let numbers: [Int]
		let letter: String?

		init(_ s: String) {
			if s.hasPrefix("\"") {
				var unquoted = s
				unquoted.removeFirst()
				unquoted.removeLast()
				self.letter = unquoted
				self.numbers = []
			} else {
				self.letter = nil
				self.numbers = s.split(separator: " ").map { Int($0)! }
			}
		}

		var description: String {
			if let letter = letter {
				return "\"\(letter)\""
			} else {
				return "\(numbers)"
			}
		}
	}

	struct Rule: CustomStringConvertible {
		let number: Int
		let productions: [Production]

		init(_ s: String) {
			let numberAndProductions = s.components(separatedBy: ": ")
			let numberString = numberAndProductions[0]
			let productionStrings = numberAndProductions[1].components(separatedBy: " | ")

			self.number = Int(numberString)!
			self.productions = productionStrings.map { Production($0) }
		}

		var description: String {
			let prods = productions.map { "\($0)" }.joined(separator: " | ")
			return "\(number): \(prods)"
		}
	}

	class RuleSet {
		var rules: [Int: Rule]

		init(_ ruleStrings: [String]) {
			var lookup = [Int: Rule]()
			for s in ruleStrings {
				let rule = Rule(s)
				lookup[rule.number] = rule
			}

			self.rules = lookup
		}

		func matches(_ s: String) -> Bool {
			func jumpsMatchingProduction(_ prod: Production, startingAt startingPos: Int) -> Set<Int> {
				var result = Set<Int>()

				if startingPos == chars.count {
					return result
				}

				if let letter = prod.letter {
					if chars[startingPos] == letter {
						result.insert(startingPos + 1)
					}
					return result
				}

				result = Set([startingPos])
				for ruleNum in prod.numbers {
					var ruleJumps = Set<Int>()
					for start in result {
						ruleJumps.formUnion(jumpsMatchingRule(rules[ruleNum]!, startingAt: start))
					}
					result = ruleJumps
				}
				result.remove(startingPos)

				return result
			}

			func jumpsMatchingRule(_ rule: Rule, startingAt startingPos: Int) -> Set<Int> {
				var result = Set<Int>()
				for prod in rule.productions {
					result.formUnion(jumpsMatchingProduction(prod, startingAt: startingPos))
				}
				return result
			}

			let chars = s.map { String($0) }
			let jumps = jumpsMatchingRule(rules[0]!, startingAt: 0)
			return jumps.contains(chars.count)
		}
	}

	func matchingResults(_ inputLines: [String], tweakForPart2: Bool) -> [Bool] {
		let rulesAndMessages = groupedLines(inputLines)
		let ruleStrings = rulesAndMessages[0]
		let messages = rulesAndMessages[1]

		let ruleSet = RuleSet(ruleStrings)
		if tweakForPart2 {
			ruleSet.rules[8] = Rule("8: 42 | 42 8")
			ruleSet.rules[11] = Rule("11: 42 31 | 42 11 31")
		}
		return messages.map { ruleSet.matches($0) }
	}

	override func solvePart1(inputLines: [String]) -> String {
		return String(matchingResults(inputLines, tweakForPart2: false).filter { $0 }.count)
	}

	override func solvePart2(inputLines: [String]) -> String {
		return String(matchingResults(inputLines, tweakForPart2: true).filter { $0 }.count)
	}
}


