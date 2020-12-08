import Foundation

class Console {
	typealias Instruction = (op: String, arg: Int)
	
	var accumulator = 0
	var program: [Instruction] = []
	/// Program counter -- `program[pc]` is the instruction that will be executed next.
	var pc = 0

	init(_ inputLines: [String]) {
		for line in inputLines {
			let opAndArg = line.split(separator: " ").map { String($0) }
			let op = opAndArg[0]
			let arg = Int(opAndArg[1])!
			program.append((op: op, arg: arg))
		}
	}

	/// Executes the instruction at `pc`.
	func step() {
		let instruction = program[pc]
		switch instruction.op {
		case "acc":
			accumulator += instruction.arg
			pc += 1
		case "jmp":
			pc += instruction.arg
		case "nop":
			pc += 1
		default:
			abort()
		}
	}

	/// Sets `accumulator` and `pc` to 0.
	func reset() {
		accumulator = 0
		pc = 0
	}

	/// Start with a `reset`.  Then repeatedly execute instructions until **either** we're
	/// about to execute an instruction we've already executed, **or** our program counter
	/// is out of range.
	///
	/// - Complexity:	O(n).  Worst case, we'll have to execute every instruction in the
	///					program before we repeat one.
	/// eventually.
	func run() {
		reset()
		var previousPCs = Set<Int>()
		while true {
			// Terminate if we're about to execute an instruction we already executed.
			if previousPCs.contains(pc) {
				return
			}

			// Terminate if the program counter is out of bounds.
			if pc < 0 || pc >= program.count {
				return
			}

			// If we got this far, execute the current instruction.
			previousPCs.insert(pc)
			step()
		}
	}

	func dumpProgram() {
		for (index, instruction) in program.enumerated() {
			print("\(index): \(instruction)")
		}
	}
}

class Day08: DayNN {
	init() {
		super.init("Handheld Halting")
		self.part1Tests = [
			testPart1(fileNumber: 1, expectedResult: "5"),
		]
		self.part2Tests = [
			testPart2(fileNumber: 1, expectedResult: "8"),
		]
	}

	// MARK: - Solving

	override func solvePart1(inputLines: [String]) -> String {
		let console = Console(inputLines)
		console.run()
		return(String(console.accumulator))
	}

	/// - Complexity:	O(n^2).  Worst case, we'll have to try flipping every instruction
	///					in the program and running that modified program.  That would mean
	///					calling `run()` n times, and `run()` is O(n).
	override func solvePart2(inputLines: [String]) -> String {
		func flipInstruction(_ index: Int) -> Bool {
			switch console.program[index].op {
			case "jmp":
				console.program[index].op = "nop"
				return true
			case "nop":
				console.program[index].op = "jmp"
				return true
			default:
				return false
			}
		}

		let console = Console(inputLines)

		// On each iteration, temporarily "flip" one instruction in the program (change
		// "jmp" to "nop" and vice versa).  See if the resulting program is "fixed" (i.e.
		// terminates with `pc` pointing immediately after the last instruction).
		for flipIndex in 0..<console.program.count {
			// Flip the current instruction if possible.  If not, skip it.
			if !flipInstruction(flipIndex) {
				continue
			}

			// Run the program and see if the change we made "fixed" it.
			console.run()
			if console.pc == console.program.count {
				return String(console.accumulator)
			}

			// If we got this far, we have not found our solution.  Flip the instruction
			// again so the program is back to its original state.
			let _ = flipInstruction(flipIndex)
		}

		// We should not get this far.
		abort()
	}
}


