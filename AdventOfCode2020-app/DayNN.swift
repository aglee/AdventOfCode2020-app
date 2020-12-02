//
//  DayNN.swift
//  AdventOfCode2020-app
//
//  Created by Andy Lee on 11/30/20.
//

import Foundation

/// Represents one day of [Advent of Code](https://adventofcode.com).
///
/// This is treated as an abstract base class -- it should not be instantiated directly.
/// There is one subclass for each day of Advent of Code.  The subclasses are named
/// `Day01`, `Day02`, etc., through `Day25`.  Note that it's important to stick to this
/// naming convention, as our `dayNumber` property is derived from the class name.
///
/// For each subclass a number of text files are included as resources in the application
/// bundle.  These files also have a naming convention:
///
/// - Description of Part 1 of the puzzle (e.g. `Day01_Part1.txt`), copied from the website.
/// - Description of Part 2 of the puzzle (e.g. `Day01_Part2.txt`), copied from the website.
/// - One or more test inputs (e.g. `Day01_TestInput01.txt`, `Day01_TestInput02.txt`, etc.).
///   The corresponding expected outputs are coded into the `expectedPart1TestResults` and
///   `expectedPart2TestResults` properties.
/// - The "real" input (e.g. `Day01_Input.txt`).
/// - Discussion of my solution (e.g. `Day01_Discussion.md`).
class DayNN: NSObject {
	var title: String

	/// We derive the day number from the last 2 characters of the class name.
	var dayNumber: Int { return Int(self.className.suffix(2))! }

	/// Description of Part 1 of this day's puzzle.
	var part1PuzzleText: String { return puzzleText(puzzlePart: 1) }

	/// Description of Part 2 of this day's puzzle.
	var part2PuzzleText: String { return puzzleText(puzzlePart: 2) }

	/// Subclasses must override this.  Maps test input file numbers to expected test
	/// results.  For each test input file number, `solvePart1(inputLines:)` is run with
	/// the contents of that file, and the result is compared with the expected result.
	var expectedPart1TestResults: [Int: String] { return [:] }

	/// Subclasses must override this.  Just like `expectedPart1TestResults`, but using
	/// `solvePart2(inputLines:)`.
	var expectedPart2TestResults: [Int: String] { return [:] }

	var discussionMarkdownText: String {
		let resourceName = String(format: "Day%02d_Discussion.md", dayNumber)
		return stringFromTextResource(resourceName)
	}

	init(_ title: String) {
		self.title = title
	}

	// MARK: - Solving

	/// Subclasses must override this.
	func solvePart1(inputLines: [String]) -> String {
		return "Part 1 of Day \(dayNumber) is not yet solved"
	}

	/// Subclasses must override this.
	func solvePart2(inputLines: [String]) -> String {
		return "Part 2 of Day \(dayNumber) is not yet solved"
	}

	final func solvePart1() -> String {
		return solvePart1(inputLines: realInputLines())
	}

	/// Subclasses must override this.
	final func solvePart2() -> String {
		return solvePart2(inputLines: realInputLines())
	}

	// MARK: - Testing

	final func testPart1() -> Bool {
		doTests(expectedPart1TestResults, solvePart1)
	}

	final func testPart2() -> Bool {
		doTests(expectedPart2TestResults, solvePart2)
	}

	// MARK: - NSObject overrides

	override var description: String {
		return "Day \(dayNumber) - \(title)"
	}

	// MARK: - Private stuff

	private func realInputLines() -> [String] {
		let resourceName = String(format: "Day%02d_Input.txt", dayNumber)
		return linesFromTextResource(resourceName)
	}

	private func testInputLines(fileNumber: Int) -> [String] {
		let resourceName = String(format: "Day%02d_TestInput%02d.txt", dayNumber, fileNumber)
		return linesFromTextResource(resourceName)
	}

	/// Reads text from a resource in the application bundle.
	/// - Parameter resourceName : The full file name, including extension.
	private func stringFromTextResource(_ resourceName: String) -> String {
		let resourceURL = Bundle.main.url(forResource: resourceName, withExtension: "")!
		let resourceData = try! Data(contentsOf: resourceURL)
		return String(data: resourceData, encoding: .utf8)!
	}

	private func linesFromTextResource(_ resourceName: String) -> [String] {
		return stringFromTextResource(resourceName).split(separator: "\n").map { String($0) }
	}

	/// `puzzlePart` should be 1 or 2
	private func puzzleText(puzzlePart: Int) -> String {
		let resourceName = String(format: "Day%02d_Part%d.txt", dayNumber, puzzlePart)
		return stringFromTextResource(resourceName)
	}

	private func doTests(_ tests: [Int: String], _ solve: ([String])->String) -> Bool {

		for testNumber in tests.keys.sorted() {
			let testResult = solve(testInputLines(fileNumber: testNumber))
			print("expected '\(tests[testNumber]!)', got '\(testResult)'")
		}

		return true
	}
}
