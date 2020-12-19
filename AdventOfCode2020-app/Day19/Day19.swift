import Foundation

class Day19: DayNN {
	init() {
		super.init("Monster Messages")
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
			// Note: one of these tests uses Part 1.  The puzzle description for Part 2
			// points out the different result we get with the input in file 2 if we use
			// the Part 1 algorithm as compared with the Part 2 algorithm.
			testPart1(fileNumber: 2, expectedResult: "3"),
			testPart2(fileNumber: 2, expectedResult: "12"),
		]
	}

	// MARK: - Solving

	/// A `Production` is a rule of the grammar.  It represents one of the ways a `Rule`
	/// can match a string.
	///
	/// If `letter` is non-nil, matching the `Production` means matching that letter (it
	/// should be a single character), and `subruleNumbers` is ignored (it should be
	/// empty).  If `letter` is nil, then matching the `Production` means matching
	/// **all** the rules specified by `subruleNumbers`, in that order.
	///
	/// This is one type used in two different ways.  I was too lazy to separate these
	/// concerns into two different types.
	struct Production: CustomStringConvertible {
		let letter: String?
		let subruleNumbers: [Int]

		/// `s` should either be a character inside double-quotes, or a list of numbers
		/// separated by spaces.
		init(_ s: String) {
			if s.hasPrefix("\"") {
				// We're looking at a "match a letter" type of production.
				var unquoted = s
				unquoted.removeFirst()
				unquoted.removeLast()
				self.letter = unquoted
				self.subruleNumbers = []
			} else {
				// We're looking at a "match all the subrules" type of production.
				self.letter = nil
				self.subruleNumbers = s.split(separator: " ").map { Int($0)! }
			}
		}

		var description: String {
			if let letter = letter {
				return "\"\(letter)\""
			} else {
				return "\(subruleNumbers)"
			}
		}
	}

	/// Matching a `Rule` means matching **any** of its `productions`.
	struct Rule: CustomStringConvertible {
		let number: Int
		let productions: [Production]

		/// See the puzzle description for the expected format of the input string.
		///
		/// Examples:
		///
		/// ```text
		/// 0: 1 2
		/// 1: "a"
		/// 2: 1 3 | 3 1
		/// 3: "b"
		/// ```
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

	/// A grammar specified by puzzle inputs.
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

		/// Returns true if the entire string exactly matches `rules[0]`.
		func matches(_ s: String) -> Bool {
			/// By "jump" I mean a position within the input (i.e. an index into the
			/// `chars` array) where we could end up after matching the given production.
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

				// Assuming we start at `startingPos`, calculate all the positions we
				// could end up at after matching **all** the rules in `subruleNumbers`.
				result = Set([startingPos])
				for ruleNum in prod.subruleNumbers {
					var ruleJumps = Set<Int>()
					for start in result {
						ruleJumps.formUnion(jumpsMatchingRule(rules[ruleNum]!, startingAt: start))
					}
					result = ruleJumps
				}
				result.remove(startingPos)

				return result
			}

			/// By "jump" I mean a position within the input (i.e. an index into the
			/// `chars` array) where we could end up after matching the given rule.
			/// Since matching the rule means matching *any* of its productions, we want
			/// the union of all the ways we could match a production.
			func jumpsMatchingRule(_ rule: Rule, startingAt startingPos: Int) -> Set<Int> {
				var result = Set<Int>()
				for prod in rule.productions {
					result.formUnion(jumpsMatchingProduction(prod, startingAt: startingPos))
				}
				return result
			}

			// We have a match if there is a way to match `rules[0]` that puts us exactly
			// at the end of the input string.
			let chars = s.map { String($0) }
			let jumps = jumpsMatchingRule(rules[0]!, startingAt: 0)
			return jumps.contains(chars.count)
		}
	}

	/// Tries to match a list of input strings against a grammar, and returns the results.
	///
	/// - Parameter inputLines:		Contains a grammar and a list of input strings.
	/// - Parameter tweakForPart2:	Pass true to solve Part 2 of the puzzle.  It modifies
	///								the grammar as specified in the puzzle description.
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


