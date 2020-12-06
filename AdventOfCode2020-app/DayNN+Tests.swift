import Foundation

class Test {
	let name: String
	let testBlock: () -> String
	let expectedResult: String

	init(name: String, testBlock: @escaping () -> String, expectedResult: String) {
		self.name = name
		self.testBlock = testBlock
		self.expectedResult = expectedResult
	}

	func doTest() -> String {
		return testBlock()
	}
}

/// Convenience methods for creating `Test` instances.
extension DayNN {
	// MARK: - Testing lines read from DayXX_TestInputYY.txt files

	/// Runs `function` on lines read from the specified test input file.
	func test(fileNumber: Int, function: @escaping ([String]) -> String, expectedResult: String) -> Test {
		let resourceName = testInputFileName(fileNumber: fileNumber)
		return Test(name: resourceName,
					testBlock: { function(self.linesFromTextResource(resourceName))	},
					expectedResult: expectedResult)
	}

	/// Runs `solvePart1` on lines read from the specified test input file.
	func testPart1(fileNumber: Int, expectedResult: String) -> Test {
		return test(fileNumber: fileNumber, function: solvePart1, expectedResult: expectedResult)
	}

	/// Runs `solvePart2` on lines read from the specified test input file.
	func testPart2(fileNumber: Int, expectedResult: String) -> Test {
		return test(fileNumber: fileNumber, function: solvePart2, expectedResult: expectedResult)
	}

	// MARK: - Testing a single string

	/// Runs `function` on the given input string.  Since `function` returns a String,
	/// this could be thought of as a string conversion test.
	func test(input: String, function: @escaping (String) -> String, expectedResult: String) -> Test {
		return Test(name: input,
					testBlock: { function(input) },
					expectedResult: expectedResult)
	}

	/// Runs `function` on the given input string.  Since `function` returns a Bool,
	/// this could be thought of as a field validation test.
	func test(input: String, function: @escaping (String) -> Bool, expectedResult: Bool) -> Test {
		return Test(name: input,
					testBlock: { String(function(input)) },
					expectedResult: String(expectedResult))
	}
}


