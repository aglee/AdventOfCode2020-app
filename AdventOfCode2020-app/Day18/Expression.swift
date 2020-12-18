import Foundation

protocol Expression {
	func eval() -> Int
	func asString() -> String
	func applyPrecedence()
}

extension Expression {
	func applyPrecedence() {}
}

typealias Operation = String

class NumberExpression: Expression {
	let value: Int

	init(_ value: Int) {
		self.value = value
	}

	// MARK: - Expression protocol

	func eval() -> Int {
		return value
	}

	func asString() -> String {
		return String(value)
	}
}

class CompoundExpression: Expression {
	var parts = [(op: Operation, operand: Expression)]()

	init(initialSubexpression: Expression) {
		self.parts = [("*", initialSubexpression)]
	}

	func add(op: String, operand: Expression) {
		assert(["+", "*"].contains(op))
		parts.append((op, operand))
	}

	// MARK: - Expression protocol

	func eval() -> Int {
		var result = parts[0].operand.eval()  // operation of first part is ignored
		for i in 1..<parts.count {
			let (op, operand) = parts[i]
			switch op {
			case "+":
				result += operand.eval()
			case "*":
				result *= operand.eval()
			default:
				abort()
			}
		}
		return result
	}

	func asString() -> String {
		var result = parts[0].operand.asString()

		for i in 1..<parts.count {
			let (op, operand) = parts[i]
			result = "\(result) \(op) \(operand.asString())"
		}

		if parts.isEmpty {
			return result
		} else {
			return "(\(result))"
		}
	}

	// MARK: - Private stuff

	internal func applyPrecedence() {
		for (_, operand) in parts { operand.applyPrecedence() }

		var newParts = [parts[0]]
		for i in 1..<parts.count {
			let (op, operand) = parts[i]
			if op == "+" {
				newParts[newParts.count - 1].operand = PlusExpression(newParts[newParts.count - 1].operand, operand)
			} else if op == "*" {
				newParts.append((op, operand))
			} else {
				abort()
			}
		}

		parts = newParts
	}
}

class PlusExpression: Expression {
	var arg1: Expression
	var arg2: Expression

	init(_ arg1: Expression, _ arg2: Expression) {
		self.arg1 = arg1
		self.arg2 = arg2
	}

	// MARK: - Expression protocol

	func eval() -> Int {
		return arg1.eval() + arg2.eval()
	}

	func asString() -> String {
		return "(\(arg1.asString()) + \(arg2.asString()))"
	}
}

func parseExpression(_ s: String) -> CompoundExpression {
	func eval() -> CompoundExpression {
		func processExpression(_ expr: Expression) {
			if result == nil {
				result = CompoundExpression(initialSubexpression: expr)
			} else {
				result!.add(op: op!, operand: expr)
				op = nil
			}
		}

		var op: String?
		var result: CompoundExpression?
		while charIndex < chars.count {
			let ch = chars[charIndex]
			charIndex += 1

			switch ch {
			case " ":
				// We can ignore spaces.
				()
			case "1"..."9":
				processExpression(NumberExpression(Int(ch)!))
			case "+", "*":
				assert(op == nil)
				op = ch
			case "(":
				processExpression(eval())
			case ")":
				return result!
			default:
				abort()
			}
		}
		return result!
	}

	let chars = s.map { String($0) }
	var charIndex = 0
	return eval()
}
