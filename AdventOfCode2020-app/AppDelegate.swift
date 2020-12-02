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
//		mainWC = MainWindowController(windowNibName: "MainWindowController")
//		mainWC.window?.display()

		// For the moment there is no UI.  The intention is to implement the UI over time.
		let day = Day02()
		let _ = day.testPart1()
		let _ = day.testPart2()
		print("Part 1 solution: \(day.solvePart1())")
		print("Part 2 solution: \(day.solvePart2())")
		NSApplication.shared.terminate(nil)
	}
}

