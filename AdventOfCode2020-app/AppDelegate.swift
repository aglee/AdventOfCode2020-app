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

		doOneDay(Day03())
		NSApplication.shared.terminate(nil)
	}

	// MARK: - Private stuff

	private func doOneDay(_ day: DayNN) {
		print("===== Day \(day.dayNumber): \(day.title) =====")
		print()
		print("--- Part 1 ---")
		if day.testPart1() {
			print("Answer for Part 1: \(day.solvePart1())")
		}
		print()

		print("--- Part 2 ---")
		if day.testPart2() {
			print("Answer for Part 2: \(day.solvePart2())")
		}
		print()
	}
}

