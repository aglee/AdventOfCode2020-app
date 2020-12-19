import Foundation

protocol Expression {
	func eval() -> Int
	func asString() -> String
}

class NumberExpression: Expression {
	let value: Int
	init(_ value: Int) { self.value = value }

	// MARK: - Expression protocol

	func eval() -> Int { return value }
	func asString() -> String { return String(value) }
}

class CompoundExpression: Expression {
	static var useOperatorPrecedence = false

	var operations = [(op: String, term: Expression)]()

	init(initialTerm: Expression) {
		self.operations = [("<ignore>", initialTerm)]
	}

	func add(op: String, term: Expression) {
		assert(["+", "*"].contains(op))
		if CompoundExpression.useOperatorPrecedence {
			// In this puzzle, unlike in real math, it's "+" that takes precedence rather
			// than "*".  When we see a term being added, instead of appending the
			// addition to our list of operations we combine the term with the previous
			// term inside a PlusExpression, to force the addition to take precedence when
			// we evaluate the expression.
			if op == "+" {
				let lastIndex = operations.count - 1
				operations[lastIndex].term = PlusExpression(operations[lastIndex].term, term)
			} else {
				operations.append((op, term))
			}
		} else {
			operations.append((op, term))
		}
	}

	// MARK: - Expression protocol

	func eval() -> Int {
		var result = operations[0].term.eval()  // parts[0].op is ignored.
		for i in 1..<operations.count {
			let (op, term) = operations[i]
			switch op {
			case "+":
				result += term.eval()
			case "*":
				result *= term.eval()
			default:
				abort()
			}
		}
		return result
	}

	func asString() -> String {
		var result = operations[0].term.asString()

		for i in 1..<operations.count {
			let (op, term) = operations[i]
			result = "\(result) \(op) \(term.asString())"
		}

		if operations.isEmpty {
			return result
		} else {
			return "(\(result))"
		}
	}
}

class PlusExpression: Expression {
	var term1: Expression
	var term2: Expression

	init(_ term1: Expression, _ term2: Expression) {
		self.term1 = term1
		self.term2 = term2
	}

	// MARK: - Expression protocol

	func eval() -> Int { return term1.eval() + term2.eval() }
	func asString() -> String { return "(\(term1.asString()) + \(term2.asString()))" }
}

/// Parses an expression that is assumed to be well-formed.
///
/// - expr = term (op term)*
/// - term = number | \(expr\)
/// - number = \1...\9
/// - op = \+|\*
func parseExpression(_ s: String) -> Expression {
	class Tokens {
		let tokens: [String]
		var tokenIndex = 0
		var hasMore: Bool { return tokenIndex < tokens.count }

		init(_ s: String) {
			// Since the input only has single-digit numbers, each character is a token
			// and we can ignore spaces.
			self.tokens = s.map { String($0) }.filter { $0 != " " }
		}

		func next() -> String {
			let token = tokens[tokenIndex]
			tokenIndex += 1
			return token
		}
	}

	/// Assumes we're looking at the beginning of the first term of an expression.
	func parseExpression() -> Expression {
		// Tentatively assume the expression we're looking at has multiple terms.  Parse
		// the first of those terms.
		let result = CompoundExpression(initialTerm: parseTerm())

		// Parse `op term` zero or more times until we reach either a closing parenthesis
		// or the end of input.
		while tokens.hasMore {
			let token = tokens.next()

			// `token` is either an operator or the term's closing parenthesis.
			if token == ")" {
				break
			}
			result.add(op: token, term: parseTerm())
		}

		// If `result` only contains a single term then return that term.
		if result.operations.count == 1 {
			return result.operations[0].term
		} else {
			return result
		}
	}

	/// Assumes we're looking at the beginning of a term, i.e. either a digit or an
	/// opening parenthesis.
	func parseTerm() -> Expression {
		let token = tokens.next()
		switch token {
		case "1"..."9":
			return NumberExpression(Int(token)!)
		case "(":
			return parseExpression()
		default:
			abort()
		}
	}

	let tokens = Tokens(s)
	return parseExpression()
}
