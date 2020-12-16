import Foundation

class Day16: DayNN {
	init() {
		super.init("Ticket Translation")
		self.part1Tests = [
			testPart1(fileNumber: 1, expectedResult: "71"),
		]
		self.part2Tests = [
			test(fileNumber: 2,
				 function: { PuzzleInfo($0).figureOutFieldOrder().joined(separator: ",") },
				 expectedResult: "row,class,seat"),
		]
	}

	// MARK: - Solving

	override func solvePart1(inputLines: [String]) -> String {
		let p = PuzzleInfo(inputLines)
		var answer = 0
		for ticket in p.nearbyTickets {
			for fieldValue in ticket {
				if p.isDefinitelyInvalidField(fieldValue) {
					answer += fieldValue
				}
			}
		}
		return String(answer)
	}

	override func solvePart2(inputLines: [String]) -> String {
		let p = PuzzleInfo(inputLines)
		let fieldNames = p.figureOutFieldOrder()
		var result = 1
		for (fieldPosition, fieldName) in fieldNames.enumerated() {
			if fieldName.hasPrefix("departure") {
				result *= p.myTicket[fieldPosition]
			}
		}
		return String(result)
	}

	class FieldRule: CustomStringConvertible {
		var name: String
		var ranges: [ClosedRange<Int>]

		init(_ inputLine: String) {
			let nameAndRanges = inputLine.components(separatedBy: ": ")
			self.name = nameAndRanges[0]

			let rangeStrings = nameAndRanges[1].components(separatedBy: " or ")
			self.ranges = rangeStrings.map {
				let minAndMax = $0.split(separator: "-")
				return Int(minAndMax[0])!...Int(minAndMax[1])!
			}
		}

		func isValid(_ n: Int) -> Bool {
			for range in ranges {
				if range.contains(n) {
					return true
				}
			}
			return false
		}

		var description: String {
			let rangeStrings = ranges.map { "\($0.lowerBound)-\($0.upperBound)" }
			return "\(name): \(rangeStrings.joined(separator: " or "))"
		}
	}

	typealias Ticket = [Int]

	class PuzzleInfo {
		var rules = [FieldRule]()
		var myTicket = Ticket()
		var nearbyTickets = [Ticket]()

		init(_ inputLines: [String]) {
			/// `s` must be a comma-separated list of integers.
			func parseTicket(_ s: String) -> Ticket {
				return s.components(separatedBy: ",").map { Int($0)! }
			}

			var lineIndex = 0

			// Parse the rules.  Each line is a rule until we reach an empty line.
			while lineIndex < inputLines.count {
				let line = inputLines[lineIndex]
				if line.isEmpty {
					break
				}
				rules.append(FieldRule(line))
				lineIndex += 1
			}

			// `lineIndex` points to an empty line.  The next two lines must be
			// "your ticket:" followed by a comma-separated list of integers.
			lineIndex += 1
			assert(inputLines[lineIndex] == "your ticket:")
			lineIndex += 1
			self.myTicket = parseTicket(inputLines[lineIndex])

			// The next two lines must be an empty line followed by "nearby tickets:"
			lineIndex += 1
			assert(inputLines[lineIndex].isEmpty)
			lineIndex += 1
			assert(inputLines[lineIndex] == "nearby tickets:")

			// The remaining lines must all be lists of integers, each representing a
			// nearby ticket.
			self.nearbyTickets = inputLines[(lineIndex + 1)..<inputLines.count].map {
				parseTicket($0)
			}
		}

		func isDefinitelyInvalidField(_ n: Int) -> Bool {
			for rule in rules {
				if rule.isValid(n) {
					return false
				}
			}
			return true
		}

		func dumpPuzzleInfo() {
			func ticketString(_ t: Ticket) -> String {
				return t.map({ String($0) }).joined(separator: ",")
			}

			for r in rules {
				print(r)
			}
			print()
			print("your ticket:")
			print(ticketString(myTicket))
			print()
			print("nearby tickets:")
			for t in nearbyTickets {
				print(ticketString(t))
			}
		}

		func figureOutFieldOrder() -> [String] {
			// Make a list with only the good tickets.  Assume a ticket is good if each of
			// its field values satisfies at least one of our rules -- we are told this is
			// the case with our puzzle data.
			var validTickets = [Ticket]()
			for ticket in nearbyTickets {
				var foundBadField = false
				for fieldValue in ticket {
					if isDefinitelyInvalidField(fieldValue) {
						foundBadField = true
						break
					}
				}
				if !foundBadField {
					validTickets.append(ticket)
				}
			}

			// Make a list of possible field names for each position in the ticket.
			// Initially, as far as we know, all field names are candidates for each
			// position.
			let allFieldNames = Set(rules.map { $0.name })
			var possible = Array(repeating: allFieldNames, count: allFieldNames.count)

			// Use the good tickets to narrow the possibilities.  Since every field in a
			// good ticket has a valid value, we can rule out field names for which that
			// value would not be valid.
			let rulesByName: [String: FieldRule] = {
				var lookup = [String: FieldRule]()
				for rule in rules { lookup[rule.name] = rule }
				return lookup
			}()
			for ticket in validTickets {
				for (fieldPosition, fieldValue) in ticket.enumerated() {
					// Remove any field names for which the value at this position is not valid.
					var possibleFieldNames = possible[fieldPosition]
					for name in possible[fieldPosition] {
						if !rulesByName[name]!.isValid(fieldValue) {
							possibleFieldNames.remove(name)
						}
					}
					possible[fieldPosition] = possibleFieldNames
				}
			}

			// Hopefully we have now narrowed at least one field position to only one
			// possible name.  Remove any such definite names from consideration for all
			// the other field positions.  Repeat until every field position has just one
			// candidate name.  This is not mathematically guaranteed to work.  I'm taking
			// a leap of faith that the data has been constructed in a way that will make
			// it work.
			//
			// `definiteNames` is a list of names waiting to be removed from consideration
			// for the field positions they are no longer candidates for.
			var definiteNames = possible.filter { $0.count == 1 }.map { $0.first! }
			while !definiteNames.isEmpty {
				let name = definiteNames.removeLast()
				for fieldPosition in 0..<possible.count {
					if possible[fieldPosition].count > 1 {
						possible[fieldPosition].remove(name)

						// If this field position is now discovered to have a "definite"
						// field name, add that name to our list.
						if possible[fieldPosition].count == 1 {
							definiteNames.append(possible[fieldPosition].first!)
						}
					}
				}
			}

			// At this point, hopefully every element of `possible` contains just one name.
			return possible.map { $0.first! }
		}
	}
}


