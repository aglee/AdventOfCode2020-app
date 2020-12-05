import Foundation

class Test {
	let name: String
	let testBlock: () -> String
	let expectedOutput: String

	init(name: String, testBlock: @escaping () -> String, expectedOutput: String) {
		self.name = name
		self.testBlock = testBlock
		self.expectedOutput = expectedOutput
	}

	func doTest() -> String {
		return testBlock()
	}
}

/// Convenience methods for creating `Test` instances.
extension DayNN {
	/// Convenience method for creating a `Test` instance.
	func testPart1(fileNumber: Int, expectedOutput: String) -> Test {
		let resourceName = testInputFileName(fileNumber: fileNumber)
		return Test(name: resourceName,
					testBlock: {
						let inputLines = self.testInputLines(fileNumber: fileNumber)
						return self.solvePart1(inputLines: inputLines)
					},
					expectedOutput: expectedOutput)
	}

	/// Convenience method for creating a `Test` instance.
	func testPart2(fileNumber: Int, expectedOutput: String) -> Test {
		let resourceName = testInputFileName(fileNumber: fileNumber)
		return Test(name: resourceName,
					testBlock: {
						let inputLines = self.testInputLines(fileNumber: fileNumber)
						return self.solvePart2(inputLines: inputLines)
					},
					expectedOutput: expectedOutput)
	}

	/// Convenience method for creating a `Test` instance.
	func testValidString(_ validationFunction: @escaping (String) -> Bool,
						 _ s: String,
						 _ isValid: Bool) -> Test {
		return Test(name: s,
					testBlock: { String(validationFunction(s)) },
					expectedOutput: String(isValid))
	}
}


