import Foundation

enum ParameterMode: Int {
	case positionMode, immediateMode, relativeMode
}

/// Indicates the running status of an `IntcodeVM`.
enum ProgramStatus {
	case running, paused, waitingForInput, terminated
}

/// It seems that every year, Advent of Code has a series of puzzles that involve an
/// intcode VM.  The rules vary from year to year; tweak this class accordingly.
class IntcodeVM {
	private(set) var programStatus = ProgramStatus.paused
	private var memory: Memory
	private var instructionPointer = 0
	private var input = Array<Int>()
	private var output = Array<Int>()
	private var relativeBase = 0

	init(intcode: [Int]) {
		self.memory = Memory(memoryValues: intcode)
	}

	convenience init(sourceCode: String) {
		self.init(intcode: sourceCode.split(separator: ",").map { Int($0)! })
	}

	/// Queues up the given value to be used when the program asks for input.
	func addInput(_ inputValue: Int) {
		input.append(inputValue)
		if programStatus == .waitingForInput {
			programStatus = .paused
		}
	}

	/// Returns the contents of the output buffer, and clears the buffer.
	func flushOutput() -> [Int] {
		let outputToReturn = output
		output = []
		return outputToReturn
	}

	/// Executes instructions starting from the current instruction pointer, until either the program terminates, is paused,
	/// or is waiting for input with an empty input queue.
	func run() {
		repeat {
			step()
		} while programStatus == .running
	}

	private func step() {
		programStatus = .running

		let opcode = memory[instructionPointer] % 100
		if opcode == 99 {
			programStatus = .terminated
			return
		}

		var parameterModes = Array<ParameterMode>()
		var n = memory[instructionPointer] / 100
		for _ in 0..<3 {
			parameterModes.append(ParameterMode(rawValue: n % 10)!)
			n = n / 10
		}

		/// Called when the parameter should evaluate to an operand for the operation indicated by the opcode.
		func operandParameter(_ parameterPosition: Int) -> Int {
			let rawParameter = memory[instructionPointer + parameterPosition + 1]
			switch parameterModes[parameterPosition] {
			case .positionMode:
				return memory[rawParameter]
			case .immediateMode:
				return rawParameter
			case .relativeMode:
				// Same as position mode except address is offset from relative base.
				return memory[relativeBase + rawParameter]
			}
		}

		/// Called when the parameter should evaluate to the address at which we will store the result of the operation.
		func resultAddressParameter(_ parameterPosition: Int) -> Int {
			let rawParameter = memory[instructionPointer + parameterPosition + 1]
			switch parameterModes[parameterPosition] {
			case .positionMode:
				return rawParameter
			case .immediateMode:
				ERRORPRINT("The parameter mode of a result address parameter should never be immediate mode.")
				abort()
			case .relativeMode:
				// Same as position mode except address is offset from relative base.
				return relativeBase + rawParameter
			}
		}

		switch opcode {
		case 1:
			// add
			memory[resultAddressParameter(2)] = operandParameter(0) + operandParameter(1)
			instructionPointer += 4
		case 2:
			// multiply
			memory[resultAddressParameter(2)] = operandParameter(0) * operandParameter(1)
			instructionPointer += 4
		case 3:
			// read input
			if input.count > 0 {
				memory[resultAddressParameter(0)] = input.removeFirst()
				instructionPointer += 2
			} else {
				programStatus = .waitingForInput
			}
		case 4:
			// write output
			output.append(operandParameter(0))
			instructionPointer += 2
		case 5:
			// jump-if-true
			if operandParameter(0) == 0 {
				instructionPointer += 3
			} else {
				instructionPointer = operandParameter(1)
			}
		case 6:
			// jump-if-false
			if operandParameter(0) != 0 {
				instructionPointer += 3
			} else {
				instructionPointer = operandParameter(1)
			}
		case 7:
			// less-than
			if operandParameter(0) < operandParameter(1) {
				memory[resultAddressParameter(2)] = 1
			} else {
				memory[resultAddressParameter(2)] = 0
			}
			instructionPointer += 4
		case 8:
			// equals
			if operandParameter(0) == operandParameter(1) {
				memory[resultAddressParameter(2)] = 1
			} else {
				memory[resultAddressParameter(2)] = 0
			}
			instructionPointer += 4
		case 9:
			// adjust relative base
			relativeBase += operandParameter(0)
			instructionPointer += 2
		default:
			ERRORPRINT("Unexpected opcode \(opcode)")
			abort()
		}
	}
}

