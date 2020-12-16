//
//  AppDelegate.swift
//  AdventOfCode2020-app
//
//  Created by Andy Lee on 11/30/20.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
	var mainWC: MainWindowController!

	func applicationDidFinishLaunching(_ aNotification: Notification) {
// For the moment there is no UI.  The intention is to implement the UI over time.
//		mainWC = MainWindowController(windowNibName: "MainWindowController")
//		mainWC.window?.display()

//		for d in [Day01(), Day02(), Day03(), Day04(), Day05(), Day06()] {
//			doOneDay(d)
//		}
		doOneDay(Day17())
		NSApplication.shared.terminate(nil)
	}

	// MARK: - Private stuff

	/// Returns true if all tests pass.
	private func runTests(_ tests: [Test]) -> Bool {
		print("\(tests.count) test\(tests.count == 1 ? " was" : "s were") specified.")

		for test in tests {
			print("Test '\(test.name)' -- Starting...")
			let testResult = test.doTest()
			if testResult == test.expectedResult {
				print("Test '\(test.name)' -- PASSED")
			} else {
				print("Test '\(test.name)' -- FAILED: expected '\(test.expectedResult)', got '\(testResult)'")
				return false
			}
		}

		// If we got this far, all tests passed.
		print("All tests passed.")
		return true
	}

	private func doOneDay(_ day: DayNN) {
		print("===== Day \(day.dayNumber): \(day.title) =====")
		print()

		print("--- Part 1 ---")
		guard runTests(day.part1Tests) else { return }
		print("Part 1 final answer -- Starting...")
		print("Part 1 final answer -- \(day.solvePart1())")
		print()

		print("--- Part 2 ---")
		guard runTests(day.part2Tests) else { return }
		print("Part 2 final answer -- Starting...")
		print("Part 2 final answer -- \(day.solvePart2())")
		print()
	}
}

